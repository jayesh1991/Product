//
//  ProductDetailViewModelTest.swift
//  PocTests
//
//  Created by jayesh rajput on 15/04/25.
//

import XCTest
@testable import Poc

final class ProductDetailViewModelTest: XCTestCase {

    var sut: ProductDetailViewModel!
    var mockimageCache: MockImageCacheManager!
    var mockCoredata: MockCoreDataManager!
    var sampleProduct: Product!

    override func setUpWithError() throws {
        mockCoredata = MockCoreDataManager()
        mockimageCache = MockImageCacheManager()
      let dependency = ProductDetailViewModelDependency(coredataManager: mockCoredata, imageCache: mockimageCache)

        sampleProduct = Product(key: 1,
                                title: "MacBook Pro",
                                description: "Apple Laptop",
                                price: 1999.99,
                                image: "https://apple.com/macbook.png")
        sut = ProductDetailViewModel(product: sampleProduct, dependency: dependency)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockimageCache = nil
        mockCoredata = nil
    }

    func testProductData() {
        XCTAssertEqual(sut.name, "MacBook Pro")
        XCTAssertEqual(sut.description, "Apple Laptop")
        XCTAssertEqual(sut.price, "$1999.99")
        XCTAssertEqual(sut.imageURL?.absoluteString, "https://apple.com/macbook.png")
    }

    func testAddCart() {
        sut.addToCart()
        XCTAssertEqual(Int(mockCoredata.fetchCartItems()[0].key), sampleProduct.key)
    }

    func testCheckAddedToCart() {
        sut.addToCart()
       let isAdded = sut.checkProductAddedToCart()
        XCTAssertTrue(isAdded)
    }

    func testLoadImage() {
        let expection = XCTestExpectation(description: "load image")
        let mockImage = UIImage(systemName: "star")
        mockimageCache.mockImage = mockImage

        sut.loadImage(from: URL(string: "someurl.png")!) { image in
            XCTAssertEqual(image, mockImage)
            expection.fulfill()
        }
        wait(for: [expection], timeout: 60.0)
    }
}
