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
    public convenience init(image: UIImage?, contentMode: UIImageView.ContentMode) {
        self.init(image: image)
        self.contentMode = contentMode
    }
    
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
    
    /// TODO: Make this reactive...
    public func contentMode(_ mode: ContentMode) -> Self {
        self.contentMode = mode
        return self
    }
}

#endif
