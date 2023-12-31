//
//  ContentData.swift
//  jokeApi
//
//  Created by Lehi Alcantara on 12/19/23.
//

import Foundation
import SwiftUI

@MainActor class ContentData: ObservableObject {
    @Published var content: String = ""
    @Published var author: String = ""
    @Published var id: String = ""
    @Published var imageAuthor: String = ""
    @Published var width: Int = 0
    @Published var height: Int = 0
    @Published var url: String? = nil
    @Published var download_url: String? = nil
    
    func fetchData() {
        Task {
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://api.quotable.io/random")!)
            let decodedResponse = try? JSONDecoder().decode(Quote.self, from: data)
            self.content = decodedResponse?.content ?? ""
            self.author = decodedResponse?.author ?? ""
        }
        Task {
            let random = Int.random(in: 1...994)
            
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://picsum.photos/v2/list?page=\(random)&limit=1")!)
            if let decodedResponse = try? JSONDecoder().decode([ImagesApi].self, from: data), !decodedResponse.isEmpty {
                self.id = decodedResponse[0].id ?? ""
                self.imageAuthor = decodedResponse[0].author ?? ""
                self.width = decodedResponse[0].width
                self.height = decodedResponse[0].height
                self.url = decodedResponse[0].url ?? ""
                self.download_url = decodedResponse[0].download_url ?? ""
            }
        }
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
