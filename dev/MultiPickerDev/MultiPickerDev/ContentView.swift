import SwiftUI
import MultiPicker

struct ContentView: View {
    var body: some View {
        VStack {
            MyView()
            ListDemo()
        }
        .padding()
    }
}

struct MyView: View {
    @State var selectedItems = Set<Model>()
//    @State private var selection: Set<Model> = []
    @State private var selectedCategories: [Model] = []

    @State private var options: [Model] = [Model(id: 1, name: "1"), Model(id: 2, name: "2"), Model(id: 3, name: "3"), Model(id: 4, name: "4"), Model(id: 5, name: "5")] // Provide a default value

    
    var body: some View {
        // MultiPicker from my experience it doesn't work
//        Form {
//            MultiPicker("Choose something", selection: $selection) {
//                ForEach(options, id: \.self) { option in
//                    ModelCell(model: option)
//                        .mpTag(option)
////                    Text(option.name).tag(option.name)
//                }
//            }
//            .mpPickerStyle(.inline)
//        }
        
        List(options) { option in
                    HStack {
                        Text(option.name)
                        Spacer()
                        if selectedItems.contains(option) {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedItems.contains(option) {
                            selectedItems.remove(option)
                        } else {
                            selectedItems.insert(option)
                        }
                    }
                }
        Text("selectedItems: \(selectedItems.map { $0.name }.joined(separator: ", ") )")
        
//        List(options, id: \.self, selection: $selectedItems) { item in
//            Text("\(item.name)")
//        }
//        
//        Text("selectedItems: \(selectedItems.map { $0.name }.joined(separator: ", ") )")
        
        List {
            ForEach(options) { category in
                Toggle(category.name, systemImage: "dot.radiowaves.left.and.right", isOn: Binding(
                    get: { self.selectedCategories.contains(category) },
                    set: { (newValue) in
                        if newValue {
                            self.selectedCategories.append(category)
                        } else {
                            self.selectedCategories.removeAll(where: { $0 == category })
                        }
                    }
                ))
            }
        }
        Text("Selected Categories: \(selectedCategories.map { $0.name }.joined(separator: ", ") )")
        
    }
}

struct ListDemo: View {
    @State var items = ["Pizza", "Spaghetti", "Caviar"]
    @State var selection = Set<String>()
    
    var body: some View {
        List(items, id: \.self, selection: $selection) { (item : String) in
            
            let s = selection.contains(item) ? "√" : " "
            
            HStack {
                Text(s+"    "+item)
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if  selection.contains(item) {
                    selection.remove(item)
                }
                else{
                    selection.insert(item)
                }
                print(selection)
            }
        }
        .listStyle(GroupedListStyle())
        Text("Selected Categories: \(selection.map { $0 }.joined(separator: ", ") )")
    }
}

struct Model: Identifiable, Hashable {
    let id: Int
    let name: String
}

//struct ModelCell: View {
//    let model: Model
//
//    var body: some View {
//        Text(model.name)
//    }
//}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
