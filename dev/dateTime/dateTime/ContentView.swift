//
//  ContentView.swift
//  dateTime
//
//  Created by Lehi Alcantara on 12/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var currentDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Text("\(currentDate)")
            .onReceive(timer) { input in
                currentDate = input
            }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
