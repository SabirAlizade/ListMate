//
//  ImageCasheManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 18.01.24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func setImage(_ image: UIImage?, forKey key: String) {
        guard let image else { return }
        cache.setObject(image, forKey: key as NSString)
    }

    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
}
