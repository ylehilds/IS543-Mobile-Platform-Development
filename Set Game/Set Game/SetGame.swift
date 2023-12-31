//
//  SetGame.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/15/23.
//

import Foundation

enum CardAttributeVariant: Int, CaseIterable {
    case one = 1, two = 2, three = 3
}

struct SetGame {
    static let initialDealtCards = 12
    private(set) var idsOfSelectedCards = [Int]()
    private(set) var matchedCards = [Card]()
    private var dealtCardsMatched: Bool { dealtCards.contains { $0.isMatched } }
    private(set) var deck: [Card]
    private(set) var dealtCards = [Card]()
    
    init () {
        self.deck = SetGame.createCardDeck()
    }
    
    mutating func dealCards() {
        // We should never allow dealing more than 81 cards
        guard dealtCards.count < 81 else { return }
        // if there are dealt cards then deal 3, otherwise start with 12
        let numberOfCardsToDeal = dealtCards.count > 0 ? 3 : SetGame.initialDealtCards
        
        // remove the matched ones when dealing more cards
        if dealtCardsMatched {
            var replacedCards = 0
            dealtCards.indices.forEach {
                if dealtCards[$0].isMatched && replacedCards < 3 {
                    matchedCards.append(dealtCards[$0])
                    dealtCards[$0] = deck[0]
                    deck.remove(at: 0)
                    replacedCards += 1
                }
            }
        } else {
            // 3 more cards to dealtCards array
            dealtCards.append(contentsOf: deck[0..<numberOfCardsToDeal])
            // remove 3 cards from deck
            deck.removeSubrange(0..<numberOfCardsToDeal)
        }
    }
    
    private func isSet(of cards: [Card]) -> Bool {
        guard cards.count == 3 else { return false }
        
        // The Set Game 4 rules that qualifies as a set:
        // All cards must have the same number or 3 different numbers
        // All cards must have the same shape or 3 different shapes
        // All cards must have the same color or 3 different colors
        // All cards must have the same shading or 3 different patterns
        
        // Pull the selected cards
        let card1 = cards[0]
        let card2 = cards[1]
        let card3 = cards[2]
        
        // All cards must have the same color or 3 different colors
        if card1.attributes.color == card2.attributes.color && card2.attributes.color == card3.attributes.color || card1.attributes.color != card2.attributes.color && card2.attributes.color != card3.attributes.color
        {
            // All cards must have the same shape or 3 different shapes
            if card1.attributes.shape == card2.attributes.shape && card2.attributes.shape == card3.attributes.shape || card1.attributes.shape != card2.attributes.shape && card2.attributes.shape != card3.attributes.shape
            {
                // All cards must have the same shading or 3 different patterns
                if card1.attributes.shading == card2.attributes.shading && card2.attributes.shading == card3.attributes.shading || card1.attributes.shading != card2.attributes.shading && card2.attributes.shading != card3.attributes.shading
                {
                    // All cards must have the same number or 3 different numbers
                    if card1.attributes.number == card2.attributes.number && card2.attributes.number == card3.attributes.number || card1.attributes.number != card2.attributes.number && card2.attributes.number != card3.attributes.number
                    {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    // -- chosen card --
    mutating func choose(_ card: Card) {
        if let chosenIndex = dealtCards.firstIndex(where: { $0.id == card.id }),
           !dealtCards[chosenIndex].isMatched {
            // 1st 3 selections condition handler
            if idsOfSelectedCards.count < 3 {
                if dealtCards[chosenIndex].isSelected {
                    // if card is already selected, then unselect it and remove from idsOfSelectedCards
                    idsOfSelectedCards.remove(at: idsOfSelectedCards.firstIndex(of: dealtCards[chosenIndex].id)!)
                    dealtCards[chosenIndex].isSelected = false
                    return
                }
                // Mark selections
                dealtCards[chosenIndex].isSelected = true // make card isSelected to true
                idsOfSelectedCards.append(dealtCards[chosenIndex].id)
                if idsOfSelectedCards.count == 3 { // 3 cards are now selected
                    // Set check
                    let arrayOfSelectedCards = dealtCards.filter { idsOfSelectedCards.contains($0.id) }
                    if isSet(of: arrayOfSelectedCards) {
                        dealtCards.indices.forEach {
                            if idsOfSelectedCards.contains(dealtCards[$0].id) {
                                dealtCards[$0].isMatched = true
                                dealtCards[$0].isSelected = false
                            }
                        }
                    }
                }
            } else {
                // The idsOfSelectedCards count will already be 3, therefore this is the 4th selection
                dealtCards.indices.forEach { dealtCards[$0].isSelected = false }
                idsOfSelectedCards.removeAll()
                idsOfSelectedCards.append(dealtCards[chosenIndex].id)
                dealtCards[chosenIndex].isSelected = true
                if dealtCardsMatched {
                    dealtCards.indices.reversed().forEach {
                        if dealtCards[$0].isMatched {
                            matchedCards.append(dealtCards[$0])
                            dealtCards.remove(at: $0)
                        }
                    }
                }
            }
        }
    }
    
    struct Card: Identifiable {
        let id: Int
        let attributes: CardAttributes
        var isMatched = false
        var isSelected = false
    
        struct CardAttributes {
            let color: CardAttributeVariant
            let shading: CardAttributeVariant
            let number: CardAttributeVariant
            let shape: CardAttributeVariant
        }
    }
}
