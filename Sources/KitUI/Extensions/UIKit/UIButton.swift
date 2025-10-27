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
    /// - note: Prefer chainable methods for setting properties
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
    
    /// Chainable method for setting the title color for the button
    /// - parameter color: Color to use for the title (optional)
    /// - parameter state: State to set the color for
    /// - returns: The button
    /// - note: **Mutating modifier** modifies a property of the button
    @discardableResult
    public func title(
        color: some SignalProducerConvertible<UIColor?, Never>,
        state: UIControl.State = .normal
    ) -> Self {
        self.reactive.titleColor(for: state) <~ color.producer
        return self
    }
    
    /// Chainable method for setting the title color for the button
    /// - parameter color: The color to use for the title
    /// - parameter state: The state to use for the title color
    /// - returns: The button
    /// - note: **Mutating modifier** modifies a property of the `UIButton`
    @discardableResult
    public func title(
        color: some SignalProducerConvertible<UIColor, Never>,
        state: UIControl.State = .normal
    ) -> Self {
        self.reactive.titleColor(for: state) <~ color.producer
        return self
    }
    
    /// Chainable method for setting an action to run when the button is pressed
    /// - parameter action: The action to run when the button is pressed
    /// - returns: The button
    /// - note: **Mutating modifier** modifies a property of the `UIButton`
    @discardableResult
    public func onPress(_ action: @escaping () -> Void) -> Self {
        self.reactive.onPress(action)
    }
    
    /// Chainable method for setting an action to run when the button is pressed
    /// - parameter action: The action to run when the button is pressed, receives the button as a parameter
    /// - returns: The button
    /// - note: **Mutating modifier** modifies the `UIButton`
    @discardableResult
    public func onPress(_ action: @escaping (UIButton) -> Void) -> Self {
        self.reactive.onPress { [unowned self] in
            action(self)
        }
    }

    /// Chainable method for setting an async action to run when the button is pressed
    /// - parameter action: The action to run when the button is pressed, receives the button as a parameter. If the button has deallocated before the task is run, it will still run but
    /// the button will be nil
    /// - returns: The button
    /// - note: **Mutating modifier** modifies the `UIButton`
    @discardableResult
    public func onPress(_ action: @escaping (UIButton?) async -> Void) -> Self {
        self.onPress { [weak self] in
            Task {
                await action(self)
            }
        }
    }

    /// Chainable method for setting an async action to run when the button is pressed
    /// - parameter action: The action to run when the button is pressed, receives the button as a parameter
    /// - returns: The button
    /// - note: **Mutating modifier** modifies the `UIButton`
    @discardableResult
    public func onPress(_ action: @escaping () async -> Void) -> Self {
        self.onPress {
            Task {
                await action()
            }
        }
    }
    
    /// Chainable method for setting the title of the button
    /// - parameter title: Reactive String to use as the title for the button
    /// - parameter state: State to set the title for
    /// - returns: The button
    /// - note: **Mutating modifier** modifies a property of the `UIButton`
    @discardableResult
    public func title(
        _ title: some SignalProducerConvertible<String, Never>,
        for state: UIControl.State = .normal
    ) -> Self {
        self.reactive.title(for: state) <~ title.producer
        return self
    }
    
    /// Chainable method for setting the image for the button
    /// - parameter image: Reactive image to set
    /// - parameter state: The state to set the image for
    /// - returns: The button
    /// - note: **Mutating modifier** modifies a property of the `UIButton`
    @discardableResult
    public func image(
        _ image: some SignalProducerConvertible<UIImage?, Never>,
        for state: UIControl.State = .normal
    ) -> Self {
        self.reactive.image(for: state) <~ image.producer
        return self
    }
    
    /// Chainable method for setting the font on a button
    /// - parameter font: The font to use for the button
    /// - returns: The button
    /// - note: **Mutating modifier** modifies a property of the `UIButton`
    @discardableResult
    public func font(_ font: some SignalProducerConvertible<UIFont, Never>) -> Self {
        _ = self.titleLabel?.font(font)
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
    
    // MARK: - Configuration
    @available(iOS 15.0, *)
    public func configuration(_ value: UIButton.Configuration) -> Self {
        self.configuration = value
        return self
    }
    
    @available(iOS 15.0, *)
    public func configuration(_ block: () -> UIButton.Configuration) -> Self {
        self.configuration = block()
        return self
    }
    
    @available(iOS 15.0, *)
    public func configuration(_ value: some SignalProducerConvertible<UIButton.Configuration, Never>) -> Self {
        self.reactive.configuration <~ value.producer
        return self
    }
}

// MARK: -
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
    
    @available(iOS 15.0, *)
    public var configuration: BindingTarget<UIButton.Configuration> {
        makeBindingTarget { button, configuration in
            button.configuration = configuration
        }
    }
}
#endif
