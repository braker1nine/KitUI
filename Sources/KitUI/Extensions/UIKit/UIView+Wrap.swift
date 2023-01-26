//
//  UIView+Wrap.swift
//  

#if os(iOS)

import Foundation
import UIKit
import TinyConstraints
import ReactiveSwift

/// Represents wrapping configuration for a view
public struct WrapConfiguration: Equatable {

    /// The insets to use for wrapping
    let insets: UIEdgeInsets

    /// The vertical alignment for the child view
    let verticalAlignment: UIControl.ContentVerticalAlignment

    /// The horizontal alignment for the child view
    let horizontalAlignment: UIControl.ContentHorizontalAlignment

    /// Safe area edges to respect when wrapping
    let safeAreaEdges: [LayoutEdge]
    
    /// Initializes a new `WrapConfiguration`
    /// - parameter insets: The insets to use for wrapping
    /// - parameter verticalAlignment: The vertical alignment for the child view
    /// - parameter horizontalAlignment: The horizontal alignment for the child view
    /// - parameter safeAreaEdges: Safe area edges to respect when wrapping
    /// - returns: A new `WrapConfiguration`
    public init(
        insets: UIEdgeInsets = .zero,
        verticalAlignment: UIControl.ContentVerticalAlignment = .fill,
        horizontalAlignment: UIControl.ContentHorizontalAlignment = .fill,
        safeAreaEdges: [LayoutEdge] = []
    ) {
        self.insets = insets
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.safeAreaEdges = safeAreaEdges
    }
}

extension UIView {
    
    /// Wrap a view in a container with insets at padding
    ///
    /// - parameter insets: Padding around the child view
    /// - parameter verticalAlignment: Tells the wrapper how to vertically align the child view (fill, top, bottom, center)
    /// - parameter horizontalAlignment: Tells the wrapper how to horizontally align the child view (fill, leading, trailing, center)
    /// - parameter safeAreaEdges: Tells the wrap which edges to pin to safe areas
    /// - parameter content: A closure that returns the child view (mostly just allows for a more visual layout at call site)
    ///
    public static func wrap(
        insets: UIEdgeInsets = .zero,
        verticalAlignment: UIControl.ContentVerticalAlignment = .fill,
        horizontalAlignment: UIControl.ContentHorizontalAlignment = .fill,
        safeAreaEdges: [LayoutEdge] = [],
        _ content: () -> UIView
    ) -> Self {
        Self.wrap(
            insets: insets,
            verticalAlignment: verticalAlignment,
            horizontalAlignment: horizontalAlignment,
            safeAreaEdges: safeAreaEdges,
            content: content()
        )
    }
    
    private static func wrap(
        insets: UIEdgeInsets = .zero,
        verticalAlignment: UIControl.ContentVerticalAlignment = .fill,
        horizontalAlignment: UIControl.ContentHorizontalAlignment = .fill,
        safeAreaEdges: [LayoutEdge] = [],
        content: UIView
    ) -> Self {
        
        let view: Self = Self()
        view.backgroundColor = .clear
        view.addSubview(content)
        
        UIView.setupConstraints(
            child: content,
            insets: insets,
            verticalAlignment: verticalAlignment,
            horizontalAlignment: horizontalAlignment,
            safeAreaEdges: safeAreaEdges
        )
        
        view.setHugging(.init(rawValue: 751), for: .vertical)
        view.setHugging(.init(rawValue: 751), for: .horizontal)
        
        return view
    }
    
    
    /// Wrap a view with a reactive `WrapConfiguration` value. This allows you to reactively change the insets,
    /// content mode, or use of safe areas
    /// - parameter configuration: A `SignalProducerConvertible` with `WrapConfiguration` value to supply to the view. This will update
    ///   the child view's wrap configuration reactively
    /// - parameter view: A closure which returns the view to add as a child
    /// - returns: A new `UIView` with the specified configuration
    public static func wrap(
        configuration: some SignalProducerConvertible<WrapConfiguration, Never>,
        _ view: () -> UIView
    ) -> UIView {
        let child = view()
        let view = UIView()
        view.addSubview(child)
        
        var constraints: Constraints?
        
        configuration.producer.startWithValues { config in
            constraints?.deActivate()
            constraints = UIView.setupConstraints(
                child: child,
                insets: config.insets,
                verticalAlignment: config.verticalAlignment,
                horizontalAlignment: config.horizontalAlignment,
                safeAreaEdges: config.safeAreaEdges
            )
            
            view.layoutIfNeeded()
        }
        
        return view
    }
    
