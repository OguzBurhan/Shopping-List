//
//  Shopping_ListApp.swift
//  Shopping-List
//
//  Created by Oguz Burhan on 2024-03-21.
//

import SwiftUI
import CoreData

@main
struct Shopping_ListApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var loginManager = LoginManager() // Create a LoginManager instance
    @StateObject var shoppingListManager = ShoppingListManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(loginManager)
                .environmentObject(shoppingListManager)
        }
    }
}
