//
//  UIViewBuilder.swift
//
#if os(iOS)

import Foundation
import UIKit

/// A ResultBuilder for generating a list of `UIView`s
@resultBuilder
public struct UIViewBuilder {
    public static func buildBlock(_ views: UIView?...) -> [UIView] { views.compactMap { $0 } }
    
    public static func buildBlock(_ components: [UIView]) -> [UIView] {
        components
    }
}
#endif