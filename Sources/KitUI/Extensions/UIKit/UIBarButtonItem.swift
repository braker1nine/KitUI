//
//  UIBarButtonItem.swift
//  
//

#if !os(macOS)

import Foundation
import ReactiveSwift
import ReactiveCocoa
import UIKit

extension Reactive where Base: UIBarButtonItem {
    
    /// Allows you to pass an arbitrary closure to run when a button is pressed
    ///
    /// ```
    /// self.button.reactive.onPress {
    ///     // Do stuff
    /// }
    /// ```
    ///
    public func onPress(_ action: @escaping () -> Void) {
        self.pressed = CocoaAction<Base>(ReactiveSwift.Action {
            SignalProducer<Void, Never> { (observer, _) in
                action()
                observer.sendCompleted()
            }
        })
    }
    
    /// BindingTarget for the tintColor on the item
    public var tintColor: BindingTarget<UIColor> {
        makeBindingTarget { button, color in
            button.tintColor = color
        }
    }
}

extension UIBarButtonItem {

    /// Allows you to pass an arbitrary closure to run when a button is pressed
    /// - parameter action: The action to run when the button is pressed
    /// - returns: A `UIBarButtonItem` with the specified action
    public func onPress(_ action: @escaping () -> Void) -> Self {
        self.reactive.onPress(action)
        return self
    }
}

#endif
