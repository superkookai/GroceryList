//
//  GroceryListApp.swift
//  GroceryList
//
//  Created by Weerawut Chaiyasomboon on 22/2/2568 BE.
//

import SwiftUI
import SwiftData

@main
struct GroceryListApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Item.self)
        }
    }
}
