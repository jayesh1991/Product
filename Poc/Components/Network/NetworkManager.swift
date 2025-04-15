//
//  NetworkManager.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation
import Combine

protocol NetworkManagerType {
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: U?,
        responseType: T.Type
    ) -> AnyPublisher<T, Error>
}

// MARK: - APIService

class NetworkManager: NetworkManagerType {
    static let sharedInstance = NetworkManager()
    private init() {}
    
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: U? = nil,
        responseType: T.Type
    ) -> AnyPublisher<T, Error> {
        
        guard Reachability.shared.isConnected else {
            return Fail(error: NetworkError.noInternet).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: Constants.API.BaseURL.baseURL + endpoint) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result -> Data in
                guard let response = result.response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    throw NetworkError.serverError(statusCode: (result.response as? HTTPURLResponse)?.statusCode ?? 500)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .retry(3)
            .mapError { error in
                if let decodingError = error as? DecodingError {
#if DEBUG
                    print("decodingError -", decodingError)
#endif
                    return NetworkError.decodingFailed
                } else if let netError = error as? NetworkError {
                    return netError
                } else {
                    return NetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

enum NetworkError: LocalizedError {
    case invalidURL
    case noInternet
    case decodingFailed
    case serverError(statusCode: Int)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL provided."
        case .noInternet:
            return "No internet connection."
        case .decodingFailed:
            return "Failed to decode server response."
        case .serverError(let code):
            return "Server returned an error: \(code)."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
