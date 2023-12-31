//
//  ContentView.swift
//  myNotify
//
//  Created by Lehi Alcantara on 12/16/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var isEditing = false
    @State private var notificationsRequested = false
    @State private var notificationsEnabled = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack {
                            Toggle("Notify Me", isOn: $notificationsRequested)
                                .padding()
                                .onChange(of: notificationsRequested) { oldValue, newValue in
                                    if notificationsRequested {
                                        UNUserNotificationCenter.current()
                                            .requestAuthorization(options: [.alert, .sound, .provisional])
                                        { success, error in
                                            if success {
                                                notificationsEnabled = true
                                                sendNotification()
                                            } else if let error = error {
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                                }
                        }
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private func sendNotification() {
        if notificationsEnabled {
            let content = UNMutableNotificationContent()
            content.title = "You Asked, We Answered"
            content.subtitle = "Here is your 30-second notification."
            content.sound = UNNotificationSound.default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content,
                                                trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
