//
//  CardView.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/15/23.
//

import SwiftUI

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGame.createCardDeck()
        CardView(card: card[0], isMismatched: true)
    }
}

extension Shape {
    func open(color: Color) -> some View {
        ZStack{
            self.stroke(color, lineWidth: 3)
        }
    }

    func striped(color: Color) -> some View {
        ZStack {
            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { number in
                    Spacer(minLength: 0)
                    color.frame(width: 2)
                }
            }.mask(self)
            self.stroke(color, lineWidth: 3)
        }
    }
    
    func solid(color: Color) -> some View {
        self.fill().foregroundColor(color)
    }
}

struct CardView: View {
    let card: SetGame.Card
    var isMismatched: Bool
    
    private var color: Color {
        switch card.attributes.color {
            case .one: return Color.purple
            case .two: return Color.red
            case .three: return Color.green
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8.0)
                            .stroke(Color.blue, lineWidth: 1.0) // Add blue stroke
                            .background(Color.white) // Add white fill
                            .cornerRadius(8.0) // Add corner radius
            let shape = RoundedRectangle(cornerRadius: 8.0)
            if card.isSelected {
                if isMismatched {
                    shape.foregroundColor(.red).opacity(0.75)
                } else {
                    shape.foregroundColor(.orange).opacity(0.75)
                }
            } else {
                shape.opacity(0.02)
            }
            if card.isMatched {
                shape.foregroundColor(.green).opacity(0.5)
            }
            
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    ForEach(0..<card.attributes.number.rawValue, id: \.self) { _ in
                        cardShape()
                            .frame(width: geometry.size.width * 0.8,
                                   height: geometry.size.height * 0.2,
                                   alignment: .center)
                    }
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .padding(.horizontal, 2)
    }
    
    @ViewBuilder
    private func fillShading<setShape>(shape: setShape) -> some View where setShape: Shape {
        switch card.attributes.shading {
            case .one: shape.solid(color: color)
            case .two: shape.striped(color: color)
            case .three: shape.open(color: color)
        }
    }
    
    @ViewBuilder
    private func cardShape() -> some View {
        switch card.attributes.shape {
            case .one: fillShading(shape: Capsule())
            case .two: fillShading(shape: Squiggle())
            case .three: fillShading(shape: Diamond())
        }
    }
}
