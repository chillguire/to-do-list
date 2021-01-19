//
//  CategoryViewController.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/10/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

	let realm = try! Realm()
	
	var categoryArray : Results<Category>?
	
	// MARK: - view gets loaded
	
    override func viewDidLoad() {
        super.viewDidLoad()
	
		loadCategory()
    }

	// MARK: - basic methods for UITableViewController
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return categoryArray?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
						
		cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
		
		cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].backgroundColour ?? "AF52DE")
		
		cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categoryArray?[indexPath.row].backgroundColour ?? "AF52DE")!, returnFlat: true)
		
		tableView.separatorStyle = .none

		return cell
	}
	
	// MARK: - data manipulation CRUD methods

	// Save category
	func save(category: Category) {
		do {
			try realm.write{
				realm.add(category)
			}
		} catch {
			print("Error saving context. \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	// Load category
	func loadCategory() {
		
		categoryArray = realm.objects(Category.self)

		self.tableView.reloadData()
	}
	
	// Delete category
	override func updateModel(at indexPath: IndexPath) {
		if let categoryForDeletion = self.categoryArray?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(categoryForDeletion)
				}
			} catch {
				print(error)
			}

		} else {
			print("Add success message")
		}
	}
	
	// MARK: - + button gets pressed
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
				
		let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
				
		let action = UIAlertAction(title: "Add category", style: .default) { (action) in
			
			let newCategory = Category()
									
			newCategory.name = textField.text!
			newCategory.backgroundColour = UIColor.randomFlat().hexValue()
						
			self.save(category: newCategory)
		}
				
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new category"
			textField = alertTextField
		}
				
				
		alert.addAction(action)
				
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - events
	
	// X row gets selected
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	// OJO
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		
		if let indexPath = tableView.indexPathForSelectedRow {
			destinationVC.selectedCategory = categoryArray?[indexPath.row]
		}
	}
}

