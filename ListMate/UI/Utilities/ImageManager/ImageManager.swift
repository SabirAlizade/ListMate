//
//  ImageManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 19.01.24.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    private init() {}
    
    func saveImageToLibrary(image: UIImage?, completion: @escaping (String?) -> Void) {
        guard let data = image?.jpegData(compressionQuality: 1) else {
            completion(nil)
            return
        }
        
        let fileName = "image_\(Date().timeIntervalSince1970).jpg"
        
        do {
            let libraryDirectory = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            let fileURL = libraryDirectory.appendingPathComponent(fileName)
            
            try data.write(to: fileURL)
            ImageCacheManager.shared.setImage(image, forKey: fileName)
            
            completion(fileName)
        } catch {
            print("Error saving image: \(error)")
            completion(nil)
        }
    }
}
