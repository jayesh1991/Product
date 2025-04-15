//
//  ImageCacheManager.swift
//  Poc
//
//  Created by jayesh rajput on 14/04/25.
//

import Foundation
import UIKit

protocol ImageCacheManagerType {
    func downLoadImage(url: URL, completion: @escaping (UIImage?) -> Void)
}

class ImageCacheManager: ImageCacheManagerType {
    
    static let sharedInstance = ImageCacheManager()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
    }
    
    func downLoadImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let key = url.absoluteString as NSString
        
        if let cacheImage = cache.object(forKey: key) {
            completion(cacheImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil, let selfRef = self else {
                completion(nil)
                return
            }
            
            selfRef.cache.setObject(image, forKey: key)
            completion(image)
        }.resume()
    }
}
