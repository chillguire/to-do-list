//
//  ViewController.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/8/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
	
	let realm = try! Realm()

	var itemArray : Results<Item>?
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	// connection with category
	var selectedCategory : Category? {
		didSet {
			loadItems()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.separatorStyle = .none
	}
	
	override func viewWillAppear(_ animated: Bool) {
		title = selectedCategory!.name
		
		changeTitleColor(colour: UIColor(hexString:selectedCategory?.backgroundColour ??  "AF52DE")!)
		
		searchBar.barTintColor = UIColor(hexString:selectedCategory?.backgroundColour ??  "AF52DE")!
	}

	// MARK: - Basic methods for UITableViewController
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let item = itemArray?[indexPath.row] {
			cell.textLabel?.text = item.title
			
			
			
			if let colour = UIColor(hexString: selectedCategory!.backgroundColour)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)) {
				cell.backgroundColor = colour
				cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
				
			} else {
				cell.backgroundColor = UIColor.flatPurple()
			}
			
			//Ternary operator - f*ck ternary operator, all my homies like readable code.
			//cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
			
			if item.done {
				cell.accessoryType = .checkmark
			} else {
				cell.accessoryType = .none
			}
		} else {
			cell.textLabel?.text = "No items added"
		}
		
		return cell
	}
	
	// MARK: - row gets selected

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = itemArray?[indexPath.row] {
			
			do {
				try realm.write {
					
					// realm.delete(item)
					
					item.done = !item.done
				}
			} catch {
				print("Error saving context. \(error)")
			}
		}
		
		self.tableView.reloadData()
				
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - add items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
						
			if let currentCategory = self.selectedCategory {
				
				do {
					try self.realm.write{
						let newItem = Item()
				
						newItem.title = textField.text!
						
						newItem.dateCreated = Date()
						
						currentCategory.items.append(newItem)
					}
				} catch {
					print("Error saving context. \(error)")
				}

				self.tableView.reloadData()
			}
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Load items
	
	func loadItems() {

		itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		
		self.tableView.reloadData()
	}
	
	// MARK: - Delete items
	
	override func updateModel(at indexPath: IndexPath) {
		if let itemForDeletion = self.itemArray?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(itemForDeletion)
				}
			} catch {
				print(error)
			}

		} else {
			print("Add success message")
		}
	}
}

// MARK: - Search bar methods

extension TodoListViewController: UISearchBarDelegate {


	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		
		tableView.reloadData()
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()

			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}

}
