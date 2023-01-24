//
//  UIControl.swift
//

#if !os(macOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UIControl {
    
    /// Cache of feedback generators
    fileprivate static var generators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
    
    /// Generate impact feedback for the specified control event
    /// - parameter type: `UIImpactFeedbackGenerator.FeedbackStyle` which is the type of generator that will be used
    /// - parameter event: A `UIControl.Event` type to watch for
    /// - returns: A `UIControl` with the specified feedback generator
    /// - note: **Mutating modifier** modifies a property of the `UIControl`
    public func feedback(_ type: UIImpactFeedbackGenerator.FeedbackStyle, for event: UIControl.Event) -> Self {
        
        let generator = UIControl.generators[type] ?? UIImpactFeedbackGenerator(style: type)
        self.reactive.controlEvents(event).observeValues { _ in
            generator.impactOccurred()
        }
        UIControl.generators[type] = generator
        return self
    }
    
    /// Chainable method for setting `isSelected` state on the control
    /// - parameter isSelected: Property<Bool> with the state to set for the button
    /// - returns: The `UIControl` object
    /// - note: **Mutating modifier** modifies a property of the `UIControl`
    public func isSelected(_ isSelected: any SignalProducerConvertible<Bool, Never>) -> Self {
        self.reactive.isSelected <~ isSelected.producer
        return self
    }
}
#endif
