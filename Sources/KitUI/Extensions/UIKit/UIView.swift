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
    
    public var accessibilityHint: BindingTarget<String?> {
        makeBindingTarget {
            $0.accessibilityHint = $1
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
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func tint(_ color: some SignalProducerConvertible<UIColor, Never>) -> Self {
        self.reactive.tintColor <~ color.producer
        return self
    }
    
    /// Chainable border setting
    /// - parameter border: A reactive value with a border to set on the view
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func border(_ border: some SignalProducerConvertible<BorderStyle, Never>) -> Self {
        
        /// This producer is a stream of values containing this view's traitCollection.userInterfaceStyle
        let styleProducer = SignalProducer<UIUserInterfaceStyle?, Never>.merge(
            
            /// Send the current initial value to the producer
            SignalProducer<UIUserInterfaceStyle?, Never>(value: self.traitCollection.userInterfaceStyle),
            
            /// Each time `traitCollectionDidChange` is called, send the current `userInterfaceStyle`
            /// Call `skipRepeats` so we only send values when the style changes
            self.reactive.trigger(for: #selector(traitCollectionDidChange))
                .map { [weak self] _ in
                    self?.traitCollection.userInterfaceStyle
                }.skipRepeats()
        )
        
        /// Combine the border values with the interfaceStyle producer, and map it to the border style
        /// value, then pipe those border styles into the layer
        self.layer.reactive.border <~ border.producer.combineLatest(with: styleProducer).map(\.0)
        return self
    }
    
    /// Chainable corner radius setting
    /// - parameter value: A reactive value with a corner radius to set on the view
    /// - parameter corners: The corners to apply the radius to
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func cornerRadius(
        _ value: some SignalProducerConvertible<Double, Never>,
        corners: CACornerMask = .all
    ) -> Self{
        self.clipsToBounds = true
        self.layer.reactive.cornerRadius <~ value.producer.map(\.cgFloat)
        self.layer.maskedCorners = corners
        return self
    }
    
    /// Chainable background color setting
    /// - parameter value: A reactive alue with color to set as the background
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func backgroundColor(_ value: some SignalProducerConvertible<UIColor, Never>) -> Self {
        self.reactive.backgroundColor <~ value.producer
        return self
    }

    /// Wraps the view in a new view with the specified gradient behind it
    /// - parameter gradient: A value with a gradient to set as the background
    /// - returns: A new view with the gradient as its background
    @discardableResult
    public func gradient(_ layer: CAGradientLayer) -> UIView {
        let container = UIView.wrap { self }
        container.layer.insertSublayer(layer, below: self.layer)
        container.reactive.signal(for: #selector(UIView.layoutSubviews)).observeValues { _ in
            layer.frame = container.bounds
        }
        return container
    }
    
    /// Chainable transform setting
    /// - parameter transform: A reactive value with a transform to set on the view
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func transform(_ value: some SignalProducerConvertible<CGAffineTransform, Never>) -> Self {
        value.producer
            .take(duringLifetimeOf: self)
            .startWithValues { [weak self] transform in
                self?.transform = transform
            }
        return self
    }
    
    /// Chainable hidden setting
    /// - parameter hidden: A reactive value with a boolean to set as the hidden state
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func hidden(_ value: some SignalProducerConvertible<Bool, Never>) -> Self {
        self.reactive.isHidden <~ value.producer
        return self
    }
    
    /// Chainable alpha setting
    /// - parameter alpha: A reactive value with a float to set as the alpha
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func alpha(_ value: some SignalProducerConvertible<Double, Never>) -> Self {
        self.reactive.alpha <~ value.producer.map(\.cgFloat)
        return self
    }
    
    /// Chainable isUserInteractionEnabled setting
    /// - parameter value: A reactive value with a boolean to set as the isUserInteractionEnabled
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func userInteractionEnabled(_ value: some SignalProducerConvertible<Bool, Never>) -> Self {
        self.reactive.isUserInteractionEnabled <~ value.producer
        return self
    }
    
    /// Chainable method for setting the size on a view
    /// - parameter width: A reactive value with a float to set as the width
    /// - parameter height: A reactive value with a float to set as the height
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    ///
    /// ```
    /// UIView().size(width: 24, height: 24)
    /// ```
    ///
    @discardableResult
    public func size(
        width: (any SignalProducerConvertible<Double, Never>)? = nil,
        height: (any SignalProducerConvertible<Double, Never>)? = nil
    ) -> Self {
        if let width = width {
            _ = self.kit.width(width)
        }
        if let height = height {
            _ = self.kit.height(height)
        }
        return self
    }
    
    /// Chainable method for setting the height on a view
    /// - parameter value: A reactive value with a float to set as the height
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func height(_ value: some SignalProducerConvertible<Double, Never>) -> Self {
        let constraint: Constraint = self.height(0)
        constraint.reactive.constant <~ value.producer.map(\.cgFloat)
        return self
    }
    
    /// Chainable method for setting the width on a view
    /// - parameter value: A reactive value with a float to set as the width
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func width(_ value: some SignalProducerConvertible<Double, Never>) -> Self {
        let constraint: Constraint = self.width(0)
        constraint.reactive.constant <~ value.producer.map(\.cgFloat)
        return self
    }
    
    /// Chainable method for setting a size on both dimensions of a view
    /// - parameter value: A reactive value with a float to set as the width and height
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func size(_ size: some SignalProducerConvertible<Double, Never>) -> Self {
        self
            .width(size)
            .height(size)
    }
    
    /// Chainable method for setting an aspect ratio on a view
    /// - parameter ratio: A reactive aspect ratio to use
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies the state of the current view
    @discardableResult
    public func aspectRatio(_ ratio: some SignalProducerConvertible<Double, Never>) -> Self {
        var constraint: Constraint?
        ratio.producer.take(duringLifetimeOf: self).startWithValues { [weak self] multiplier in
            constraint?.isActive = false
            constraint = self?.aspectRatio(multiplier)
        }
        return self
    }
    
    /// Chainable method for setting a reactive size on a view
    /// - parameter size: A reactive value with a size to set as the size
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func size(_ size: some SignalProducerConvertible<CGSize, Never>) -> Self {
        
        self.height(size.producer.map(\.height).map(Double.init))
            .width(size.producer.map(\.width).map(Double.init))
    }
    
    // MARK: Accessibility Chainables

    /// Chainable method for setting the accessibility label on a view
    /// - parameter value: A reactive value with a `String?` to set as the accessibility label
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityLabel(_ value: some SignalProducerConvertible<String, Never>) -> Self {
        self.reactive.accessibilityLabel <~ value.producer
        return self
    }
    
    /// Chainable method for setting the accessibility hint on a view
    /// - parameter value: A reactive `String` value to set as the accessibility hint
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityHint(_ value: some SignalProducerConvertible<String, Never>) -> Self  {
        self.reactive.accessibilityHint <~ value.producer
        return self
    }
    
    /// Chainable method for setting the accessibility value on a view
    /// - parameter value: A reactive `String` value to set as the accessibility value
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityValue(_ value: some SignalProducerConvertible<String, Never>) -> Self {
        value.producer.take(duringLifetimeOf: self).startWithValues { [weak self] text in
            self?.accessibilityValue = text
        }
        return self
    }
    
    /// Chainable method for setting the accessibility traits on a view
    /// - parameter value: A reactive `UIAccessibilityTraits` value to set as the accessibility traits
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func accessibilityTraits(_ traits: some SignalProducerConvertible<UIAccessibilityTraits, Never>) -> Self {
        traits.producer.take(duringLifetimeOf: self).startWithValues { [weak self] traits in
            self?.accessibilityTraits = traits
        }
        return self
    }
    
    /// Chainable method for setting `isAccessibilityElement` on a view
    /// - parameter value: A reactive `Bool` value to set as the `isAccessibilityElement`
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func isAccessibilityElement(_ value: some SignalProducerConvertible<Bool, Never>) -> Self {
        value.producer.take(duringLifetimeOf: self).startWithValues { [weak self] value in
            self?.isAccessibilityElement = value
        }
        return self
    }
    
    /// Chainable method for setting a views compression resistance priority
    /// - parameter priority: A `UILayoutPriority` value to set as the compression resistance priority
    /// - parameter axis: The axis to set the compression resistance priority on
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func compressionResistance(_ priority: LayoutPriority, for axis: ConstraintAxis) -> Self {
        self.setCompressionResistance(priority, for: axis)
        return self
    }
    
    /// Chainable method for setting a view's content hugging priority
    /// - parameter priority: A `UILayoutPriority` value to set as the content hugging priority
    /// - parameter axis: The axis to set the content hugging priority on
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
    @discardableResult
    public func contentHugging(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }
    
    /// Chainable method for running imperative code on a view
    /// - parameter closure: A closure to run on the view
    /// - returns: The current view
    /// Cannot use `Self` in the closure as it's only allowed in a result position
    /// https://github.com/apple/swift/issues/58638#issuecomment-1409503072
    public func declare(_ closure: (UIView) -> Void) -> Self {
        closure(self)
        return self
    }
    
    // MARK: Chainable Composition
    
    /// Chainable method for adding padding to a view
    /// - parameter insets: A `Double` value to set as the padding
    /// - returns: A new view containing the current view with padding
    /// - note: **Wrapping Modifier** this returns a new view
    public func padding(_ insets: some SignalProducerConvertible<Double, Never>) -> UIView {
        self.padding(insets.producer.map(\.cgFloat).map { UIEdgeInsets.uniform($0) })
    }
    
    /// Chainable method for adding adding to a view
    /// - parameter insets: A reactive `UIEdgeInsets` value to set as the padding
    /// - returns: A new view containing the current view with padding
    /// - note: **Wrapping Modifier** this returns a new view
    public func padding(_ insets: some SignalProducerConvertible<UIEdgeInsets, Never>) -> UIView {
        UIView.wrap(configuration: insets.producer.map { WrapConfiguration(insets: $0) }) {
            self
        }
    }
    
    /// Chainable method for adding adding to a view
    /// - parameter insets: A `UIEdgeInsets` value to set as the padding
    /// - returns: A new view containing the current view with padding
    /// - note: **Wrapping Modifier** this returns a new view
    public func padding(_ insets: UIEdgeInsets) -> UIView {
        UIView.wrap(configuration: WrapConfiguration(insets: insets)) {
            self
        }
    }
    
    /// Chainable method for adding padding to a view
    /// - parameter insets: A `CGFloatable` value to set as the padding
    /// - returns: A new view containing the current view with padding
    /// - note: **Wrapping Modifier** this returns a new view
    public func padding(_ insets: CGFloatable) -> UIView {
        self.padding(SignalProducer<Double, Never>(value: Double(insets.cgFloat)))
    }

    
    /// Wraps the current view in a new view that pins the view's edges to the safe area
    /// - parameter edges: Set of edges to pin to safe area
    /// - returns: A new `UIView` containing `self`
    /// - note: **Wrapping Modifier** this returns a new view
    public func safeAreaEdges(_ edges: [LayoutEdge]) -> UIView {
        UIView.wrap(safeAreaEdges: edges) {
            self
        }
    }
}

// MARK: Chainable Touch Handlers
extension UIView {

    /// Adds a tap gesture to the view, which will trigger the given action when tapped
    /// - parameter callback: The action to trigger when the view is tapped
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
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
    /// - parameter callback: The action to trigger when the view is long pressed
    /// - returns: The current view
    /// - note: **Mutating Modifier** this modifies a property on the current view
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
/// - returns: A new `UIView` containing the separator line
///
public func Line(
    thickness: CGFloat = 1.0,
    color: some SignalProducerConvertible<UIColor, Never>,
    axis: NSLayoutConstraint.Axis = .horizontal
) -> UIView {
    UIView.line(thickness: thickness, color: color, axis: axis)
}

/// Generates vertical space between views
/// - parameter size: Size to make the space (defaults to nil)
/// - returns: A new `UIView` containing the space
/// 
/// If the size value is nil, then the space will have no height constraint and a low hugging priority
public func VerticalSpace(_ size: CGFloat? = nil) -> UIView {
    UIView.spacer(size, axis: .vertical)
}

/// Generates horizontal space between views
/// - parameter size: Size to make the space (defaults to nil)
/// - returns: A new `UIView` containing the space
/// 
/// If the size value is nil, then the space will have no width constraint and a low hugging priority
public func HorizontalSpace(_ size: CGFloat? = nil) -> UIView {
    UIView.spacer(size, axis: .horizontal)
}

/// Generates a generally flexible spacer view
public func FlexibleSpace() -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setContentHuggingPriority(.init(1), for: .vertical)
    view.setContentHuggingPriority(.init(1), for: .horizontal)
    return view
}

extension UIView {
    /// Allows stacking views vertically on top of each others
    static func zStack(
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
    static func line(
        thickness: CGFloat = 1.0,
        color: some SignalProducerConvertible<UIColor, Never>,
        axis: NSLayoutConstraint.Axis = .horizontal
    ) -> UIView {
        let view = UIView()
        
        switch axis {
        case .horizontal:
            view.height(thickness)
        case .vertical:
            view.width(thickness)
        @unknown default:
            view.height(thickness)
        }
        
        view.reactive.backgroundColor <~ color.producer
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
    static func spacer(_ space: CGFloat? = nil, axis: NSLayoutConstraint.Axis = .vertical) -> UIView {
        
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

// This exists mostly to prevent namespacing issues with other extensions. One option to prevent this
/// was to prefix every one of these methods on the class. Or duplicate them on the class with a prefixed method,
/// one of which was really gross and the other was even grosser and polluted namespaces. This allows us to pull
/// from this `diesel` object on the view when namespace issues arise
///
/// ```
/// self.diesel.height(48)
/// ```
extension Kit where Base: UIView {

    /// Sets the height of the base view to any values sent through the signal
    /// - parameter value: A signal of height values
    /// - returns the `base` view
    public func height(_ value: some SignalProducerConvertible<Double, Never>) -> Base {
        self.base.height(value)
    }
    
    /// Sets the width of the base view to any values sent through the signal
    /// - parameter value: A signal of width values
    /// - returns the `base` view
    public func width(_ value: some SignalProducerConvertible<Double, Never>) -> Base {
        self.base.width(value)
    }
    
    public func aspectRatio(_ value: some SignalProducerConvertible<Double, Never>) -> Base {
        self.base.aspectRatio(value)
    }
}
#endif
