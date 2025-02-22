//
//  ContentView.swift
//  GroceryList
//
//  Created by Weerawut Chaiyasomboon on 22/2/2568 BE.
//

import SwiftUI
import SwiftData
import TipKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    @State private var itemTitle: String = ""
    @FocusState private var isFocused: Bool
    
    let buttonTip = ButtonTip()
    
    func setupTips() {
        do {
            try Tips.resetDatastore()
            Tips.showAllTipsForTesting()
            try Tips.configure([.displayFrequency(.immediate)])
        } catch {
            print("ERROR Innitializing TipKit: \(error.localizedDescription)")
        }
    }
    
    init() {
        setupTips()
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(items) { item in
                        Text(item.title)
                            .font(.title.weight(.light))
                            .padding(.vertical,2)
                            .foregroundStyle(item.isCompleted ? Color.accentColor : .primary)
                            .strikethrough(item.isCompleted)
                            .italic(item.isCompleted)
                            .swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(item)
                                        try! modelContext.save()
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button("Done", systemImage: item.isCompleted ? "x.circle" : "checkmark.circle") {
                                    item.isCompleted.toggle()
                                    try! modelContext.save()
                                }
                                .tint(item.isCompleted ? .red : .green)
                            }
                    }
                }
                .navigationTitle("Grocery List")
                .toolbar {
                    if items.isEmpty {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                addEssentialFood()
                            } label: {
                                Image(systemName: "carrot")
                            }
                            .popoverTip(buttonTip)
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    VStack(spacing: 12) {
                        TextField("", text: $itemTitle)
                            .textFieldStyle(.plain)
                            .padding(12)
                            .background(.tertiary) //HierarchicalShapeStyle
                            .cornerRadius(12)
                            .font(.title.weight(.light))
                            .focused($isFocused)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.sentences)
                        
                        Button {
                            guard !itemTitle.isEmpty else { return }
                            let newItem = Item(title: itemTitle, isCompleted: false)
                            modelContext.insert(newItem)
                            try! modelContext.save()
                            itemTitle = ""
                            isFocused = false
                        } label: {
                            Text("Save")
                                .font(.title2.weight(.medium))
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.extraLarge)
                    }
                    .padding()
                    .background(.bar) //Material
                }
            }
            
            if items.isEmpty {
                ContentUnavailableView("Empty Cart", systemImage: "cart.badge.clock.rtl", description: Text("Please add one item to the list"))
            }
        }
    }
    
    func addEssentialFood() {
        modelContext.insert(Item(title: "Bakery and bread", isCompleted: false))
        modelContext.insert(Item(title: "Apples and Oranges", isCompleted: true))
        modelContext.insert(Item(title: "Chicken and Egg", isCompleted: .random()))
        modelContext.insert(Item(title: "Pastar", isCompleted: .random()))
        modelContext.insert(Item(title: "T-bone steak", isCompleted: .random()))
    }
}

#Preview("Empty List") {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

#Preview("Sample Grocery List") {
    let sampleData: [Item] = [
        Item(title: "Bakery and bread", isCompleted: false),
        Item(title: "Apples and Oranges", isCompleted: true),
        Item(title: "Chicken and Egg", isCompleted: .random()),
        Item(title: "Pastar", isCompleted: .random()),
        Item(title: "T-bone steak", isCompleted: .random())
    ]
    
    let container = try! ModelContainer(for: Item.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    for sample in sampleData {
        container.mainContext.insert(sample)
    }
    
    return ContentView()
        .modelContainer(container)
}
