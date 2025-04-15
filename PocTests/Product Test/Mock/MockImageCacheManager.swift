//
//  MockImageCacheManager.swift
//  PocTests
//
//  Created by jayesh rajput on 15/04/25.
//

import Foundation
@testable import Poc
import UIKit

class MockImageCacheManager: ImageCacheManagerType {
    var mockImage: UIImage?

    func downLoadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        completion(mockImage)
    }
}
