//
//  StackView.swift
//

#if os(iOS)
import Foundation
import UIKit

/// Generates a `UIStackView` with a `.vertical` axis
/// - parameter builder: A closure that returns an array of views to add to the stack
public func Vertical(@UIViewBuilder builder: () -> [UIView]) -> UIStackView {
    .init(axis: .vertical, builder: builder)
}

/// Generates a `UIStackView` with a `.horizontal` axis
/// - parameter builder: A closure that returns an array of views to add to the stack
public func Horizontal(@UIViewBuilder builder: () -> [UIView]) -> UIStackView {
    .init(axis: .horizontal, builder: builder)
}
#endif
