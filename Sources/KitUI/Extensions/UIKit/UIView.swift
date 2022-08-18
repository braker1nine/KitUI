//
//  UIView.swift
//  

#if os(iOS)

import Foundation
import ReactiveSwift
import UIKit
import TinyConstraints

// MARK: Binding Targets
extension Reactive where Base: UIView {
    public var transform: BindingTarget<CGAffineTransform> {
        makeBindingTarget {
            $0.transform = $1
        }
    }
    
    /// Binding Target for a UIView's `accessibilityLabel` property
    public var accessibilityLabel: BindingTarget<String?> {
        makeBindingTarget {
            $0.accessibilityLabel = $1
        }
    }
}

// MARK: Reactive Values
extension Reactive where Base: UIView {
    /// A signal producer which sends the `bounds` of the view
    public var bounds: SignalProducer<CGRect, Error> {
        self.signal(forKeyPath: "bounds").flatMap(.latest) { bounds in
            if let bounds = bounds as? CGRect {
                return .init(value: bounds)
            }
            
            return .init(error: NSError(domain: "", code: -1, userInfo: [:]))
        }.producer
    }
    
    // Signal that sends a new safeAreaInsets value whenever views are laid out
    public var safeAreaInsets: Signal<UIEdgeInsets, Never> {
        self.signal(for: #selector(UIView.layoutSubviews)).map { _ in self.base.safeAreaInsets }
    }
}


// MARK: Chainables
extension UIView {
    /// Chainable tint color setting
    /// - parameter color: A value with color to set as the tint
    ///
    @discardableResult
    public func tint<T: SignalProducerConvertible>(_ color: T) -> Self where T.Value == UIColor {
        self.reactive.tintColor <~ color.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func border<T: SignalProducerConvertible>(_ border: T) -> Self where T.Value == BorderStyle {
        self.layer.reactive.border <~ border.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func cornerRadius<T: SignalProducerConvertible>(_ value: T, corners: CACornerMask = .all) -> Self where T.Value: CGFloatable {
        self.clipsToBounds = true
        self.layer.reactive.cornerRadius <~ value.producer.map(\.cgFloat).eraseError()
        self.layer.maskedCorners = corners
        return self
    }
    
    @discardableResult
    public func backgroundColor<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == UIColor {
        self.reactive.backgroundColor <~ value.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func transform<T: SignalProducerConvertible>(_ value: T, animationDuration: TimeInterval = 0) -> Self where T.Value == CGAffineTransform {
        value.producer.eraseError()
            .take(duringLifetimeOf: self)
            .observe(on: QueueScheduler.main)
            .startWithValues { transform in
                UIView.animate(withDuration: animationDuration) {
                    self.transform = transform
                }
            }
        return self
    }
    
    public func hidden<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == Bool {
        self.reactive.isHidden <~ value.producer.eraseError()
        return self
    }
    
    public func alpha<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value: CGFloatable {
        self.reactive.alpha <~ value.producer.map(\.cgFloat).eraseError()
        return self
    }
    
    public func userInteractionEnabled<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == Bool {
        self.reactive.isUserInteractionEnabled <~ value.producer.eraseError()
        return self
    }
    
    /// Chainable method for setting the size on a view
    ///
    /// ```
    /// UIView().size(width: 24, height: 24)
    /// ```
    ///
    @discardableResult
    public func size<T: SignalProducerConvertible>(width: T? = nil, height: T? = nil) -> Self where T.Value: CGFloatable {
        if let width = width {
            _ = self.kit.width(width)
        }
        if let height = height {
            _ = self.kit.height(height)
        }
        return self
    }
    
    @discardableResult
    public func height<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value: CGFloatable {
        let constraint: Constraint = self.height(0)
        constraint.reactive.constant <~ value.producer.map(\.cgFloat).eraseError()
        return self
    }
    
    @discardableResult
    public func width<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value: CGFloatable {
        let constraint: Constraint = self.width(0)
        constraint.reactive.constant <~ value.producer.map(\.cgFloat).eraseError()
        return self
    }
    
    /// Chainable method for setting a size on both dimensions of a view
    @discardableResult
    public func size<T: SignalProducerConvertible>(_ size: T) -> Self where T.Value: CGFloatable {
        self
            .width(size)
            .height(size)
    }
    
    @discardableResult
    /// Chainable method for setting a reactive size on a view
    public func size<T: SignalProducerConvertible>(_ size: T) -> Self where T.Value == CGSize {
        
        self.height(size.producer.map(\.height))
            .width(size.producer.map(\.width))
    }
    
    // MARK: Accessibility Chainables
    @discardableResult
    public func accessibilityLabel<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == String {
        self.ds(\.accessibilityLabel, value.producer.map { $0 as String? })
    }
    
    public func accessibilityLabel<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == String? {
        self.ds(\.accessibilityLabel, value)
    }
    
    @discardableResult
    public func accessibilityHint<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == String {
        value.producer.eraseError().take(duringLifetimeOf: self).startWithValues { [weak self] text in
            self?.accessibilityHint = text
        }
        return self
    }
    
    @discardableResult
    public func accessibilityValue<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == String {
        value.producer.eraseError().take(duringLifetimeOf: self).startWithValues { [weak self] text in
            self?.accessibilityValue = text
        }
        return self
    }
    
    @discardableResult
    public func accessibilityTraits<T: SignalProducerConvertible>(_ traits: T) -> Self where T.Value == UIAccessibilityTraits {
        traits.producer.eraseError().take(duringLifetimeOf: self).startWithValues { [weak self] traits in
            self?.accessibilityTraits = traits
        }
        return self
    }
    
    @discardableResult
    public func isAccessibilityElement<T: SignalProducerConvertible>(_ value: T) -> Self where T.Value == Bool {
        value.producer.take(duringLifetimeOf: self).eraseError().startWithValues { [weak self] value in
            self?.isAccessibilityElement = value
        }
        return self
    }
    
    public func compressionResistance(_ priority: LayoutPriority, for axis: ConstraintAxis) -> Self {
        self.setCompressionResistance(priority, for: axis)
        return self
    }
    
    public func contentHugging(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    /// Allows you to run imperative code inline as you're building reactive UI
    public func declare(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    // MARK: Chainable Composition
    
    /// Wraps the view in another view with the specified padding
    public func padding(_ insets: UIEdgeInsets) -> UIView {
        UIView.wrap(insets: insets) {
            self
        }
    }
    
    /// Wraps the current view in a new view that pins the view's edges to
    /// the safe area
    /// - parameter edges: Set of edges to pin to safe area
    ///
    /// - returns: A new `UIView` containing `self`
    public func safeAreaEdges(_ edges: [LayoutEdge]) -> UIView {
        UIView.wrap(safeAreaEdges: edges) {
            self
        }
    }
}

// MARK: Chainable Touch Handlers
extension UIView {
    /// Adds a tap gesture to the view
    ///
    /// - returns: The `UIView` it was called on
    @discardableResult
    public func onTap(_ callback: @escaping () -> Void) -> Self {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.reactive.stateChanged.map(\.state).filter { $0 == .recognized }.take(duringLifetimeOf: self).observeValues { (_) in
            callback()
        }
        self.addGestureRecognizer(tapGesture)
        return self
    }
    
    /// Chainable method for adding a long press gesture that runs the specified block
    @discardableResult
    public func onLongPress(_ callback: @escaping (UILongPressGestureRecognizer) -> Void) -> Self {
        let gesture = UILongPressGestureRecognizer()
        gesture.reactive.stateChanged
            .map(\.state)
            .filter { $0 == .began }
            .take(duringLifetimeOf: self)
            .observeValues { _ in
                callback(gesture)
            }
        self.addGestureRecognizer(gesture)
        return self
    }
}

// MARK: Components

/// Allows stacking views on the Z axis
/// - parameter verticalAlignment: The vertical alignment of the views
/// - parameter horizontalAlignment: The horizontal alignment of the views
/// - parameter content: The views to stack
/// - returns A new `UIView` containing the stacked views
/// 
/// I'd really like to give this a different name than the SwiftUI `ZStack` component
public func ZStack(
    verticalAlignment: UIControl.ContentVerticalAlignment = .fill,
    horizontalAlignment: UIControl.ContentHorizontalAlignment = .fill,
    @UIViewBuilder _ content: () -> [UIView]
) -> UIView {
    UIView.zStack(verticalAlignment: verticalAlignment, horizontalAlignment: horizontalAlignment, content: content)
}

/// Convenience to easily generate a separator view with a color property
///
/// - parameter height: Size to make the line (defaults to 1.0)
/// - parameter color: Color to give the line, can be reactive or constant
/// - parameter axis: An axis for the direction of the line
///
public func Line<Color: SignalProducerConvertible>(
    thickness: CGFloat = 1.0,
    color: Color,
    axis: NSLayoutConstraint.Axis = .horizontal
) -> UIView where Color.Value == UIColor {
    UIView.line(thickness: thickness, color: color, axis: axis)
}

/// Generates vertical space between views
/// - parameter size: Size to make the space (defaults to nil)
/// - returns: A new `UIView` containing the space
/// 
/// If the size value is nil, then the space will have no height constraint and a low hugging priority
public func VerticalSpace(size: CGFloat? = nil) -> UIView {
    UIView.spacer(space, axis: .vertical)
}

/// Generates horizontal space between views
/// - parameter size: Size to make the space (defaults to nil)
/// - returns: A new `UIView` containing the space
/// 
/// If the size value is nil, then the space will have no width constraint and a low hugging priority
public func HorizontalSpace(size: CGFloat? = nil) -> UIView {
    UIView.spacer(space, axis: .horizontal)
}

extension UIView {
    /// Allows stacking views vertically on top of each others
    public static func zStack(
        verticalAlignment: UIControl.ContentVerticalAlignment = .fill,
        horizontalAlignment: UIControl.ContentHorizontalAlignment = .fill,
        @UIViewBuilder content: () -> [UIView]
    ) -> UIView {
        let wrapper = UIView()
        
        let children = content()
        for (_, view) in children.enumerated().reversed() {
            wrapper.addSubview(view)
            UIView.setupConstraints(
                child: view,
                insets: .zero,
                verticalAlignment: verticalAlignment,
                horizontalAlignment: horizontalAlignment
            )
        }
        return wrapper
    }
    
    /// Convenience to easily generate a separator view with a color property
    ///
    /// - parameter height: Size to make the line (defaults to 1.0)
    /// - parameter color: Color to give the line, can be reactive or constant
    /// - parameter axis: An axis for the direction of the line
    ///
    public static func line<Color: SignalProducerConvertible>(thickness: CGFloat = 1.0, color: Color, axis: NSLayoutConstraint.Axis = .horizontal) -> UIView where Color.Value == UIColor {
        let view = UIView()
        
        switch axis {
        case .horizontal:
            view.height(thickness)
        case .vertical:
            view.width(thickness)
        @unknown default:
            view.height(thickness)
        }
        
        view.reactive.backgroundColor <~ color.producer.eraseError()
        return view
    }
    
    /// Convenience method to get a statically sized invisible view for spacing
    ///
    /// Sometimes setting up constraints for varied spacing, particularly in a stack view, can be cumbersome or verbose. This makes
    /// it simple to add space between a couple views
    ///
    /// - parameter space: Size to make the view along the specified axis, a nil value will make the space expandable
    /// - parameter axis: The axis to create the spacer along. i.e. a vertical or horizontal spacer
    ///
    /// ```
    /// UIView.spacer(8, .vertical)
    /// ```
    ///
    public static func spacer(_ space: CGFloat? = nil, axis: NSLayoutConstraint.Axis = .vertical) -> UIView {
        
        let view = UIView()
        if let space = space {
            switch axis {
            case .vertical:
                view.height(space)
            case .horizontal:
                view.width(space)
            @unknown default:
                break
            }
        } else {
            view.setContentHuggingPriority(.defaultLow, for: axis)
        }
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }
}

// MARK: Experiments! Use at your own risk!
extension UIView {
    public func ds<T: SignalProducerConvertible>(_ keyPath: ReferenceWritableKeyPath<UIView, T.Value>, _ value: T) -> Self {
        value.producer.eraseError().take(duringLifetimeOf: self).startWithValues { [weak self] value in
            self?[keyPath: keyPath] = value
        }
        return self
    }
}

// This exists mostly to prevent namespacing issues with other extensions. One option to prevent this
/// was to prefix every one of these methods on the class. Or duplicate them on the class with a prefixed method,
/// one of which was really gross and the other was even grosser and polluted namespaces. This allows us to pull
/// from this `diesel` object on the view when namespace issues arise
///
/// ```
/// self.diesel.height(48)
/// ```
extension Kit where Base: UIView {
    public func height<T: SignalProducerConvertible>(_ value: T) -> Base where T.Value: CGFloatable {
        self.base.height(value)
        
    }
    
    public func width<T: SignalProducerConvertible>(_ value: T) -> Base where T.Value: CGFloatable {
        self.base.width(value)
    }
}
#endif