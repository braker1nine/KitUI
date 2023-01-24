//
//  UIActivityIndicatorView.swift
//  
//
#if os(iOS)
import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension Reactive where Base: UIActivityIndicatorView {
    
    /// A `BindingTarget` to set the `color` on the `UIActivityIndicatorView`
    public var color: BindingTarget<UIColor> {
        makeBindingTarget { indicator, color in
            indicator.color = color
        }
    }
}

extension UIActivityIndicatorView {
    
    /// Chainable method for setting the color on a `UIActivityIndicatorView
    /// - parameter color: A `Property` which will set & update the color on the view
    /// - returns: The `UIActivityIndicatorView` it's called on
    /// - note: **Modifying modifier** modifies a property of the `UIActivityIndicatorView`
    public func color(_ color: any SignalProducerConvertible<UIColor, Never>) -> Self {
        self.reactive.color <~ color.producer
        return self
    }
    
    /// Chainable method for setting the isAnimating property on a `UIActivityIndicatorView
    /// - parameter isAnimating: A `Property` which will set & update the animating state on the view
    /// - returns: The `UIActivityIndicatorView` it's called on
    /// - note: **Modifying modifier** modifies a property of the `UIActivityIndicatorView`
    public func isAnimating(_ isAnimating: any SignalProducerConvertible<Bool, Never>) -> Self {
        self.reactive.isAnimating <~ isAnimating.producer
        return self
    }
}
#endif
