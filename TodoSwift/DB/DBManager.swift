//
//  DBManager.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/06/24.
//

import Foundation
import SQLite

class DBManager {
    // DB Instance
    private var db: Connection!
    
    // Table and Column instance
    private var items: Table!
    private var id: Expression<String>!
    private var title: Expression<String>!
    private var isCompleted: Expression<Bool>!
    
    init () {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            print("DB Path ", path)
            db = try Connection("\(path)/todos.sqlite3")
            items = Table("items")
            
            id = Expression<String>("id")
            title = Expression<String>("title")
            isCompleted = Expression<Bool>("isCompleted")
            
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                try db.run(items.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(title)
                    t.column(isCompleted)
                })
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func addItem(titleValue: String, isCompletedValue: Bool) {
        do {
            let rowid = try db.run(items.insert(id <- UUID().uuidString, title <- titleValue, isCompleted <- isCompletedValue))
            print("Row ID", rowid)
        } catch {
            print("Error in inserting the data ", error.localizedDescription)
        }
    }
    
    public func getItems() -> [ItemModel] {
        var _itemModes: [ItemModel] = []
        items = items.order(id.desc)
        do {
            for item in try db.prepare(items) {
                let itemModel: ItemModel = ItemModel()
                itemModel.id = item[id]
                itemModel.title = item[title]
                itemModel.isCompleted = item[isCompleted]
                
                _itemModes.append(itemModel)
            }
        } catch {
            print("Error in getting the data ", error.localizedDescription)
        }
        return _itemModes
    }
    
    public func deleteItem(idVal: String) {
        do {
            let item: Table = items.filter(id == idVal)
            try db.run(item.delete())
        } catch {
            print("Error in deleting the data ", error.localizedDescription)
        }
    }
    
    public func updateItem(idVal: String, titleVal: String, isCompletedVal: Bool) {
        do {
            let item: Table = items.filter(id == idVal)
             
            try db.run(item.update(title <- title, isCompleted <- isCompletedVal))
        } catch {
            print("Error in updating the data ", error.localizedDescription)
        }
    }
}
