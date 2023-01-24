//
//  UIView+Shadow.swift
//  
#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift

extension UIView {
    
    /// Wraps the view in a container view with a shadow
    /// - parameter cornerRadius: The corner radius for the shadow view
    /// - parameter hideShadow
    /// - returns A `UIView` with the specified shadow
    /// - note: This currently supplies a default shadow color, opacity, offset, and radius
    public func shadow(
        cornerRadius: Int = 0,
        hideShadow: any SignalProducerConvertible<Bool, Never> = false
    ) -> UIView {
        let shadow = UIView()
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = .init(width: 0, height: 1)
        shadow.layer.shadowRadius = 5
        shadow.layer.shadowOpacity = 0.3
        shadow.layer.cornerRadius = .init(cornerRadius)
        
        shadow.addSubview(self)
        self.cornerRadius(CGFloat(cornerRadius))
        self.edgesToSuperview()
        return shadow
    }
}
#endif
