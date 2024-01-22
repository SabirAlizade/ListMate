

import UIKit

public enum CricleConfiguration {
    case circle
    case slit
}

open class CircleAnimationKit: UIView {
    
    private var shape = CAShapeLayer()
    private var tracked = CAShapeLayer()
    
    private var radius: CGFloat = 100
    private var lineWidth: CGFloat = 10
    private var dashedLine: [NSNumber] = [0, 0]
    private var color: UIColor = UIColor.black.withAlphaComponent(0.2)
    
    private var circlePath: UIBezierPath?
    private var slitPath: UIBezierPath?
    
    private var config: CricleConfiguration

    private lazy var basicAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value
        animation.duration = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        return animation
    }()
    
    private lazy var strokeStartAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.fromValue = -0.001
        animation.toValue = value
        return animation
    }()
    
    private lazy var strokeEndAnimation: CABasicAnimation = {
       let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.001
        animation.toValue = value
        return animation
    }()

    private lazy var strokeAnimationGroup: CAAnimationGroup = {
       let animation = CAAnimationGroup()
        animation.duration = 1
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.animations = [strokeStartAnimation, strokeEndAnimation]
        return animation
    }()
    
    open var circlePoint: CGPoint = CGPoint() {
        didSet {
            setLayer(point: circlePoint)
        }
    }
    
    open var value: Float = 0 {
        didSet {
            animate()
        }
    }
    
    open var circleRadius: CGFloat = 0 {
        didSet {
            radius = circleRadius
        }
    }
    
    open var circleLineWidth: CGFloat = 0 {
        didSet {
            lineWidth = circleLineWidth
        }
    }
    
    open var lineDashPattern: [NSNumber] = [] {
        didSet {
            dashedLine = lineDashPattern
        }
    }
    
    open var cricleColor: UIColor = .white {
        didSet {
            color = cricleColor
        }
    }
    
    open var progressLineWidth: CGFloat = 10 {
        didSet {
            shape.lineWidth = progressLineWidth
        }
    }
    
    open var progressColor: UIColor = .white {
        didSet {
            shape.strokeColor = progressColor.cgColor
        }
    }
    
    open var isHiddenTracker: Bool = false {
        didSet {
            tracked.isHidden = isHiddenTracker
        }
    }
    
    open var trackerRadius: CGFloat = 10 {
        didSet {
            tracked.lineWidth = trackerRadius
        }
    }
    
    open var trackerRadiusColor: UIColor = .white {
        didSet {
            tracked.strokeColor = trackerRadiusColor.cgColor
        }
    }
    
    public init(frame: CGRect, config: CricleConfiguration) {
        self.config = config
        
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("Fatal error from layer")
    }
    
    private func setLayer(point: CGPoint) {
        
        let circlePath = UIBezierPath(arcCenter: point, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 2 - 1.55, clockwise: true)
        let path = UIBezierPath(arcCenter: point, radius: radius, startAngle: 2.5 * CGFloat.pi / 3.5, endAngle: CGFloat.pi / 3.5, clockwise: true)
        
        let dashedSlitPath = UIBezierPath(arcCenter: point, radius: radius + 15, startAngle: 2.5 * CGFloat.pi / 3.5, endAngle: CGFloat.pi / 3.5, clockwise: true).cgPath
        let dashedCirclePath = UIBezierPath(arcCenter: point, radius: radius + 15, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        
        let dashedLayer = CAShapeLayer()
        dashedLayer.path = (config == .slit) ? dashedSlitPath : dashedCirclePath
        dashedLayer.fillColor = nil
        dashedLayer.lineWidth = 1.5
        dashedLayer.strokeColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        dashedLayer.lineCap = .round
        dashedLayer.lineDashPattern = dashedLine
        self.layer.addSublayer(dashedLayer)
        
        let superLayer = CAShapeLayer()
        superLayer.path = (config == .slit) ? path.cgPath : circlePath.cgPath
        superLayer.fillColor = nil
        superLayer.lineWidth = lineWidth
        superLayer.strokeColor = color.cgColor
        superLayer.lineCap = .round
        self.layer.addSublayer(superLayer)
        
        shape.path = (config == .slit) ? path.cgPath : circlePath.cgPath
        shape.fillColor = nil
        shape.lineWidth = progressLineWidth
        shape.strokeColor = progressColor.cgColor
        shape.lineCap = .round
        shape.strokeEnd = 0
        self.layer.addSublayer(shape)
        
        tracked.path = (config == .slit) ? path.cgPath : circlePath.cgPath
        tracked.fillColor = nil
        tracked.lineWidth = trackerRadius
        tracked.strokeColor = trackerRadiusColor.cgColor
        tracked.lineCap = .round
        tracked.strokeEnd = 0
        self.layer.addSublayer(tracked)

    }
    
    private func animate() {
        tracked.add(strokeAnimationGroup, forKey: nil)
        shape.add(basicAnimation, forKey: nil)
        
    }
}

