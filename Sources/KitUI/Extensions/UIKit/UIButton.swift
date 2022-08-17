//
//  UIButton.swift
//
#if os(iOS)
import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

extension UIButton {
    
    /// Initialize a button with the specified parameters
    /// - parameter title: String to use as the title for the button
    /// - parameter image: UIImage to use on the button
    /// - parameter textType: Type to use for the font of the text
    /// - parameter type: ButtonType for the button
    /// - parameter action: Closure to run when the button is pressed
    public convenience init(
        title: String? = nil,
        image: UIImage? = nil,
        font: UIFont? = nil,
        type: UIButton.ButtonType = .custom,
        action: (() -> Void)? = nil
    ) {
        self.init(type: type)
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        
        if let font = font, let label = self.titleLabel {
            label.font = font
        }
        
        if let action = action {
            self.reactive.onPress(action)
        }
    }
    
    @discardableResult
    public func title<T: SignalProducerConvertible>(color: T, state: UIControl.State = .normal) -> Self where T.Value == UIColor? {
        self.reactive.titleColor(for: state) <~ color.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func title<T: SignalProducerConvertible>(color: T, state: UIControl.State = .normal) -> Self where T.Value == UIColor {
        self.reactive.titleColor(for: state) <~ color.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func onPress(_ action: @escaping () -> Void) -> Self {
        self.reactive.onPress(action)
    }
    
    @discardableResult
    public func title<T: SignalProducerConvertible>(_ title: T, for state: UIControl.State = .normal) -> Self where T.Value == String {
        self.reactive.title(for: state) <~ title.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func image<T: SignalProducerConvertible>(_ image: T, for state: UIControl.State = .normal) -> Self where T.Value == UIImage {
        self.reactive.image(for: state) <~ image.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func font<T: SignalProducerConvertible>(_ font: T) -> Self where T.Value == UIFont {
        self.titleLabel?.font(font)
        return self
    }
    
    /// Wraps content in a button and provides a control state property for UI handling
    /// - parameter closure: A closure that takes a property of `UIControl.State` and returns a `UIView`. This is the content that
    /// will be placed inside the buttopn
    /// - returns: A UIButton of the class it's called on
    ///
    public static func wrap(animationDuration: TimeInterval = 0, _ closure: (Property<Bool>) -> UIView) -> UIButton {
        let button = UIButton()
        
        // TODO: Can we do this with the control state keypath?
        var state = Property<Bool>(initial: button.isHighlighted, then: button.reactive.signal(for: \UIButton.isHighlighted))
        if animationDuration > 0 {
            state = state.animated(duration: animationDuration)
        }
        
        let content = closure(state)
        content.isUserInteractionEnabled = false
        button.addSubview(content)
        content.edgesToSuperview()
        return button
    }
}

extension Reactive where Base: UIButton {
    
    /// Allows you to pass an arbitrary closure to run when a button is pressed
    ///
    /// ```
    /// self.button.reactive.onPress {
    ///     // Do stuff
    /// }
    /// ```
    ///
    @discardableResult
    public func onPress(_ action: @escaping () -> Void) -> Base {
        self.pressed = CocoaAction<Base>(ReactiveSwift.Action {
            SignalProducer<Void, Never> { (observer, _) in
                action()
                observer.sendCompleted()
            }
        })
        return self.base
    }
    
    /// A binding target to set the title color of a button for specified control state
    ///
    /// ```Swift
    /// self.reactive.titleColor(for: .normal) <~ UIColor.reactive.button
    /// ```
    ///
    public func titleColor(for state: UIControl.State = .normal) -> BindingTarget<UIColor?> {
        makeBindingTarget { (button, color) in
            button.setTitleColor(color, for: state)
        }
    }
    
    /// A binding target to set attributed text on a button
    public func attributedTitle(for state: UIControl.State = .normal) -> BindingTarget<NSAttributedString> {
        makeBindingTarget { (button, text) in
            button.setAttributedTitle(text, for: state)
        }
    }
}
#endif