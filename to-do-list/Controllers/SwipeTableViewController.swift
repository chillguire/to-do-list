//
//  SwipeTableViewController.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/13/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
	
	tableView.rowHeight = 80.0

	}
	override func viewWillAppear(_ animated: Bool) {
		// Truquito para que el status bar sea del color system purple jijiji
		changeTitleColor(colour: UIColor.systemPurple)
	}
	
	
	// MARK: - Delegate methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell
		
		cell.selectionStyle = .none
								
		cell.delegate = self

		return cell
	}

	// MARK: - Delegate methods SWIPE
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
	    guard orientation == .right else { return nil }

	    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
		   // handle action by updating model with deletion
		
		self.updateModel(at: indexPath)
		
		}

	    // customize the action appearance
	    deleteAction.image = UIImage(named: "delete-icon")

	    return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
	    var options = SwipeOptions()
	    options.expansionStyle = .destructive
	    options.transitionStyle = .border
	    return options
	}
	
	func updateModel(at indexPath: IndexPath) {
		
	}
	
	func changeTitleColor(colour: UIColor) {
		if #available(iOS 13.0, *) {
			let navBarAppearance = UINavigationBarAppearance()
			navBarAppearance.configureWithOpaqueBackground()
			navBarAppearance.backgroundColor = colour
			navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(colour, returnFlat: true)]
			navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(colour, returnFlat: true)]
			
			navigationController?.navigationBar.tintColor = ContrastColorOf(colour, returnFlat: true)
			
			
			navigationController?.navigationBar.standardAppearance = navBarAppearance
			navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
		}

	}

}
