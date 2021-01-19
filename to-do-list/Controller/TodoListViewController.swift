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
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let newItem = Item()
		newItem.title = "New item"
		itemArray.append(newItem)
		
		let newItemTrue = Item()
		newItemTrue.title = "New item checked"
		newItemTrue.done = true
		itemArray.append(newItemTrue)
		
		if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
			itemArray = items
		}
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
		
		tableView.reloadData()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}

	// MARK: - addButton gets pressed
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController.init(title: "Add new item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction.init(title: "Add item", style: .default) { (action) in
			
			// what happens when action gets pressed
			let newItem = Item()
			
			newItem.title = textField.text!
			
			self.itemArray.append(newItem)
			
			self.defaults.set(self.itemArray, forKey: "TodoListArray")
			
			self.tableView.reloadData()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
			
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
}

