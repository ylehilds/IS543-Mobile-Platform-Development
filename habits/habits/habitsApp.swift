//
//  habitsApp.swift
//  habits
//
//  Created by Lehi Alcantara on 12/21/23.
//

import SwiftUI
import SwiftData

@main
struct habitsApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Goal.self,
            Category.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
