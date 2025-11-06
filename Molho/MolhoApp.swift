//
//  MolhoApp.swift
//  Molho
//
//  Created by Bruno Queiroz on 06/11/25.
//

import SwiftUI
import CoreData

@main
struct MolhoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
