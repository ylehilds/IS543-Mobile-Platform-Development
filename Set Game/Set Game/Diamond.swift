//
//  Diamond.swift
//  Set Game
//
//  Created by Lehi Alcantara on 10/15/23.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // first point to start off: middle bottom
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY)) // second point: middle left
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY)) // third point: middle top
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY)) // fourth point: middle right
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY)) // fifth point to close off the diamond is: middle bottom
        return path
    }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
    }
}
