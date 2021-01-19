//
//  Category.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/12/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name : String = ""
	@objc dynamic var backgroundColour : String = ""
	
	let items = List<Item>()
}
