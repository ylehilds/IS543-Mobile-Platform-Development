//
//  ContentView.swift
//  jokeApi
//
//  Created by Lehi Alcantara on 12/19/23.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var content: String = ""
    @State private var author: String = ""
    @State private var id: String = ""
    @State private var imageAuthor: String = ""
    @State private var width: Int = 0
    @State private var height: Int = 0
    @State private var url: String? = nil
    @State private var download_url: String? = nil
    
    
    var body: some View {
        Text(content)
            .padding()
        Text(author)
            .padding()
        Spacer()
        
        if let url = download_url {
            AsyncImage(url: URL(string: url)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
        }
        
        Button {
            Task {
                let (data, _) = try await URLSession.shared.data(from: URL(string:"https://api.quotable.io/random")!)
                let decodedResponse = try? JSONDecoder().decode(Quote.self, from: data)
                content = decodedResponse?.content ?? ""
                author = decodedResponse?.author ?? ""
            }
            Task {
                let random = Int.random(in: 1...994)
                
                let (data, _) = try await URLSession.shared.data(from: URL(string:"https://picsum.photos/v2/list?page=\(random)&limit=1")!)
                if let decodedResponse = try? JSONDecoder().decode([ImagesApi].self, from: data), !decodedResponse.isEmpty {
                    id = decodedResponse[0].id ?? ""
                    imageAuthor = decodedResponse[0].author ?? ""
                    width = decodedResponse[0].width
                    height = decodedResponse[0].height
                    url = decodedResponse[0].url ?? ""
                    download_url = decodedResponse[0].download_url ?? ""
                }
            }
        } label: {
            Text("Fetch Quote")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Quote: Codable {
    let content: String
    let author: String
}

struct ImagesApi: Codable, Hashable {
    let id: String?
    let author: String?
    let width: Int
    let height: Int
    let url: String?
    let download_url: String?
}
