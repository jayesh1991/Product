//
//  CoredataManager.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
import CoreData

protocol CoreDataManagerType {
    func saveToCart(product: Product)
    func fetchCartItems() -> [CartProduct]
    func findCartItem(id: Int16) -> Bool
    func removeFromCart(id: Int16)
}

final class CoreDataManager: CoreDataManagerType {
    
    static let sharedInstance = CoreDataManager()
    private init() {}

    // MARK: - Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CartModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("CoreData load error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: - Save Context
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    // MARK: - Save Product to Cart
    func saveToCart(product: Product) {
        let cartItem = CartProduct(context: context)
        cartItem.key = Int16(product.key)
        cartItem.name = product.title
        cartItem.price = product.price
        cartItem.imageUrl = product.image
        saveContext()
    }

    // MARK: - Fetch Cart Items
    func fetchCartItems() -> [CartProduct] {
        let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch cart items: \(error)")
            return []
        }
    }

    // MARK: - Find Cart Item
    func findCartItem(id: Int16) -> Bool {
        let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        request.predicate = NSPredicate(format: "key == %d", id)
        if (try? context.fetch(request).first) != nil {
            return true
        }
        return false
    }
    
    // MARK: - Remove Product from Cart
    func removeFromCart(id: Int16) {
        let request: NSFetchRequest<CartProduct> = CartProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        if let result = try? context.fetch(request).first {
            context.delete(result)
            saveContext()
        }
    }
}
