//
//  Item.swift
//  to-do-list
//
//  Created by Ricardo Avendaño on 8/17/20.
//  Copyright © 2020 Ricardo Avendaño. All rights reserved.
//

import Foundation

// inheriting from codable replaces the need to use encodable or decodable
class Item: Codable {
	var title : String = ""
	var done : Bool = false
}
