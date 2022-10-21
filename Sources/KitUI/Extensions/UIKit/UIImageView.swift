//
//  UIImageView.swift
//

#if !os(macOS)

import Foundation
import ReactiveSwift
import ReactiveCocoa
import UIKit
import TinyConstraints

extension UIImageView {

    /// Initialize an ImageView with an image and a content mode
    /// - parameter image: The image to use
    /// - parameter contentMode: The content mode to use
    /// - returns: An `UIImageView` with the specified image and content mode
    /// - notes: Prefer using reactive initializer and content mode chainable method
    public convenience init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        self.init(image: image)
        self.contentMode = contentMode
    }
    
    /// Initialize an ImageView with a reactive image value and a content mode
    /// - parameter image: The image producer to use
    /// - parameter contentMode: The content mode to use
    /// - returns: An `UIImageView` with the specified image and content mode
    public convenience init<T: SignalProducerConvertible>(image: T, contentMode: UIImageView.ContentMode = .scaleAspectFit) where T.Value == UIImage? {
        self.init(image: nil, contentMode: contentMode)
        self.reactive.image <~ image.producer.eraseError()
    }
    
    /// Forces the image view to maintain the same aspect ratio as the `UIImage` class it contains
    public func preserveAspectRatio() -> Self {
        var currentConstraint: Constraint?
        
        let updateAspectRatio: (UIImage) -> Void = { image in
            if let constraint = currentConstraint {
                self.removeConstraint(constraint)
            }
            let aspectRatio = image.size.width / image.size.height
            currentConstraint = self.aspectRatio(aspectRatio)
            self.layoutIfNeeded()
        }
        
        if let image = self.image {
            updateAspectRatio(image)
        }
        
        let imageView = self as UIImageView
        imageView.reactive
            .signal(for: \UIImageView.image)
            .take(duringLifetimeOf: self)
            .observeValues { image in
                if let image = image {
                    updateAspectRatio(image)
                } else {
                    if let constraint = currentConstraint {
                        self.removeConstraint(constraint)
                    }
                }
            }
        
        return self
    }
    
    /// Chainable method for setting the content mode of the image view
    /// - parameter contentMode: Stream of `UIImageView.ContentMode` The content mode to use for the image view
    /// - returns: The `UIImageView`
    /// - note: **Mutating modifier** modifies a property of the `UIImageView`
    public func contentMode<T: SignalProducerConvertible>(_ mode: T) -> Self where T.Value == UIView.ContentMode {
        self.reactive.contentMode <~ mode.producer.eraseError()
        return self
    }
}

extension Reactive where Base: UIImageView {
    public var contentMode: BindingTarget<UIView.ContentMode> {
        makeBindingTarget { view, mode in
            view.contentMode = mode
        }
    }
}

#endif
