//
//  CalculatorView.swift
//  HW6 Calculator
//
//  Created by Lehi Alcantara on 9/27/23.
//

import SwiftUI

typealias ButtonSpec = (label: String, type: CalculatorButtonType)

struct CalculatorView: View {
    @Bindable var calculatorViewModel: CalculatorViewModel

    private struct Constants {
        static let buttonSpacing = 16.0
        static let displayFontSize = 90.0
    }

    let buttonSpecs: [ButtonSpec] = [
        ("AC", .utility),   ("±", .utility), ("%", .utility), ("÷", .compute),
        ("7", .number),     ("8", .number),  ("9", .number),  ("×", .compute),
        ("4", .number),     ("5", .number),  ("6", .number),  ("–", .compute),
        ("1", .number),     ("2", .number),  ("3", .number),  ("+", .compute),
        ("0", .doubleWide), ("", .number),   (".", .number),  ("=", .compute),
    ]
    let gridItems = Array<GridItem>(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .fill(.black)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .trailing, spacing: Constants.buttonSpacing) {
                    HStack (alignment: .top){
                        Toggle("Play sound?", isOn: $calculatorViewModel.playSound)
                            .foregroundColor(.white)
                    }
                    Text("1,000")
                        .font(.system(size: Constants.displayFontSize, weight: .light))
                        .foregroundStyle(.white)
                        .padding(.trailing, Constants.buttonSpacing * 2)
                    LazyVGrid(columns: gridItems, alignment: .leading, spacing: Constants.buttonSpacing) {
                        ForEach(buttonSpecs, id: \.label) { buttonSpec in
                            if buttonSpec.label.isEmpty {
                                Spacer()
                            } else {
                                CalculatorButton(buttonSpec: buttonSpec, size: geometry.size, calculatorViewModel: calculatorViewModel)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    CalculatorView(calculatorViewModel: CalculatorViewModel())
}
