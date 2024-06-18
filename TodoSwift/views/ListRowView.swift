//
//  ListRowView.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/05/24.
//

import SwiftUI

struct ListRowView: View {
    let item: ItemModel
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted == "Yes" ? "checkmark.circle" : "circle")
                .foregroundStyle(item.isCompleted == "Yes" ? .green : .red)
            Text(item.title)
        }
    }
}
