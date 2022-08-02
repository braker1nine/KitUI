//
//  UIView+Alignment.swift
//

#if !os(macOS)
import Foundation
import UIKit
import ReactiveSwift
import TinyConstraints

extension UIView {
    
    /// Wraps the view in a container and centers it both horizontally and vertically
    ///
    /// **Wrapping Modifier** Wraps the current view
    public func center() -> UIView {
        UIView.wrap(verticalAlignment: .center, horizontalAlignment: .center) { self }
    }
    
    // MARK: Vertical Alignment
    
    /// Wraps the view in a container, aligning the current view to the top
    public func top() -> UIView {
        UIView.wrap(verticalAlignment: .top) { self }
    }
    
    /// Wraps the view in a container, centering the current view vertically in the container
    public func centerVertically() -> UIView {
        UIView.wrap(verticalAlignment: .center) { self }
    }
    
    /// Wraps the view in a container, aligning it to the bottom the container
    public func bottom() -> UIView {
        UIView.wrap(verticalAlignment: .bottom) { self }
    }
    
    // MARK: Horizontal Alignment
    
    public func leading() -> UIView {
        UIView.wrap(horizontalAlignment: .leading) { self }
    }
    
    public func centerHorizontally() -> UIView {
        UIView.wrap(horizontalAlignment: .center) { self }
    }
    
    public func trailing() -> UIView {
        UIView.wrap(horizontalAlignment: .trailing) { self }
    }
    
}

#endif
