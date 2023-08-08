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
        color: some SignalProducerConvertible<UIColor, Never> = UIColor.black,
        offset: some SignalProducerConvertible<CGSize, Never> = CGSize(width: 0, height: 1),
        shadowRadius: some SignalProducerConvertible<Double, Never> = 5.0,
        shadowOpacity: some SignalProducerConvertible<Double, Never> = 0.3,
        cornerRadius: some SignalProducerConvertible<Double, Never> = 0.0,
        hideShadow: some SignalProducerConvertible<Bool, Never> = false
    ) -> UIView {
        let shadow = UIView()
        SignalProducer.combineLatest(
            color,
            offset,
            shadowRadius,
            shadowOpacity,
            cornerRadius,
            hideShadow,
            self.reactive.bounds.eraseError()
        )
        .observe(on: UIScheduler())
        .startWithValues { color, offset, shadowRadius, shadowOpacity, cornerRadius, hideShadow, bounds in
            shadow.layer.shadowColor = color.cgColor
            shadow.layer.shadowOffset = offset
            shadow.layer.shadowRadius = shadowRadius
            shadow.layer.shadowOpacity = Float(hideShadow ? 0 : shadowOpacity)
            shadow.layer.cornerRadius = cornerRadius
            shadow.layer.shadowPath = .init(roundedRect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius, transform: nil)
        }
        
        shadow.addSubview(self)
        self.cornerRadius(cornerRadius)
        self.edgesToSuperview()
        return shadow
    }
}
#endif
