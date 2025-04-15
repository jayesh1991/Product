//
//  CartProduct+CoreDataProperties.swift
//  Poc
//
//  Created by jayesh rajput on 15/04/25.
//
//

import Foundation
import CoreData

extension CartProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<CartProduct>(entityName: "CartProduct")
    }

    @NSManaged public var key: Int16
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var imageUrl: String?

}

extension CartProduct: Identifiable {

}
