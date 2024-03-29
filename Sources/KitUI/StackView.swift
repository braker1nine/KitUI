//
//  StackView.swift
//

#if os(iOS)
import Foundation
import UIKit

/// Generates a `UIStackView` with a `.vertical` axis
/// - parameter builder: A closure that returns an array of views to add to the stack
/// - returns: A `UIStackView` with a `.vertical` axis
public func Vertical(@UIViewBuilder builder: () -> [UIView]) -> UIStackView {
    .init(axis: .vertical, builder: builder)
}

/// Generates a `UIStackView` with a `.horizontal` axis
/// - parameter builder: A closure that returns an array of views to add to the stack
/// - returns: A `UIStackView` with a `.horizontal` axis
public func Horizontal(@UIViewBuilder builder: () -> [UIView]) -> UIStackView {
    .init(axis: .horizontal, builder: builder)
}

/// This creates a `UIStackView` that prefers to be horizontal, but switches
/// to being vertical at accessible font sizes
public func AccessibleHorizontal(
    @UIViewBuilder content: () -> [UIView]
) -> UIStackView {
    let axis = UIApplication.shared.reactive.preferredContentSizeCategory
        .map { category -> NSLayoutConstraint.Axis in
            category.isAccessibilityCategory ? .vertical : .horizontal
        }
    return UIStackView(axis: axis, builder: content)
}
#endif
