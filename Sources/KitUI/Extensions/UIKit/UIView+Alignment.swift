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
    /// - note: **Wrapping Modifier** Wraps the current view
    public func center() -> UIView {
        UIView.wrap(verticalAlignment: .center, horizontalAlignment: .center) { self }
    }
    
    // MARK: Vertical Alignment
    
    /// Wraps the view in a container, aligning the current view to the top
    /// - note: **Wrapping Modifier** Wraps the current view
    public func top() -> UIView {
        UIView.wrap(verticalAlignment: .top) { self }
    }
    
    /// Wraps the view in a container, centering the current view vertically in the container
    /// - note: **Wrapping Modifier** Wraps the current view
    public func centerVertically() -> UIView {
        UIView.wrap(verticalAlignment: .center) { self }
    }
    
    /// Wraps the view in a container, aligning it to the bottom the container
    /// - note: **Wrapping Modifier** Wraps the current view
    public func bottom() -> UIView {
        UIView.wrap(verticalAlignment: .bottom) { self }
    }
    
    // MARK: Horizontal Alignment
    
    /// Wraps the view in a container, aligning the current view to the leading edge
    /// - note: **Wrapping Modifier** Wraps the current view
    public func leading() -> UIView {
        UIView.wrap(horizontalAlignment: .leading) { self }
    }
    
    /// Wraps the view in a container, centering the current view horizontally in the container
    /// - note: **Wrapping Modifier** Wraps the current view
    public func centerHorizontally() -> UIView {
        UIView.wrap(horizontalAlignment: .center) { self }
    }
    
    /// Wraps the view in a container, aligning it to the trailing edge of the container
    /// - note: **Wrapping Modifier** Wraps the current view
    public func trailing() -> UIView {
        UIView.wrap(horizontalAlignment: .trailing) { self }
    }
}

#endif
