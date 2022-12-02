//
//  UIFont.swift
//  
//

import Foundation
import UIKit

extension UIFont {
    /// Creates a scaled version of the specified font against the given text style
    /// - parameter style: A `TextStyle` to scale against. If none is given then `UIFontMetrics.default`
    ///   will be used
    /// - returns: A scaled `UIFont` object. Note: Scaling an already scaled font may throw an exception
    public func scaled(withStyle style: UIFont.TextStyle? = nil) -> UIFont {
        if let style {
            return UIFontMetrics(forTextStyle: style).scaledFont(for: self)
        } else {
            return UIFontMetrics.default.scaledFont(for: self)
        }
    }
}
