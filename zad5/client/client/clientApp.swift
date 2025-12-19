//
//  clientApp.swift
//  client
//
//  Created by user279406 on 12/19/25.
//

import SwiftUI

@main
struct clientApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
