//
//  ListViewModel.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/05/24.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var items: [ItemModel] = []
    
    init() {
        getItems()
    }
    
    func deleteItem(indexSet: IndexSet) {
        for index in indexSet {
            DBManager().deleteItem(idVal: items[index].id)
            items.remove(atOffsets: indexSet)
            getItems()
        }
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(title: String) {
        DBManager().addItem(titleValue: title, isCompletedValue: false)
        getItems()
    }
    
    func getItems() {
        let todoItems = DBManager().getItems()
        items = todoItems
    }

    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            DBManager().updateItem(idVal: item.id, titleVal: item.title, isCompletedVal: !item.isCompleted)
        }
        getItems()
    }
    
}
