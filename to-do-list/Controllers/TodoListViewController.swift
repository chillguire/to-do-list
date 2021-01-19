//
//  ViewController.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/8/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	
	// SEGUE
	var selectedCategory : Category? {
		didSet {
			loadItems()
		}
	}
	
	// shared.delegate is the singleton instance of UIApplication
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

	override func viewDidLoad() {
		super.viewDidLoad()
				
	}

	// MARK: - TableView Datasource methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
				
		let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
		
		cell.textLabel?.text = itemArray[indexPath.row].title
		
		//Ternary operator
		//cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
		
		if itemArray[indexPath.row].done {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	// MARK: - TableView Delegate methods

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// if i want to be able to delete at some point, this is the basic functionality.
//		context.delete(itemArray[indexPath.row])
//		itemArray.remove(at: indexPath.row)
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		saveItems()
				
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: - Data manipulation methods
	
	// save items
	func saveItems() {
		
		do {
			try context.save()
		} catch {
			print("Error saving context. \(error)")
		}
		
		// reload view
		self.tableView.reloadData()
	}
	
	// load items
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}

		do {
			itemArray = try context.fetch(request)
		} catch {
			print("Error fetching context. \(error)")
		}
		
		// reload view
		self.tableView.reloadData()
	}
	
	
	
	// MARK: - addButton gets pressed
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			// this is a closure, defines what happens when the action gets tapped
			
			// add new item
			let newItem = Item(context: self.context)
			
			newItem.title = textField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			
			self.itemArray.append(newItem)
			self.saveItems()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			// creamos 'textField' por  el scope de las funciones, para acceder a ella. a alertTextField no podemos acceder, a textField sí porqué esta declarada en la función global.
			textField = alertTextField
		}
		
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
}

// MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
	
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request : NSFetchRequest<Item> = Item.fetchRequest()
	
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
	
		loadItems(with: request, predicate: predicate)
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
