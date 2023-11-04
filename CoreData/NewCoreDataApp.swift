//
//  NewCoreDataApp.swift
//  CoreData
//
//  Created by Elaidzha Shchukin on 03.11.2023.
//

import SwiftUI

@main
struct NewCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
