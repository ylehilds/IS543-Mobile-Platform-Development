//
//  ContentView.swift
//  published
//
//  Created by Lehi Alcantara on 12/20/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var data = ContentData()

    var body: some View {
        Text(data.content)
            .padding()
        Text(data.author)
            .padding()
        Spacer()
        if let url = data.download_url {
            AsyncImage(url: URL(string: url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
        }
        Button {
            data.fetchData()
        } label: {
            Text("Fetch Quote")
        }
    }
}

#Preview {
    ContentView()
}
