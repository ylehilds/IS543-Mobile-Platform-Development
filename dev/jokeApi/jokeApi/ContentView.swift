//
//  ContentView.swift
//  jokeApi
//
//  Created by Lehi Alcantara on 12/19/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var joke: String = ""
    @State private var iconUrl: URL? = nil
    @State private var iconUrlDynamic: String? = nil

    var body: some View {
        Text(joke)
        Button {
            Task {
                let (data, _) = try await URLSession.shared.data(from: URL(string:"https://api.chucknorris.io/jokes/random")!)
                let decodedResponse = try? JSONDecoder().decode(Joke.self, from: data)
                joke = decodedResponse?.value ?? ""
                iconUrlDynamic = decodedResponse?.icon_url ?? ""
                iconUrl = URL(string: "https://images01.military.com/sites/default/files/styles/full/public/2021-04/chucknorris.jpeg.jpg?itok=2b4A6n29")
            }
        } label: {
            Text("Fetch Joke")
        }
        
        Spacer()
        
        if let url = iconUrlDynamic {
            Text(url)
        }
        Spacer()
        
        if let url = iconUrl {
            AsyncImage(url: url) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Joke: Codable {
    let value: String
    let icon_url: String
}
