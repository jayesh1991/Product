//
//  Product.swift
//  Poc
//
//  Created by jayesh rajput on 11/04/25.
//

import Foundation

// MARK: - Models

struct Product: Codable {
    let key: Int
    let title: String
    let description: String
    let price: Double
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case key = "id"
        case title, description, price
        case image = "thumbnail"
    }
    
}

struct Products: Codable {
    let products: [Product]
}
