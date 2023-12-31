//
//  CalculatorButtonType.swift
//  HW4 Calculator
//
//  Created by Lehi Alcantara on 9/27/23.
//

import SwiftUI

enum CalculatorButtonType {
    case utility
    case compute
    case number
    case doubleWide
}

extension CalculatorButtonType {
    var backgroundColor: Color {
        switch self {
            case .utility:
                Color("UtilityBackground")
            case .compute:
                Color("ComputeBackground")
            case .number, .doubleWide:
                Color("NumberBackground")
        }
    }

    var foregroundColor: Color {
        self == .utility ? .black : .white
    }

    var spanWidth: Int {
        self == .doubleWide ? 2 : 1
    }
}
