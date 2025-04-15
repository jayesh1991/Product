//
//  ProductDetailViewModelDependency.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation

protocol ProductDetailViewModelDependencyType {
    var coredataManager: CoreDataManagerType { get }
    var imageCache: ImageCacheManagerType { get }
}

class ProductDetailViewModelDependency: ProductDetailViewModelDependencyType {
    private(set) var coredataManager: CoreDataManagerType
    private(set) var imageCache: ImageCacheManagerType
    
    init(coredataManager: CoreDataManagerType = CoreDataManager.sharedInstance,
         imageCache: ImageCacheManagerType = ImageCacheManager.sharedInstance) {
        
        self.coredataManager = coredataManager
        self.imageCache = imageCache
    }
}
