//
//  ViewController.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/17/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var itemArray = [Item]()
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("hereThingsGetSaved.plist")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//print(dataFilePath)
		
		loadItems()
		
		// Do any additional setup after loading the view.
	}
	
	// MARK: - TableView Datasource methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
	
		cell.textLabel?.text = itemArray[indexPath.row].title
		
		if itemArray[indexPath.row].done {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	// MARK: - TableView Delegate methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done
		
		saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}

	// MARK: - Data manipulation methods
	
	// save items
	func saveItems() {
		
		// encode as .plist
		let encoder = PropertyListEncoder()
		
		do {
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("******************************** Error encoding: \(error)")
		}
		
		// reload view
		self.tableView.reloadData()
	}
	
	// load items
	func loadItems() {
		
		if let data = try? Data(contentsOf: dataFilePath!) {
			let decoder = PropertyListDecoder()
			
			do {
				itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("******************************** Error decoding: \(error)")
			}

			
		}
		
		
		// reload view
		self.tableView.reloadData()
	}
	
	// MARK: - addButton gets pressed
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController.init(title: "add new item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction.init(title: "Add item", style: .default) { (action) in
			
			// add new item
			let newItem = Item()
			newItem.title = textField.text!
			self.itemArray.append(newItem)
			
			self.saveItems()
			

		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
			
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
}

