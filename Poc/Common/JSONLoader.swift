//
//  JSONLoader.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation

enum JSONLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type, from bundle: Bundle = .main) -> T {
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Missing file: \(filename).json")
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Failed to decode \(filename).json: \(error)")
        }
    }
}
