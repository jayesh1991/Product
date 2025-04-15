//
//  CartViewModelTest.swift
//  PocTests
//
//  Created by jayesh rajput on 15/04/25.
//

import XCTest
@testable import Poc
import CoreData

final class CartViewModelTest: XCTestCase {

    var sut: CartViewModel!
    var mockCoreData: MockCoreDataManager!

    override func setUpWithError() throws {
        mockCoreData = MockCoreDataManager()
        let item1 = Product(key: 1,
                            title: "MacBook Pro",
                            description: "Apple Laptop",
                            price: 1999.99,
                            image: "https://apple.com/macbook.png")

        let item2 = Product(key: 2,
                            title: "iphone7",
                            description: "Apple iphone",
                            price: 34.0,
                            image: "https://apple.com/iphone.png")

        mockCoreData.saveToCart(product: item1)
        mockCoreData.saveToCart(product: item2)

        let dependency = CartViewModelDependency(coredataManager: mockCoreData)
        sut = CartViewModel(dependency: dependency)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockCoreData = nil
    }

    func testFetchCartItems() {
        let expectation = expectation(description: "Cart updated")

        sut.onCartUpdated = {
            XCTAssertEqual(self.sut.numberOfItems(), 2)
            expectation.fulfill()
        }

        sut.fetchCartItems()
        wait(for: [expectation], timeout: 60.0)
    }

    func testTotalCartPrice() {
        sut.fetchCartItems()
        let total = sut.totalCartPrice()
        XCTAssertEqual(total, "2033.99")
    }

    func testItemAtIndex() {
        sut.fetchCartItems()
        let item = sut.item(at: 1)
        XCTAssertEqual(item.name, "MacBook Pro")
        XCTAssertEqual(item.price, 1999.99)
    }
}
