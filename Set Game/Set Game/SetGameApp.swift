//
//  SetGameApp.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/15/23.
//

import SwiftUI

@main
struct SetGameApp: App {
    private let game = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: game)
        }
    }
}
