//
//  MockNetworkManager.swift
//  PocTests
//
//  Created by jayesh rajput on 15/04/25.
//

import XCTest
import Combine
@testable import Poc

class MockNetworkManager: NetworkManagerType {
    var mockProduct: Products = .init(products: [])
    var shouldReturnError = false

    func request<T, U>(endpoint: String, method: HTTPMethod, body: U?, responseType: T.Type) -> AnyPublisher<T, Error> where T: Decodable, U: Encodable {
        if shouldReturnError {
            return Fail(error: NetworkError.serverError(statusCode: 500))
                .eraseToAnyPublisher()
        } else if let result = mockProduct as? T {
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
    }
}
