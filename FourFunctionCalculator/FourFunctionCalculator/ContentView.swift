//
//  ContentView.swift
//  FourFunctionCalculator
//
//  Created by Lehi Alcantara on 9/18/23.
//

import SwiftUI

struct ContentView: View {
    @State private var result = ""
    let grid = [
        ["AC", "+/-", "%", "/"],
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    var body: some View {
        Spacer()

        TextField("", text:
                    $result)
                .foregroundColor(.black)
                .multilineTextAlignment(.trailing)
                .font(.custom("Helvetica Neue", size: 100))
        
        ForEach(grid, id: \.self) { list in
            HStack (
                alignment: .top,
                spacing: 7
            ) {
                ForEach(list, id: \.self) { item in
                    if item == "0" {
                        Text("     \(item)")
                            .frame(width: 190, height: 90, alignment: .leading)
                    } else {
                        if item == "/" || item == "X" || item == "-" || item == "+" || item == "=" {
                            Text("\(item)")
                            .frame(width: 90, height: 90)
                            .background(.blue)
                        } else {
                            Text("\(item)")
                            .frame(width: 90, height: 90)
                        }
                    }
                }
                .foregroundColor(.white)
                .font(.custom("Helvetica Neue", size: 31))
                .background(.orange)
                .clipShape(Capsule())
            }
        }
        
        Spacer()
    }
}

#Preview {
    ContentView()
}
