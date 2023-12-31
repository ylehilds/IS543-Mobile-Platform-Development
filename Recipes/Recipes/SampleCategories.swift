//
//  SampleCategories.swift
//  Recipes
//
//  Created by Lehi Alcantara on 11/30/23.
//

import Foundation

// See https://stackoverflow.com/a/36827996

struct ResponseCategoryData: Decodable {
    var categories: [SampleCategory]
}
struct SampleCategory : Decodable {
    var name: String
}

func loadJson(filename fileName: String) -> [SampleCategory]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let jsonData = try JSONDecoder().decode(ResponseCategoryData.self, from: data)
            return jsonData.categories
        } catch {
            print("error: \(error)")
        }
    }
    return nil
}

let sampleCategories = [
    Category( name: "Desserts" ),
    Category( name: "Healthy" ),
    Category( name: "Comfort" )
]
