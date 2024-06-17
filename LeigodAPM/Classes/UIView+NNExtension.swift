//
//  UIView+NNExtension.swift
//  LeigodAPM
//
//  Created by xyk on 2024/6/17.
//

import Foundation
import UIKit

public struct CornerRadii{
    var topLeft: CGFloat = 0
    var topRight: CGFloat = 0
    var bottomLeft: CGFloat = 0
    var bottomRight: CGFloat = 0
    
    public init(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }
}

public extension UIView {
    static func createCornerRadii(bounds:CGRect,cornerRadii:CornerRadii) -> CGMutablePath{
       
        let minX = bounds.minX
        let minY = bounds.minY
        let maxX = bounds.maxX
        let maxY = bounds.maxY
        
        let topLeftCenterX = minX + cornerRadii.topLeft
        let topLeftCenterY = minY + cornerRadii.topLeft;
        
        let topRightCenterX = maxX - cornerRadii.topRight;
        let topRightCenterY = minY + cornerRadii.topRight;
        
        let bottomLeftCenterX = minX + cornerRadii.bottomLeft;
        let bottomLeftCenterY = maxY - cornerRadii.bottomLeft;
        
        let  bottomRightCenterX = maxX - cornerRadii.bottomRight;
        let bottomRightCenterY = maxY - cornerRadii.bottomRight;
        
        let path = CGMutablePath.init()
        path.addArc(center: CGPoint.init(x: topLeftCenterX, y: topLeftCenterY), radius: cornerRadii.topLeft, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: false)
        
        path.addArc(center: CGPoint.init(x: topRightCenterX, y: topRightCenterY), radius: cornerRadii.topRight, startAngle: 1.5 * .pi, endAngle: 0, clockwise: false)
        
        path.addArc(center: CGPoint.init(x: bottomRightCenterX, y: bottomRightCenterY), radius: cornerRadii.bottomRight, startAngle: 0, endAngle: 0.5 * .pi, clockwise: false)
        
        path.addArc(center: CGPoint.init(x: bottomLeftCenterX, y: bottomLeftCenterY), radius: cornerRadii.bottomLeft, startAngle: 0.5 * .pi, endAngle:  .pi, clockwise: false)
        // 开始图形上下文
        path.closeSubpath()
        return path
    }
    
    func addCorner(
        cornerRadii: CornerRadii,
        bounds: CGRect = .zero,
        borderWith: CGFloat = 0,
        borderColor: UIColor = UIColor.clear) {
           
            DispatchQueue.main.async {
                
                // 解决复用的问题
                if let sublayers = self.layer.sublayers {
                    sublayers.forEach { layer in
                        if layer.name == self.className {
                            layer.removeFromSuperlayer()
                        }
                    }
                }
                
                let maskPath = UIView.createCornerRadii(bounds: self.bounds, cornerRadii: cornerRadii)
                let masklayer = CAShapeLayer()
                masklayer.frame = self.bounds
                masklayer.name  = self.className
                masklayer.path  = maskPath
                self.layer.mask = masklayer
                
                let pathLayer = CAShapeLayer()
                pathLayer.lineWidth = borderWith
                pathLayer.strokeColor = borderColor.cgColor
                pathLayer.fillColor = nil
                pathLayer.path = maskPath
                
                self.layer.addSublayer(pathLayer)
            }
        
    }
    
    // 指定frame添加圆角
    func addCorner(radius : CGFloat, conrners : UIRectCorner = .allCorners, borderColor :UIColor = .clear, frame: CGRect) {
        DispatchQueue.main.async {
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            if frame != .zero {
                maskLayer.frame = frame
            } else {
                maskLayer.frame = self.bounds
            }
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    //添加圆角
    func addCorner(radius : CGFloat, conrners : UIRectCorner = .allCorners, borderColor :UIColor = .clear) {
        DispatchQueue.main.async {
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
    }
    
    //添加圆角边框
    func addCornerBorder(radius: CGFloat,
                         conrners: UIRectCorner = .allCorners,
                         borderColor :UIColor,
                         borderWidth:CGFloat,
                         fillColor:UIColor){
        DispatchQueue.main.async {
            
            // 解决复用的问题
            if let sublayers = self.layer.sublayers {
                sublayers.forEach { layer in
                    if layer.name == self.className {
                        layer.removeFromSuperlayer()
                    }
                }
            }
            
            var tempRect =  self.bounds
            tempRect = CGRect(x: 0, y: borderWidth * 0.5, width: self.bounds.width, height:self.bounds.height - borderWidth )
            let maskPath = UIBezierPath(roundedRect: tempRect, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.name = self.className
            maskLayer.frame = self.bounds
            maskLayer.path = maskPath.cgPath
            maskLayer.strokeColor = borderColor.cgColor
            maskLayer.lineWidth = borderWidth
            maskLayer.fillColor = fillColor.cgColor
            self.layer.insertSublayer(maskLayer, at: 0)
        }
    }

    //添加指定边的边框
    func addBorder(top:Bool,
                   left:Bool,
                   bottom:Bool,
                   right:Bool,
                   borderColor:UIColor,
                   borderWidth:CGFloat){
        if top {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height:borderWidth)
            layer.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(layer)
        }
        if left {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: borderWidth, height:self.frame.size.height)
            layer.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(layer)
        }
        if bottom {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:self.frame.size.width, height:borderWidth)
            layer.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(layer)
        }
        if right {
            let layer = CALayer()
            layer.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width:borderWidth, height:self.frame.size.height)
            layer.backgroundColor = borderColor.cgColor
            self.layer.addSublayer(layer)
        }
    }
    
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移量
    ///   - opacity: 阴影透明度
    ///   - radius: 阴影半径
    ///   width : 为正数时，向右偏移，为负数时，向左偏移
    //    height : 为正数时，向下偏移，为负数时，向上偏移
    func addShadow(color: UIColor, offset:CGSize, opacity:Float, radius:CGFloat) {
        self.clipsToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}

extension UIView {
    
