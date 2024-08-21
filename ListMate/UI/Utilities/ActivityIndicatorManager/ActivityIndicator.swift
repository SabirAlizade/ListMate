//
//  ActivityIndicator.swift
//  ListMate
//
//  Created by Sabir Alizade on 22.01.24.
//

import UIKit

class ActivityIndicator {
    static let shared = ActivityIndicator()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .mainGreen
        return indicator
    }()
    
    private init() {}
    
    func showActivityIndicator(view: UIView) {
        if !view.subviews.contains(activityIndicator) {
            activityIndicator.center = view.center
            activityIndicator.layer.zPosition = CGFloat.greatestFiniteMagnitude
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
