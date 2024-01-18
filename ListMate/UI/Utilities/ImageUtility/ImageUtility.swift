//
//  ImageUtility.swift
//  ListMate
//
//  Created by Sabir Alizade on 17.01.24.
//

import Foundation
import UIKit

class ImageUtility {
    static func loadImageFromPath(_ path: String) -> UIImage? {
        let fileURL = URL(fileURLWithPath: path)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                return UIImage(data: data)
            } catch {
                print("Error loading image from path: \(error)")
                return nil
            }
        } else {
            print("File not found at path: \(fileURL.path)")
            return nil
        }
    }
}
