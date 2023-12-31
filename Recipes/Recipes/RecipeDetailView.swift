//
//  RecipeDetailView.swift
//  Recipes
//
//  Created by Lehi Alcantara on 12/1/23.
//

import SwiftUI
import SwiftData
import MarkdownUI
import Ink

struct RecipeDetailView: View {
    let recipe: Recipe?
    
    var shareContent: String {
        guard let recipe = recipe else { return "" }
        return """
                    ## \(recipe.title)
                
                    **Author:** \(recipe.author)
                
                    **Date:** \(recipe.date)
                
                    **Time Required:** \(recipe.timeRequired)
                
                    **Servings:** \(recipe.servings)
                
                    **Expertise Required**: \(recipe.expertiseRequired)
                
                    **Calories Per Serving**: \(recipe.caloriesPerServing)
                
                    ## Ingredients
                
                    \(recipe.ingredients)
                
                    ## Instructions
                
                    \(recipe.instructions)
                
                    ## Notes
                
                    \(recipe.notes)
                
                    **Category**: \(recipe.category.map { $0.name }.joined(separator: ", "))
                """
    }
    
    var body: some View {
        if let recipe = recipe {
            ScrollView {
                VStack {
                    Markdown ("## \(recipe.title)")
                        .padding()
                    Markdown ("**Author:** \(recipe.author)")
                        .padding()
                    Markdown ("**Date:** \(recipe.date)")
                        .padding()
                    Markdown ("**Time Required:** \(recipe.timeRequired)")
                        .padding()
                    Markdown ("**Servings:** \(recipe.servings)")
                        .padding()
                    Markdown ("**Expertise Required**: \(recipe.expertiseRequired)")
                        .padding()
                    Markdown ("**Calories Per Serving**: \(recipe.caloriesPerServing)")
                        .padding()
                    Markdown ("## Ingredients \n \(recipe.ingredients)")
                        .padding()
                    Markdown ("## Instructions \n \(recipe.instructions)")
                        .padding()
                    Markdown ("## Notes \n \(recipe.notes)")
                        .padding()
                    Markdown ("**Category**: \(recipe.category.map { $0.name }.joined(separator: ", "))")
                        .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        Image(systemName: recipe.favorite ? "heart.fill" : "heart").imageScale(.large)
                            .foregroundColor(recipe.favorite ? .red : .gray)
                            .onTapGesture {
                                recipe.favorite.toggle()
                            }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationStack {
                        ZStack {
                            NavigationLink(destination: EditRecipeView(recipe: recipe)) {
                                Image(systemName: "pencil").imageScale(.large)
                            }
                        }
                        .navigationDestination(for: String.self) { text in
                            Text(verbatim: text)
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        ShareLink(item: removeMarkdownSyntax(from: shareContent))}
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        Button(action: {
                            printRecipe()
                        }) {
                            Image(systemName: "printer")
                        }
                    }
                }
            }
        }
        else {
            Text("Select a Recipe!")
        }
    }
    
    // https://developer.apple.com/forums/thread/739856
    func printRecipe() {
        let parser = MarkdownParser()
        let htmlString = parser.html(from: shareContent)
        let formatter: UIMarkupTextPrintFormatter = UIMarkupTextPrintFormatter(markupText: htmlString)
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "Printing Recipe"
        printInfo.outputType = .general
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printFormatter = formatter
        printController.present(animated: true, completionHandler: nil)
    }
    
    // https://programmingwithswift.com/how-to-replace-characters-in-string-with-swift/
    func removeMarkdownSyntax(from text: String) -> String {
        let boldSyntaxRemoved = text.replacingOccurrences(of: "\\*\\*(.*?)\\*\\*", with: "$1", options: .regularExpression)
        let headerSyntaxRemoved = boldSyntaxRemoved.replacingOccurrences(of: "\\#\\# (.*?)", with: "$1", options: .regularExpression)
        let tableColumnSyntaxRemoved = headerSyntaxRemoved.replacingOccurrences(of: "\\|", with: "", options: .regularExpression)
        let tableDividerSyntaxRemoved = tableColumnSyntaxRemoved.replacingOccurrences(of: "---", with: "", options: .regularExpression)
        let linksSyntaxRemoved = tableDividerSyntaxRemoved.replacingOccurrences(of: "(!?\\[.*?\\])", with: "", options: .regularExpression)
        return linksSyntaxRemoved
    }
}

#Preview {
    let recipe = Recipe(title: "Title", author: "Author", date: "Date", timeRequired: "Time", servings: "Servings", expertiseRequired: "Expertise", caloriesPerServing: "Calories", ingredients: "Ingredients", instructions: "Instructions", notes: "Notes", category: [], favorite: true)
    return RecipeDetailView(recipe: recipe)
}