    @discardableResult
    static func setupConstraints(
        child: UIView,
        insets: UIEdgeInsets,
        verticalAlignment: UIControl.ContentVerticalAlignment,
        horizontalAlignment: UIControl.ContentHorizontalAlignment,
        safeAreaEdges: [LayoutEdge] = []
    ) -> [Constraint] {
        
        var constraints: [Constraint] = []
        let useSafeAreaForEdge: (LayoutEdge) -> Bool = { safeAreaEdges.contains($0) }
        
        switch verticalAlignment {
        case .top:
            constraints.append(child.topToSuperview(offset: insets.top, usingSafeArea: useSafeAreaForEdge(.top)))
            constraints.append(child.bottomToSuperview(offset: -insets.bottom, relation: .equalOrLess, usingSafeArea: useSafeAreaForEdge(.bottom)))
        case .bottom:
            constraints.append(child.topToSuperview(offset: insets.top, relation: .equalOrGreater, usingSafeArea: useSafeAreaForEdge(.top)))
            constraints.append(child.bottomToSuperview(offset: -insets.bottom, usingSafeArea: useSafeAreaForEdge(.bottom)))
        case .center:
            constraints.append(child.topToSuperview(offset: insets.top, relation: .equalOrGreater, usingSafeArea: useSafeAreaForEdge(.top)))
            constraints.append(child.bottomToSuperview(offset: -insets.bottom, relation: .equalOrLess, usingSafeArea: useSafeAreaForEdge(.bottom)))
            constraints.append(child.centerYToSuperview())
        default:
            constraints.append(child.topToSuperview(offset: insets.top, usingSafeArea: useSafeAreaForEdge(.top)))
            constraints.append(child.bottomToSuperview(offset: -insets.bottom, usingSafeArea: useSafeAreaForEdge(.bottom)))
        }
        
        switch horizontalAlignment {
        case .leading, .left:
            constraints.append(child.leadingToSuperview(offset: insets.left, usingSafeArea: useSafeAreaForEdge(.leading)))
            constraints.append(child.trailingToSuperview(offset: insets.right, relation: .equalOrLess, usingSafeArea: useSafeAreaForEdge(.trailing)))
        case .trailing, .right:
            constraints.append(child.leadingToSuperview(offset: insets.left, relation: .equalOrGreater, usingSafeArea: useSafeAreaForEdge(.leading)))
            constraints.append(child.trailingToSuperview(offset: insets.right, usingSafeArea: useSafeAreaForEdge(.trailing)))
        case .center:
            constraints.append(child.leadingToSuperview(offset: insets.left, relation: .equalOrGreater, usingSafeArea: useSafeAreaForEdge(.leading)))
            constraints.append(child.trailingToSuperview(offset: insets.right, relation: .equalOrLess, usingSafeArea: useSafeAreaForEdge(.trailing)))
            constraints.append(child.centerXToSuperview())
        default:
            constraints.append(child.leadingToSuperview(offset: insets.left, usingSafeArea: useSafeAreaForEdge(.leading)))
            constraints.append(child.trailingToSuperview(offset: insets.right, usingSafeArea: useSafeAreaForEdge(.trailing)))
        }
        
        return constraints
    }
}
#endif
