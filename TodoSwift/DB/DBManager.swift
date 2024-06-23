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
    
    private var id: Expression<String>!
    private var title: Expression<String>!
    private var isCompleted: Expression<String>!
    
    init () {
        do {
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
            
            print("DB Path ", path)
            db = try Connection("\(path)/todos.sqlite3")
            let createTableString = try db.prepare("""
            CREATE TABLE IF NOT EXISTS items(
            id CHAR(255) PRIMARY KEY NOT NULL,
            title CHAR(255),
            isCompleted CHAR(255));
            """)
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {
                try createTableString.run()
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func addItem(titleValue: String, isCompletedValue: String) {
        do {
            let queryString = try db.prepare("INSERT INTO items (id, title, isCompleted) VALUES (?, ?, ?)")
            try queryString.run(UUID().uuidString, titleValue, isCompletedValue)
        } catch {
            print("Error in inserting the data ", error.localizedDescription)
        }
    }
    
    public func getItems() -> [ItemModel] {
        var _itemModes: [ItemModel] = []
        let queryString = "SELECT * FROM items"
        do {
            for item in try db.prepare(queryString) {
                let itemModel: ItemModel = ItemModel()
                print("Items ", item)
                itemModel.id = item[0] as! String
                itemModel.title = item[1] as! String
                itemModel.isCompleted = item[2] as! String
                
                _itemModes.append(itemModel)
            }
        } catch {
            print("Error in getting the data ", error.localizedDescription)
        }
        return _itemModes
    }
    
    public func deleteItem(idVal: String) {
        do {
            let queryString = try db.prepare("DELETE FROM items WHERE id = ?")
            try queryString.run(idVal)
        } catch {
            print("Error in deleting the data ", error.localizedDescription)
        }
    }
    
    public func updateItem(idVal: String, titleVal: String, isCompletedVal: String) {
        do {
            let queryString = try db.prepare("UPDATE items set isCompleted = ? WHERE id = ?")
            
            try queryString.run(isCompletedVal, idVal)
        } catch {
            print("Error in updating the data ", error.localizedDescription)
        }
    }
}
