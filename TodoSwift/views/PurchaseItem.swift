//
//  PurchaseItem.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 22/06/24.
//

import SwiftUI
import StoreKit

struct PurchaseItem: View {
    @StateObject var storeKit = StoreKitManager()
    @Binding var dismissSheet: Bool
    
    var body: some View {
        ZStack {
            List {
                ForEach(storeKit.storeProducts.sorted(by: {
                    return $0.price < $1.price
                })) {
                    product in
                    HStack {
                        Text(product.displayName)
                        Spacer()
                        Button(action: {
                            Task {
                                try? await storeKit.purchase(product)
                            }
                        }) {
                            TodoSubscriptionItem(storeKit: storeKit, product: product)
                        }
                    }
                }
            }
            .overlay(Group {
                if(storeKit.storeProducts.isEmpty) {
                    ZStack() {
                        Text("Products are not configured")
                    }
                }
            })
            .navigationTitle("Purchase Items")
            Spacer()
            Button(action: {
                dismissSheet = false
            }, label: {
                Text("Close")
                    .foregroundStyle(Color.white)
                    .frame(height: 55)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            })
            .padding(.horizontal, 15)
        }
    }
    
}

struct TodoSubscriptionItem: View {
    @ObservedObject var storeKit : StoreKitManager
    @State var isPurchased: Bool = false
    var product: Product
    
    var body: some View {
        VStack {
            HStack {
                if isPurchased {
                    Text(Image(systemName: "checkmark"))
                        .bold()
                } else {
                    Text(product.displayPrice)
                }
            }
        }
        .onChange(of: storeKit.purchasedItems) { _, _ in
            Task {
                isPurchased = (try? await storeKit.isPurchased(product)) ?? false
            }
        }
    }
}

