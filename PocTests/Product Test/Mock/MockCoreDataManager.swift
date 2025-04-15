//
//  MockCoreDataManager.swift
//  PocTests
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
@testable import Poc
import CoreData

class MockCoreDataManager: CoreDataManagerType {
    let container: NSPersistentContainer
        var context: NSManagedObjectContext {
            return container.viewContext
        }

        private var storedItems: [CartProduct] = []

        init() {
            container = NSPersistentContainer(name: "CartModel")
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("In-memory store error: \(error)")
                }
            }
        }

        func saveToCart(product: Product) {
            let cartItem = CartProduct(context: context)
            cartItem.key = Int16(product.key)
            cartItem.name = product.title
            cartItem.price = product.price
            cartItem.imageUrl = product.image
            try? context.save()
        }

        func fetchCartItems() -> [CartProduct] {
            let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
            return (try? context.fetch(request)) ?? []
        }

        func findCartItem(id: Int16) -> Bool {
            let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
            request.predicate = NSPredicate(format: "key == %d", id)
            return (try? context.fetch(request).first) != nil
        }

        func removeFromCart(id: Int16) {
            let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
            request.predicate = NSPredicate(format: "key == %d", id)
            if let item = try? context.fetch(request).first {
                context.delete(item)
                try? context.save()
            }
        }
}
