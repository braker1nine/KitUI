//
//  CALayer.swift
//

#if !os(macOS)

import Foundation
import ReactiveSwift
import ReactiveCocoa
import UIKit

///
/// Struct to represent the border on a `CALayer`.
///
public struct BorderStyle {
    public let color: UIColor?
    public let width: Double
    
    public init(color: UIColor?, width: Double) {
        self.color = color
        self.width = width
    }
}

extension CALayer {
    
    /// The current `BorderStyle` for a layer. This struct contains both the color
    /// and with of the border
    ///
    public var border: BorderStyle {
        set {
            self.borderWidth = newValue.width
            self.borderColor = newValue.color?.cgColor
        }
        
        get {
            BorderStyle(
                color: {
                    if let borderColor = self.borderColor {
                        return UIColor(cgColor: borderColor)
                    } else {
                        return nil
                    }
                }(),
                width: self.borderWidth
            )
        }
    }
}

extension Reactive where Base: CALayer {
    
    /// A binding target for setting a layer's border style
    ///
    /// **Note:** Lean towards updating color rather than size to prevent accidental layout changes. So switch from
    /// clear to red instead of from a width of 0 to 2
    ///
    /// Example:
    /// ```
    /// self.view.layer.reactive.border <~ self.viewModel.isActive.map { isActive in
    ///     BorderStyle(
    ///         color: isActive ? .red : .clear,
    ///         width: 2.0
    ///     )
    /// }
    /// ```
    ///
    public var border: BindingTarget<BorderStyle> {
        makeBindingTarget { (layer, borderStyle) in
            layer.border = borderStyle
        }
    }
    
    /// BindingTarget for a layer's corner radius
    public var cornerRadius: BindingTarget<CGFloat> {
        makeBindingTarget { $0.cornerRadius = $1 }
    }
    
    /// BindingTarget for a layer's masked corners
    public var maskedCorners: BindingTarget<CACornerMask> {
        makeBindingTarget { $0.maskedCorners = $1 }
    }
}
#endif
