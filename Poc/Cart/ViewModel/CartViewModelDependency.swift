//
//  CartViewModelDependency.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation

protocol CartViewModelDependencyType {
    var coredataManager: CoreDataManagerType { get }
}

class CartViewModelDependency: CartViewModelDependencyType {
    private(set) var coredataManager: CoreDataManagerType
    
    init(coredataManager: CoreDataManagerType = CoreDataManager.sharedInstance) {
        self.coredataManager = coredataManager
    }
}
