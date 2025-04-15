//
//  CartViewModel.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
import CoreData

protocol CartViewModelType {
    var onCartUpdated: (() -> Void)? { get set }
    
    func fetchCartItems()
    func numberOfItems() -> Int
    func totalCartPrice() -> String
    func item(at index: Int) -> CartProduct
}

class CartViewModel: CartViewModelType {
    // MARK: - Properties
    private(set) var cartItems: [CartProduct] = []
    var onCartUpdated: (() -> Void)?
    private let dependency: CartViewModelDependencyType
    
    // MARK: - Init
    init(dependency: CartViewModelDependencyType = CartViewModelDependency()) {
        self.dependency = dependency
    }
    
    func fetchCartItems() {
        cartItems = dependency.coredataManager.fetchCartItems()
        onCartUpdated?()
    }
    
    func numberOfItems() -> Int {
        return cartItems.count
    }
    
    func item(at index: Int) -> CartProduct {
        return cartItems[index]
    }
    
    func totalCartPrice() -> String {
        let total = cartItems.reduce(0) { $0 + $1.price }
        return String(format: "%.2f", total)
    }
}
