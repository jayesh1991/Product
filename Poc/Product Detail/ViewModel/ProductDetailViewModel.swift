//
//  ProductDetailViewModel.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation
import UIKit

protocol ProductDetailViewModelType {
    var name: String { get }
    var description: String { get }
    var price: String { get }
    var imageURL: URL? { get }
    
    func addToCart()
    func checkProductAddedToCart() -> Bool
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class ProductDetailViewModel: ProductDetailViewModelType {
    // MARK: - Properties
    private let product: Product
    private let dependency: ProductDetailViewModelDependencyType
    
    var name: String {
        product.title
    }
    var description: String {
        product.description
    }
    var price: String {
        "$\(product.price)"
    }
    var imageURL: URL? {
        URL(string: product.image)
    }
    
    // MARK: - Init
    
    init(product: Product,
         dependency: ProductDetailViewModelDependencyType = ProductDetailViewModelDependency()) {
        self.product = product
        self.dependency = dependency
    }
    
    func addToCart() {
        dependency.coredataManager.saveToCart(product: product)
    }
    
    func checkProductAddedToCart() -> Bool {
        return dependency.coredataManager.findCartItem(id: Int16(product.key))
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        dependency.imageCache.downLoadImage(url: url) { image in
            completion(image)
        }
    }
}
