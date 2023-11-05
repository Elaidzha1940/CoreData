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
            VStack(spacing: -5) {
                
                TextField("Add veggie here...", text: $textField)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(15)
                    .padding(.horizontal)
                
                Button(action: {
                    addItem()
                }, label: {
                    Text("Submit")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.mint.opacity(0.5))
                        .cornerRadius(15)
                })
                .padding()
                
                List {
                    ForEach(vegies) { vegie in
                        Text(vegie.name ?? "")
                            .onTapGesture {
                                updateItem(vegie: vegie)
                            }
                    }
                    .onDelete(perform: deleteItems)
                    .listRowBackground(Color.gray.opacity(0.3))
                }
                .font(.system(size: 16, weight: .semibold))
            }
            .navigationTitle("Vegies")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newVegie = VegieEntity(context: viewContext)
            newVegie.name = textField
            saveItems()
            textField = ""
        }
    }
    
    private func updateItem(vegie: VegieEntity) {
        withAnimation {
            let currentName = vegie.name ?? ""
            let newName = currentName + "!"
            vegie.name = newName
            
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
