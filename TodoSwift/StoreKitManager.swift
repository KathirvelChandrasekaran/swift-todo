//
//  StoreKitManager.swift
//  TodoSwift
//
//  Created by kathirvel.chandrasekaran on 22/06/24.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

class StoreKitManager: ObservableObject {
    @Published var storeProducts: [Product] = []
    @Published var purchasedItems: [Product] = []
    @Published var purchasedSubscriptions : [Product] = []
    var updateListenerItem: Task<Void, Error>? = nil
    
    private let productDict: [String : String]
    
    init() {
        if let plistPath = Bundle.main.path(forResource: "ProductList", ofType: "plist"),
           let plist = FileManager.default.contents(atPath: plistPath) {
            productDict = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String : String]) ?? [:]
        } else {
            productDict = [:]
        }
        
        updateListenerItem = listenForTransactions()
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerItem?.cancel()
    }
    
    @MainActor
    func requestProducts() async {
        do {
            storeProducts = try await Product.products(for: productDict.values)
        } catch {
            print("Failed - error retrieving products \(error)")
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let signedType):
            return signedType
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verificationResult):
            let transaction = try checkVerified(verificationResult)
            await updateCustomerProductStatus()
            await transaction.finish()
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func isPurchased(_ product: Product) async throws -> Bool {
        return purchasedItems.contains(product)
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedItems: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if let item = storeProducts.first(where: { $0.id == transaction.productID}) {
                    purchasedItems.append(item)
                }
            } catch {
                print("Transaction failed verification")
            }
            self.purchasedItems = purchasedItems
            self.purchasedSubscriptions = purchasedSubscriptions
            
            print(purchasedItems)
        }
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updateCustomerProductStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction failed verification")
                }
            }
        }
    }
}
