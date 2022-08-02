//
//  UIViewBuilder.swift
//

import Foundation
import UIKit

@resultBuilder
public struct UIViewBuilder {
    public static func buildBlock(_ views: UIView?...) -> [UIView] { views.compactMap { $0 } }
    
    public static func buildBlock(_ components: [UIView]) -> [UIView] {
        components
    }
}
