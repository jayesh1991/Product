//
//  ProductListViewModelDependency.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation

protocol ProductViewModelDependencyType {
    var networkManager: NetworkManagerType { get }
}
 
class ProductViewModelDependency: ProductViewModelDependencyType {
    private(set) var networkManager: NetworkManagerType
    
    init(networkManager: NetworkManagerType = NetworkManager.sharedInstance) {
        self.networkManager = networkManager
    }
}
