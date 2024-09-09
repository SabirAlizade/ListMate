//
//  PermissionManager.swift
//  ListMate
//
//  Created by Sabir Alizade on 04.09.24.
//

import Photos
import AVFoundation
import UIKit

class PermissionManager {
    
    static let shared = PermissionManager()
    
    private init() {}
    
    func requestCameraPermission(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .restricted, .denied:
            viewController.showPermissionDeniedAlert(for: "Camera")
            completion(false)
        case .authorized:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
    func requestPhotoLibraryPermission(from viewController: UIViewController, completion: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized || status == .limited)
                }
            }
        case .restricted, .denied:
            viewController.showPermissionDeniedAlert(for: "Photo Library")
            completion(false)
        case .authorized, .limited:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
}