    // MARK: - 常用位置属性
    public var left:CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newLeft) {
            var frame = self.frame
            frame.origin.x = newLeft
            self.frame = frame
            
        }
    }
    
    public var top:CGFloat {
        get {
            return self.frame.origin.y
        }
        
        set(newTop) {
            var frame = self.frame
            frame.origin.y = newTop
            self.frame = frame
        }
    }
    
    public var width:CGFloat {
        get {
            return self.frame.size.width
        }
        
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
    }
    
    public var height:CGFloat {
        get {
            return self.frame.size.height
        }
        
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
    }
    
    public var right:CGFloat {
        get {
            return self.left + self.width
        }
    }
    
    public var bottom:CGFloat {
        get {
            return self.top + self.height
        }
    }
    
    public var centerX:CGFloat {
        get {
            return self.center.x
        }
        
        set(newCenterX) {
            var center = self.center
            center.x = newCenterX
            self.center = center
        }
    }
    
    public var centerY:CGFloat {
        get {
            return self.center.y
        }
        
        set(newCenterY) {
            var center = self.center
            center.y = newCenterY
            self.center = center
        }
    }
    
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}

extension UIView{
    
    /// 是否存在指定view
    public func isExistView<T: UIView>(type: T.Type) -> Bool{
        var isExist = false
        for view in self.subviews where view is T {
            isExist = true
        }
        return isExist
    }
    
    /// 移除指定view
    public func removeTargetView<T: UIView>(type: T.Type) {
        for view in self.subviews where view is T {
            view.removeFromSuperview()
        }
    }
    
    public func getNavigationController() -> UINavigationController? {
        var obj = next
        while obj != nil {
            if let nav = obj as? UINavigationController {
                return nav
            }
            obj = obj?.next
        }
        return nil
    }
    
    public func getTabBarController() -> UITabBarController? {
        var obj = next
        while obj != nil {
            if let tab = obj as? UITabBarController {
                return tab
            }
            obj = obj?.next
        }
        return nil
    }
    
    public func getViewController() -> UIViewController? {
        var obj = next
        while obj != nil {
            if let vc = obj as? UIViewController {
                return vc
            }
            obj = obj?.next
        }
        return nil
    }
    
    public func rootView() -> UIView {
        guard let parentView = superview else {
            return self
        }
        return parentView.rootView()
    }
    
    public func add(subViews: [UIView]) {
        subViews.forEach({self.addSubview($0)})
    }
    
    public func addSubviews(_ views: [UIView]) {
        views.forEach { eachView in
            self.addSubview(eachView)
        }
    }
    
    public func remove(subViews : [UIView]) {
        subViews.forEach({$0.removeFromSuperview()})
    }
    
    public func removeSubviews(_ views: [UIView]) {
        for subview in views {
            subview.removeFromSuperview()
        }
    }
    
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    public func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }
    
    public func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }
        
        self.x = parentView.width/2 - self.width/2
    }
    
    public func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }
        
        self.y = parentView.height/2 - self.height/2
    }
    
    public func centerInSuperView() {
        self.centerXInSuperView()
        self.centerYInSuperView()
    }
}

// MARK:- Animation Extensions

extension UIView {
    
    public func fadeIn(duration: TimeInterval = 1, completion:((Bool) -> Void)? = nil) {
        if self.isHidden {
            self.isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    public func fadeOut(duration: TimeInterval = 1, completion:((Bool) -> Void)? = nil) {
        if self.isHidden {
            self.isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    public func rotateX(_ x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, (.pi * x) / 180.0, 1.0, 0.0, 0.0)
        self.layer.transform = transform
    }
    
    public func rotateY(_ y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, (.pi * y) / 180.0, 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }
    
    public func rotateZ(_ z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, (.pi * z) / 180.0, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    public func rotate(x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, (.pi * x) / 180.0, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, (.pi * y) / 180.0, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, (.pi * z) / 180.0, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    public func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
}

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

// MARK: Animation Extensions
extension UIView {

    public func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    public func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIView.AnimationOptions.allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }

    public func animate(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }

    public func animate(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }

    public func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
            })
    }

    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
            })
    }

    public func reversePop() {
        setScale(x: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.05, delay: 0, options: .allowUserInteraction, animations: {[weak self] in
            self?.setScale(x: 1, y: 1)
        }, completion: { (_) in })
    }
}
extension NSObject {
    
    public var className: String {return type(of: self).className}
    
    public static var className: String {return String(describing: self)}
    
}
