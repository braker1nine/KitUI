//
//  UIStackView.swift
//
#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

extension UIStackView {
    
    /// Initialize a stack view with the specified properties
    /// - note: Prefer using chainable methods rather than this initializer
    public convenience init(
        axis: NSLayoutConstraint.Axis = .vertical,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment =  .fill,
        spacing: CGFloat = 0,
        @UIViewBuilder builder: () -> [UIView]
    ) {
        self.init(frame: .zero)
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        
        self.isUserInteractionEnabled = true
        self.setHugging(.init(rawValue: 751), for: .vertical)
        self.setHugging(.init(rawValue: 751), for: .horizontal)
        for view in builder().compactMap({ $0 }) {
            self.addArrangedSubview(view)
        }
    }
    
    /// Initialize a stack view with the specified properties
    /// - note: Prefer using chainable methods rather than this initializer
    public convenience init(
        axis: some SignalProducerConvertible<NSLayoutConstraint.Axis, Never> = NSLayoutConstraint.Axis.vertical,
        distribution: some SignalProducerConvertible<UIStackView.Distribution, Never> = UIStackView.Distribution.fill,
        alignment: some SignalProducerConvertible<UIStackView.Alignment, Never> = UIStackView.Alignment.fill,
        spacing: some SignalProducerConvertible<CGFloat, Never> = SignalProducer<CGFloat, Never>(value: 0),
        @UIViewBuilder builder: () -> [UIView]
    ) {
        self.init(frame: .zero)
        self.reactive.axis <~ axis.producer
        self.reactive.distribution <~ distribution.producer
        self.reactive.alignment <~ alignment.producer
        self.reactive.spacing <~ spacing.producer.map(\.cgFloat)
        self.isUserInteractionEnabled = true
        self.setHugging(.init(rawValue: 751), for: .vertical)
        self.setHugging(.init(rawValue: 751), for: .horizontal)
        for view in builder().compactMap({ $0 }) {
            self.addArrangedSubview(view)
        }
    }
    
    /// Removes all arrangedSubviews from the stack view
    @objc public func removeAllArrangedSubviews() {
        let subviews = self.arrangedSubviews
        subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    /// Chainable method for setting a reactive axis
    /// - parameter axis: Property with the current axis value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func axis(_ axis: some SignalProducerConvertible<NSLayoutConstraint.Axis, Never>) -> Self {
        self.reactive.axis <~ axis.producer
        return self
    }
    
    /// Chainable method for setting a reactive spacing
    /// - parameter axis: Property with the current spacing value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func spacing(_ value: some SignalProducerConvertible<Double, Never>) -> Self {
        self.reactive.spacing <~ value.producer.map(\.cgFloat)
        return self
    }
    
    /// Chainable method for setting a reactive distribution
    /// - parameter value: Reactive `UIStackView.Distribution` value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func distribution(_ value: some SignalProducerConvertible<UIStackView.Distribution, Never>) -> Self {
        self.reactive.distribution <~ value.producer
        return self
    }
    
    /// Chainable method for setting a reactive alignment
    /// - parameter value: Reactive `UIStackView.Alignment` value
    /// - returns self
    /// - note: **Mutating Modifier** modifies a property of the `UIStackView`
    @discardableResult
    public func alignment(_ value: some SignalProducerConvertible<UIStackView.Alignment, Never>) -> Self {
        self.reactive.alignment <~ value.producer
        return self
    }
}

extension Reactive where Base: UIStackView {

    /// BindingTarget for the `spacing` property
    public var spacing: BindingTarget<CGFloat> {
        makeBindingTarget { (view, spacing) in
            view.spacing = spacing
        }
    }
    
    /// BindingTarget for the `axis` property
    public var axis: BindingTarget<NSLayoutConstraint.Axis> {
        makeBindingTarget { (view, axis) in
            view.axis = axis
        }
    }
    
    /// BindingTarget for the `distribution` property
    public var distribution: BindingTarget<UIStackView.Distribution> {
        makeBindingTarget { (view, distribution) in
            view.distribution = distribution
        }
    }
    
    /// BindingTarget for the `alignment` property
    public var alignment: BindingTarget<UIStackView.Alignment> {
        makeBindingTarget { (view, alignment) in
            view.alignment = alignment
        }
    }
}
#endif
