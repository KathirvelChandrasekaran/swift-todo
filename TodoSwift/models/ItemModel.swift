//
//  ItemModel.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/05/24.
//

import Foundation

struct ItemModel: Codable, Hashable, Identifiable {
    let id: String
    let title: String
    let isCompleted: String
    
    init(id: String = UUID().uuidString, title: String, isCompleted: String) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

struct Response: Codable {
    let data: [ItemModel]
}
