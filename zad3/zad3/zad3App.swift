//
//  zad3App.swift
//  zad3
//
//  Created by user279406 on 12/4/25.
//

import SwiftUI

@main
struct zad3App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
