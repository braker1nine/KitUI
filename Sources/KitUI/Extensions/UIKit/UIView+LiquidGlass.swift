//
//  UIView+LiquidGlass.swift
//  KitUI
//
//  Created by Chris Brakebill on 10/4/25.
//

import Foundation
import ReactiveSwift
import UIKit

extension UIView {

    /// Wraps the view in a clear glass effect
    /// - parameter disable: A signal producer that sends a boolean value to disable the glass effect
    /// - parameter fallback: A closure that returns a view to use as a fallback on older OS versions
    /// - returns: A view
    func clearGlass(
        disable: some SignalProducerConvertible<Bool, Never> = false,
    _ fallback: (UIView) -> UIView = { $0 }
    ) -> UIView {
        if #available(iOS 26, *) {
            self.glassEffect(.clear, disable: disable)
        } else {
            fallback(self)
        }
    }
    
    /// Wraps the view in a regular glass effect
    /// - parameter disable: A signal producer that sends a boolean value to disable the glass effect
    /// - parameter fallback: A closure that returns a view to use as a fallback on older OS versions
    /// - returns: A view
    func regularGlass(
        disable: some SignalProducerConvertible<Bool, Never> = false,
        _ fallback: (UIView) -> UIView = { $0 }
    ) -> UIView {
        if #available(iOS 26, *) {
            self.glassEffect(.regular, disable: disable)
        } else {
            fallback(self)
        }
    }
    
    /// Shortcut for wrapping the view in a glass effect
    /// - parameter style: The style of the glass effect
    /// - parameter disable: A signal producer that sends a boolean value to disable the glass effect
    /// - returns: A view
    @available(iOS 26.0, *)
    func glassEffect(
        _ style: UIGlassEffect.Style, 
        disable: some SignalProducerConvertible<Bool, Never> = false
    ) -> UIView {
        self.visualEffect(UIGlassEffect(style: style), disable: disable)
    }
    
    /// Wraps the view in a glass container effect
    /// - parameter spacing: The spacing between the glass views
    /// - parameter disable: A signal producer that sends a boolean value to disable the glass effect
    /// - parameter fallback: A closure that returns a view to use as a fallback on older OS versions
    /// - returns: A view
    func glassContainer(
        spacing: CGFloat? = nil,
        disable: some SignalProducerConvertible<Bool, Never> = false,
        fallback: (UIView) -> UIView = { $0 }
    ) -> UIView {
        if #available(iOS 26, *) {
            let effect = UIGlassContainerEffect()
            if let spacing {
                effect.spacing = spacing
            }
            return self.visualEffect(effect)
        } else {
            return fallback(self)
        } 
    }
}
