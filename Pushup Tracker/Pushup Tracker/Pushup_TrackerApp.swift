//
//  Pushup_TrackerApp.swift
//  Pushup Tracker
//
//  Created by Lehi Alcantara on 9/18/23.
//

import SwiftUI

@main
struct Pushup_TrackerApp: App {
    var body: some Scene {
        WindowGroup {
            PushupTrackerView(pushupviewModel: PushupViewModel())
        }
    }
}
