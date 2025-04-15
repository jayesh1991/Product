//
//  Constants.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation
import UIKit

enum Constants {
    
}

// MARK: - API

extension Constants {
    
    enum API {
        
        enum BaseURL {
            static let baseURL = "https://dummyjson.com/"
        }
        
        enum Endpoint {
            case products(limit: Int, skip: Int)

            var url: String {
                switch self {
                case .products(let limit, let skip):
                    return "products?limit=\(limit)&skip=\(skip)"
                }
            }
        }
    }
}

// MARK: - Messages

extension Constants {
    
    enum Message {
        static let noProductFound = "No more products found."
        static let addedMsg = "Added"
        static let prodcutAdded = "Product added to cart"
        static let errorMsg = "Error"
        static let prodcutAlreadyAdded = "This Product already added to cart"
    }
    
}

// MARK: - Cell Identifiers

extension Constants {
    
    enum Identifier {
        static let cartCellIdentifier = "CartTableViewCell"
        static let prodCellIdentifier = "ProductTableViewCell"
    }
}

// MARK: - App Images

extension Constants {
    enum AppImages: String {
        case noImagePalceholder = "ImageNotFound"
        
        var image: UIImage? {
            UIImage(named: self.rawValue)
        }
    }
    
    enum SystemImages: String {
        case back = "chevron.left"
        case cartImg = "cart"
        
        var image: UIImage? {
            UIImage(systemName: self.rawValue)
        }
    }
}
