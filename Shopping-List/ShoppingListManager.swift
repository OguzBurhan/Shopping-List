//
//  ShoppingListManager.swift
//  Shopping-List
//
//  Created by Oguz Burhan on 2024-03-25.
//

import Foundation
class ShoppingListManager: ObservableObject {
    @Published var items: [String] = [] // Stores product names for simplicity
    
    func addProduct(_ productName: String) {
        items.append(productName)
    }
}
