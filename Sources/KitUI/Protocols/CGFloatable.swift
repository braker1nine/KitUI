//
//  CGFloatable.swift
//

import Foundation
import CoreGraphics
import ReactiveSwift

/// A protocol indicating a value that can be converted to a CGFloat
///
/// This is mostly used to provide a flexible type that can be passed for numeric values
/// into a variety of KitUI methods. So users can easily pass doubles or Ints for UI
/// related values that need to be `CGFloat`
public protocol CGFloatable {
    var cgFloat: CGFloat { get }
}

extension CGFloat: CGFloatable {
    public var cgFloat: CGFloat { self }
}

extension Int: CGFloatable {
    public var cgFloat: CGFloat { .init(self) }
}

extension Double: CGFloatable {
    public var cgFloat: CGFloat { .init(self) }
}
