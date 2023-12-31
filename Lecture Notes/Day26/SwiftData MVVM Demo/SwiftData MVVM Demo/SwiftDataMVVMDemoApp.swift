//
//  SwiftData_MVVM_DemoApp.swift
//  SwiftData MVVM Demo
//
//  Created by Stephen Liddle on 12/6/23.
//

import SwiftUI
import SwiftData

@main
struct SwiftData_MVVM_DemoApp: App {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
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
            // Note that here we are passing the ModelContext that comes from
            // this app's ModelContainer into our top-level View.  This is so
            // that View can set up the ViewModel.
            ContentView(sharedModelContainer.mainContext)
        }
        .modelContainer(sharedModelContainer)
    }
}
