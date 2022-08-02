
//
//  Kit.swift
//
// Based by the `Reactive` type that `ReactiveCocoa` provides

import Foundation

public protocol KitExtensionsProvider {}

extension KitExtensionsProvider {
    /// A proxy which hosts reactive extensions for `self`.
    public var kit: Kit<Self> {
        return Kit(self)
    }
}

/// A proxy which hosts reactive extensions of `Base`.
public struct Kit<Base> {
    /// The `Base` instance the extensions would be invoked with.
    public let base: Base
    
    /// Construct a proxy
    ///
    /// - parameters:
    ///   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

extension NSObject: KitExtensionsProvider {}

