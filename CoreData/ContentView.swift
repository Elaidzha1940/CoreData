//  /*
//
//  Project: NewCoreData
//  File: ContentView.swift
//  Created by: Elaidzha Shchukin
//  Date: 03.11.2023
//
//  */

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
    
    @FetchRequest(entity: VegieEntity.entity(), sortDescriptors: []) var vegies: FetchedResults<VegieEntity>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vegies) { vegie in
                    NavigationLink {
                        Text(vegie.name ?? "")
                        //Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        //Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                //.listStyle(PlainListStyle)
                .navigationTitle("Vegies")
                //.onDelete(perform: deleteItems)
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
            Text("Select an item")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newVegie = VegieEntity(context: viewContext)
            newVegie.name = "Potato"
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
