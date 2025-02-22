//
//  Tip.swift
//  GroceryList
//
//  Created by Weerawut Chaiyasomboon on 22/2/2568 BE.
//

import Foundation
import TipKit

struct ButtonTip: Tip {
    var title: Text = Text("Essential Foods")
    var message: Text? = Text("Add some everyday items to shopping list")
    var image: Image? = Image(systemName: "info.circle")
}
