//
//  ListView.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 13/05/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @StateObject var storeKit = StoreKitManager()
    @State private var isPresented = false
    
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
                trailing: Group {
                    let allowedCount = calculateAllowedCount()
                    if listViewModel.items.count < allowedCount {
                        NavigationLink("Add", destination: AddView())
                    } else {
                        Button(action: {
                            isPresented.toggle()
                        }, label: {
                            Text("Purchase Items")
                        })
                        .sheet(isPresented: $isPresented, content: {
                            PurchaseItem(dismissSheet: $isPresented)
                                .presentationDetents([.height(250), .medium, .large])
                                .presentationDragIndicator(.hidden)
                        })
                    }
                }
            )
    }
    
    func calculateAllowedCount() -> Int {
        let allowedCount = storeKit.purchasedItems.count > 0 ? 50 : 5
        print(allowedCount)
        return allowedCount
    }
    
}

#Preview {
    NavigationStack {
        ListView()
    }
    .environmentObject(ListViewModel())
}

