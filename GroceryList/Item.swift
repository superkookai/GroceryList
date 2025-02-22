//
//  Item.swift
//  GroceryList
//
//  Created by Weerawut Chaiyasomboon on 22/2/2568 BE.
//

import Foundation
import SwiftData

//Model <-> ModelContainer <-> ModelContext <-> View

@Model
class Item {
    var title: String
    var isCompleted: Bool
    
    init(title: String, isCompleted: Bool) {
        self.title = title
        self.isCompleted = isCompleted
    }
}
