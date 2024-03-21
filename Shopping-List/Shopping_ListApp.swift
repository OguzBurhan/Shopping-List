//
//  Shopping_ListApp.swift
//  Shopping-List
//
//  Created by Oguz Burhan on 2024-03-21.
//

import SwiftUI

@main
struct Shopping_ListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
