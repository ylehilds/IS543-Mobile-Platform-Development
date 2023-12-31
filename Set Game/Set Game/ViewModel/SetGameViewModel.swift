//
//  SetGameViewModel.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/15/23.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    typealias Card = SetGame.Card
    @Published private var model = SetGame()
    
    // MARK: - Model Access
    
    var selectedCards: [Card] {
        model.dealtCards.filter({ $0.isSelected })
    }
    
    var deck: [Card] {
        model.deck
    }
    
    var matchedCards: [Card] {
        model.matchedCards
    }
    
    var dealtCards: [Card] {
        model.dealtCards
    }
    
    // MARK: User Intents
    
    func newGame() {
        model = SetGame()
        model.dealCards()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func dealCards() {
        model.dealCards()
    }
}
