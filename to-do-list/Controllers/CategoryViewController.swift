//
//  CategoryViewController.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/10/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

	var categoryArray = [Category]()
	
	// shared.delegate is the singleton instance of UIApplication
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()

		loadCategory()
    }

	// MARK: - TableView Datasource methods
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoryArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
				
		let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
		
		cell.textLabel?.text = categoryArray[indexPath.row].name
		
		return cell
	}
	
	// MARK: - Data manipulation methods
	
	// save category
	func saveCategory() {
		
		do {
			try context.save()
		} catch {
			print("Error saving context. \(error)")
		}
		
		// reload view
		self.tableView.reloadData()
	}
	
	// load category
	func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
		
		do {
			categoryArray = try context.fetch(request)
		} catch {
			print("Error fetching context. \(error)")
		}
		
		// reload view
		self.tableView.reloadData()
	}
	
	// MARK: - addButton gets pressed
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
				
		let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
				
		let action = UIAlertAction(title: "Add category", style: .default) { (action) in
			
			// add new category
			let newCategory = Category(context: self.context)
									
			newCategory.name = textField.text!
			
			self.categoryArray.append(newCategory)
			self.saveCategory()
		}
				
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new category"
			textField = alertTextField
		}
				
				
		alert.addAction(action)
				
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - TableView Delegate methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	// SEGUE
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categoryArray[indexPath.row]
		}
	}
}
