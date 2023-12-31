//
//  ContentView.swift
//  searchBarToFilterData
//
//  Created by Lehi Alcantara on 12/16/23.
//

import SwiftUI

//struct ContentView: View {
//    @State private var searchText = ""
//
//    var body: some View {
//        NavigationStack {
//            Text("Searching for \(searchText)")
//                .navigationTitle("Searchable Example")
//        }
//        .searchable(text: $searchText)
//    }
//}

//struct ContentView: View {
//    @State private var searchText = ""
//    @State private var searchIsActive = false
//
//    var body: some View {
//        NavigationStack {
//            Text("Searching for \(searchText)")
//                .navigationTitle("Searching: \(searchIsActive ? "Yes" : "No")")
//        }
//        .searchable(text: $searchText, isPresented: $searchIsActive)
//    }
//}

//struct ContentView: View {
//    @State private var searchText = ""
//
//    var body: some View {
//        NavigationStack {
//            Text("Searching for \(searchText)")
//                .navigationTitle("Searchable Example")
//        }
//        .searchable(text: $searchText, prompt: "Look for something")
//    }
//}

//struct ContentView: View {
//    let names = ["Holly", "Josh", "Rhonda", "Ted"]
//    @State private var searchText = ""
//
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(searchResults, id: \.self) { name in
//                    NavigationLink {
//                        Text(name)
//                    } label: {
//                        Text(name)
//                    }
//                }
//            }
//            .navigationTitle("Contacts")
//        }
//        .searchable(text: $searchText)
//    }
//
//    var searchResults: [String] {
//        if searchText.isEmpty {
//            return names
//        } else {
//            return names.filter { $0.contains(searchText) }
//        }
//    }
//}

//struct ContentView: View {
//    let names = ["Holly", "Josh", "Rhonda", "Ted"]
//    @State private var searchText = ""
//
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(searchResults, id: \.self) { name in
//                    NavigationLink {
//                        Text(name)
//                    } label: {
//                        Text(name)
//                    }
//                }
//            }
//            .navigationTitle("Contacts")
//        }
//        .searchable(text: $searchText) {
//            ForEach(searchResults, id: \.self) { result in
//                Text("Are you looking for \(result)?").searchCompletion(result)
//            }
//        }
//    }
//
//    var searchResults: [String] {
//        if searchText.isEmpty {
//            return names
//        } else {
//            return names.filter { $0.contains(searchText) }
//        }
//    }
//}


struct Message: Identifiable, Codable {
    let id: Int
    var user: String
    var text: String
}

enum SearchScope: String, CaseIterable {
    case inbox, favorites
}

struct ContentView: View {
    @State private var messages = [Message]()

    @State private var searchText = ""
    @State private var searchScope = SearchScope.inbox

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredMessages) { message in
                    VStack(alignment: .leading) {
                        Text(message.user)
                            .font(.headline)

                        Text(message.text)
                    }
                }
            }
            .navigationTitle("Messages")
        }
        .searchable(text: $searchText)
        .searchScopes($searchScope) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            }
        }
        .onAppear(perform: runSearch)
        .onSubmit(of: .search, runSearch)
        .onChange(of: searchScope) { _ in runSearch() }
    }

    var filteredMessages: [Message] {
        if searchText.isEmpty {
            return messages
        } else {
            return messages.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func runSearch() {
        Task {
            guard let url = URL(string: "https://hws.dev/\(searchScope.rawValue).json") else { return }

            let (data, _) = try await URLSession.shared.data(from: url)
            messages = try JSONDecoder().decode([Message].self, from: data)
        }
    }
}



#Preview {
    ContentView()
}
