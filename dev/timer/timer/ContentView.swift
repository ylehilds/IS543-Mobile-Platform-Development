//
//  ContentView.swift
//  timer
//
//  Created by Lehi Alcantara on 12/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var timeRemaining = 20
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showAlert = false
    @State private var timerActive = true

    var body: some View {
        Text("\(timeRemaining)")
            .onReceive(timer) { _ in
                if timeRemaining > 0 && timerActive {
                    timeRemaining -= 1
                } else if timeRemaining == 0 {
                    showAlert = true
                    timerActive = false
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Timer is Up"), message: Text("Your countdown is over"), dismissButton: .default(Text("OK")))
            }
            .font(.largeTitle)
            .padding()
        
        Button("Reset/Stop") {
            timeRemaining = 20
            timerActive = false
        }
        
        Button("Pause") {
            timerActive = false
        }
        .padding()
        
        Button("Start") {
            timerActive = true
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
