//
//  ListView.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/05/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    
    var body: some View {
            List {
                ForEach(listViewModel.items) {
                    item in ListRowView(item: item)
                        .onTapGesture {
                            withAnimation(.linear) {
                                listViewModel.updateItem(item: item)
                            }
                        }
                }
                .onDelete(perform: listViewModel.deleteItem)
                .onMove(perform: listViewModel.moveItem)
            }
            .overlay(Group {
                if(listViewModel.items.isEmpty) {
                    ZStack() {
                        Text("Please add item using **Add Button**")
                    }
                }
            })
            .navigationTitle("Todo List")
            .navigationBarItems(
                leading: EditButton(),
                trailing: NavigationLink("Add", destination: AddView())
            )
    }
    
    
}

#Preview {
    NavigationStack {
        ListView()
    }
    .environmentObject(ListViewModel())
}

