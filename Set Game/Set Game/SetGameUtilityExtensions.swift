//
//  UtilityExtensions.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/15/23.
//

import Foundation
import SwiftUI

extension SetGame.Card.CardAttributes {
    func toArrayOfRawValues() -> [Int] {
        return [
            self.color.rawValue,
            self.shading.rawValue,
            self.number.rawValue,
            self.shape.rawValue
        ]
    }
}

extension SetGame {
    static func createCardDeck() -> [Card] {
        var id = 0
        var deck = [Card]()
        
        for color in CardAttributeVariant.allCases {
            for shading in CardAttributeVariant.allCases {
                for number in CardAttributeVariant.allCases {
                    for shape in CardAttributeVariant.allCases {
                        id += 1
                        deck.append(Card(
                            id: id,
                            attributes: Card.CardAttributes(
                                color: color,
                                shading: shading,
                                number: number,
                                shape: shape
                            )
                        ))
                    }
                }
            }
        }
        return deck.shuffled()
    }
}
