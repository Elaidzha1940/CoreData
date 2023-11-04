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

    @FetchRequest(
        entity: VegieEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \VegieEntity.name, ascending: true)])
    var vegies: FetchedResults<VegieEntity>
    
    @State var textField: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                TextField("Add vegie here...", text: $textField)
                
                List {
                    ForEach(vegies) { vegie in
                        Text(vegie.name ?? "")
                    }
                    .onDelete(perform: deleteItems)
                }
                .font(.system(size: 16, weight: .semibold))
            }
            .navigationTitle("Vegies")
            .navigationBarItems(
                trailing:
                    Button(action: addItem) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .bold))
                    }
            )
        }
    }
    
    private func addItem() {
        withAnimation {
            let newVegie = VegieEntity(context: viewContext)
            newVegie.name = "Potato"
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let vegieEntity = vegies[index]
            viewContext.delete(vegieEntity)
            saveItems()
        }
    }
    
    private func saveItems() {
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
