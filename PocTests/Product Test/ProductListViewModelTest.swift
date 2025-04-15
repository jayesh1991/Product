//
//  ProductListViewModelTest.swift
//  PocTests
//
//  Created by jayesh rajput on 15/04/25.
//

import XCTest
@testable import Poc

final class ProductListViewModelTest: XCTestCase {

    var sut: ProductListViewModel!
    var dependency: ProductViewModelDependencyType!
    var mockNetworkManager: MockNetworkManager!

    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        dependency = ProductViewModelDependency(networkManager: mockNetworkManager)
        sut = ProductListViewModel(dependency: dependency)
    }

    override func tearDownWithError() throws {
        sut = nil
        dependency = nil
        mockNetworkManager = nil
    }

    func testFetchProducts_success() {
        let expection = XCTestExpectation(description: "Data fetch")

        mockNetworkManager.mockProduct = JSONLoader.load("Products", as: Products.self)

        sut.onDataUpdate = {
            XCTAssertEqual(self.sut.products.count, 10)
            XCTAssertEqual(self.sut.products[0].title, "Essence Mascara Lash Princess")
            XCTAssertEqual(self.sut.products[8].price, 89.99)
        }
        expection.fulfill()

        sut.fetchProducts()
        wait(for: [expection], timeout: 60.0)
    }

    func testFetchProducts_Fail() {
        let expection = XCTestExpectation(description: "Data fetch")

        mockNetworkManager.shouldReturnError = true

        sut.onError = { error in
            XCTAssertFalse(error.isEmpty)
            expection.fulfill()
        }

        sut.fetchProducts()
        wait(for: [expection], timeout: 60.0)
    }

    func testDidselectItem() {
        let product = Product(key: 1, title: "Home", description: "Smartwatch", price: 500.0, image: "")
        sut.products = [product]
        sut.onSelectProduct = { product in
            XCTAssertEqual(product.key, 1)
            XCTAssertEqual(product.price, 500.0)
        }

        sut.didSelectItem(at: 0)
    }

    func testOncartTapped() {
        var tapped = false
        sut.onCartTapped = {
            tapped = true
        }

        sut.didTapCart()
        XCTAssertTrue(tapped)
    }
}
