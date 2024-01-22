

import UIKit

extension UIView {
    
//    MARK: - LEADING Anchor
    
    public func leading(_ constant: CGFloat = 0.0) {
        self.leadingAnchor.constraint(equalTo: superview!.leadingAnchor, constant: constant).isActive = true
    }

    public func leading(_ anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = 0.0) {
        self.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    public func leading(_ anchor: NSLayoutXAxisAnchor) {
        self.leadingAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    public func leading(_ view: UIView, _ constant: CGFloat = 0.0) {
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
    }

//    MARK: - TOP Anchor

    public func top(_ constant: CGFloat = 0.0, safe: Bool = false) {
        if safe {
            self.topAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: superview!.topAnchor, constant: constant).isActive = true
        }
    }
    
    public func top(_ anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = 0.0) {
        self.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    public func top(_ anchor: NSLayoutYAxisAnchor) {
        self.topAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    public func top(_ view: UIView, _ constant: CGFloat = 0.0, safe: Bool = false) {
        if safe {
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        }
    }
    
//    MARK: - TRAILING Anchor
//
    public func trailing(_ constant: CGFloat = 0.0) {
        self.trailingAnchor.constraint(equalTo: superview!.trailingAnchor, constant: -constant).isActive = true
    }
    
    public func trailing(_ anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = 0.0) {
        self.trailingAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    }
    
    public func trailing(_ anchor: NSLayoutXAxisAnchor) {
        self.trailingAnchor.constraint(equalTo: anchor).isActive = true
    }

    public func trailing(_ view: UIView, _ constant: CGFloat = 0.0) {
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
    }
    
//    MARK: - BOTTOM Anchor

    public func bottom(_ constant: CGFloat = 0.0, safe: Bool = false) {
        if safe {
            self.bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
        } else {
            self.bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -constant).isActive = true
        }
    }
    
    public func bottom(_ anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = 0.0) {
        self.bottomAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    }
    
    public func bottom(_ anchor: NSLayoutYAxisAnchor) {
        self.bottomAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    public func bottom(_ view: UIView, _ constant: CGFloat = 0.0, safe: Bool = false) {
        if safe {
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
        } else {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -constant).isActive = true
        }
    }
    
//    MARK: - CENTER-X Anchor

    public func centerX(_ constant: CGFloat = 0.0) {
        self.centerXAnchor.constraint(equalTo: superview!.centerXAnchor, constant: constant).isActive = true
    }
    
    public func centerX(_ anchor: NSLayoutXAxisAnchor, _ constant: CGFloat = 0.0) {
        self.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    public func centerX(_ anchor: NSLayoutXAxisAnchor) {
        self.centerXAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    public func centerX(_ view: UIView, _ constant: CGFloat = 0.0)  {
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }

//    MARK: - CENTER-Y Anchor

    public func centerY(_ constant: CGFloat = 0.0) {
        self.centerYAnchor.constraint(equalTo: superview!.centerYAnchor, constant: constant).isActive = true
    }
    
    public func centerY(_ anchor: NSLayoutYAxisAnchor, _ constant: CGFloat = 0.0) {
        self.centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    public func centerY(_ anchor: NSLayoutYAxisAnchor) {
        self.centerYAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    public func centerY(_ view: UIView, _ constant: CGFloat = 0.0) {
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
        
//    MARK: - HEIGHT Anchor
    
    public func height(_ anchor: NSLayoutDimension, _ constant: CGFloat = 0.0) {
        self.heightAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    public func height(_ anchor: NSLayoutDimension) {
        self.heightAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    public func height(_ constant: CGFloat = 0.0) {
        self.heightAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func height(_ view: UIView, _ constant: CGFloat = 0.0) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor, constant: constant).isActive = true
    }
    
    public func height(_ view: UIView, with multiplier: CGFloat = 0.0) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
    
//    MARK: - WIDTH Anchor
    
    public func width(_ anchor: NSLayoutDimension, _ constant: CGFloat = 0.0){
        self.widthAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }

    public func width(_ anchor: NSLayoutDimension){
        self.widthAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    public func width(_ constant: CGFloat = 0.0) {
        self.widthAnchor.constraint(equalToConstant: constant).isActive = true
    }
    
    public func width(_ view: UIView, _ constant: CGFloat = 0.0) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor, constant: constant).isActive = true
    }
    
    public func width(_ view: UIView, with multiplier: CGFloat = 0.0) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
    }
}

extension UIView {
    
    public func anchorFill(view: UIView, safe: Bool = false) {
        anchor(view: view) { kit in
            kit.leading(self)
            kit.top(self, safe: safe)
            kit.trailing(self)
            kit.bottom(self, safe: safe)
        }
    }
    
    public func anchor(view: UIView, completion: (_ kit: UIView) -> ()) {
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        completion(view)
    }
}
