//
//  ListViewModel.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/05/24.
//

import Foundation

class ListViewModel: ObservableObject {
    let apiURL = "http://localhost:8080/items"
    @Published var items: [ItemModel] = []
    
    init() {
        getItems()
    }
    
    func getItems() {
        APIManager().fetchItems(from: apiURL) { result in
            switch result {
            case .success(let items):
                print(items)
                DispatchQueue.main.async {
                    self.items = items
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    
    
    func deleteItem(indexSet: IndexSet) {
        for index in indexSet {
            APIManager().deleteItemFromList(withId: items[index].id, from: apiURL) {
                result in
                switch result {
                case .success:
                    print("Item Deleted successfully.")
                    self.getItems()
                case .failure(let error):
                    print("Error posting item: \(error)")
                }
            }
        }
    }
        
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(title: String) {
        let newItem = ItemModel(title: title, isCompleted: "No")
        APIManager().postItem(newItem, to: apiURL) {
            result in
            switch result {
            case .success:
                print("Item posted successfully.")
                self.getItems()
            case .failure(let error):
                print("Error posting item: \(error)")
            }
        }
    }
    
    func updateItem(item: ItemModel) {
        let updatedItem = ItemModel(id: item.id, title: item.title, isCompleted: item.isCompleted == "Yes" ? "No" : "Yes")
        APIManager().patchItem(updatedItem, withId: item.id, to: apiURL) {
            result in
            switch result {
            case .success:
                print("Item Updated successfully.")
                self.getItems()
            case .failure(let error):
                print("Error posting item: \(error)")
            }
        }
    }
}
