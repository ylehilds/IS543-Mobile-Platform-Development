//
//  SetGameView.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/15/23.
//

import SwiftUI

struct SetGameView: View {
    @State private var columnCount: Int = 4
    
    @ObservedObject var game: SetGameViewModel
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                dealtCardsView
                Spacer()
                newGameButton
                Spacer()
            }
            HStack{
                deck
                Spacer()
                discardPile
            }
            .padding(.horizontal, 30)
        }.padding(.bottom, 10)
    }
    
    // MARK: - Dealt Cards
    
    private var dealtCardsView: some View {
        AspectVGrid(items: game.dealtCards, aspectRatio: 4/7) { card in
            CardView(card: card, isMismatched: isMismatched(card))
                .transition(AnyTransition.offset(randomOffScreenLocation))
                .padding(3)
                .onTapGesture {
                    withAnimation {
                        game.choose(card)
                    }
                }
        }.padding(5)
    }

    private func isMismatched(_ card: SetGame.Card) -> Bool {
        game.selectedCards.count == 3 && !card.isMatched
    }
    
//    private var randomOffScreenLocation: CGSize {
//        let radius = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 1.5
//        let factor: Double = Int.random(in: 0...1) > 0 ? 1 : -1
//
//        return CGSize(width: factor * radius, height: factor * radius)
//    }
    
    private var randomOffScreenLocation: CGSize {
        let angle = Angle.degrees(Double.random(in: 0..<360)).radians
        let radius = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        let x = CGFloat(cos(angle) * radius) * 1.5
        let y = CGFloat(sin(angle) * radius) * 1.5
        
        return CGSize(width: x, height: y)
    }
    
    // MARK: - Discarded cards pile
    
    private var discardPile: some View {
        ZStack {
            ForEach(game.matchedCards) {card in
                CardView(card: card, isMismatched: false)
                    .transition(AnyTransition.offset(randomOffScreenLocation))
            }
            Color.clear
        }
        .frame(width: 40, height: 55)
        .padding(.bottom, -20)
    }
    
    private var newGameButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .shadow(color: .red, radius: 15, y: 5)
                .frame(width: 90, height: 50)
                .transition(.identity)
                .foregroundColor(.orange)
                .onTapGesture {
                    withAnimation {
                        // Reset the game and also reset column count back to 4
                        game.newGame()
                        columnCount = 4
                    }
                }
            Text("New Game")
                .foregroundColor(.white)
        }
        .padding(.bottom, -20)
    }
    
    // MARK: - Deck
    
    private var deck: some View {
        ZStack {
            ForEach(game.deck) { card in
                CardView(card: card, isMismatched: isMismatched(card))
                    .transition(AnyTransition.offset(randomOffScreenLocation))
                    .padding(.bottom, -10)
            }
            if(game.deck.count != 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10.0)
                        .shadow(color: .red, radius: 15, y: 5)
                        .transition(.identity)
                        .foregroundColor(.orange)
                        .onTapGesture {
                            withAnimation {
                                game.dealCards()
                            }
                        }
                    Text("Deal")
                        .foregroundColor(.white)
                }
                .padding(.bottom, -10)
            }
        }
        .frame(width: 70, height: 38)
        .onAppear {
            withAnimation {
                game.dealCards()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let game = SetGameViewModel()
        game.dealCards()
        
        return SetGameView(game: game)
    }
}
