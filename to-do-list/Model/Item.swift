//
//  Item.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/12/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title : String = ""
	@objc dynamic var done : Bool = false
	@objc dynamic var dateCreated : Date?
	
	//relationship with category
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
