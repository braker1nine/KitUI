//
//  Stringish.swift
//

import Foundation

/// A simple protocol that allows sending both strings and optional strings
public protocol Stringish {
    var stringValue: String? { get }
}

extension String: Stringish {
    public var stringValue: String? { self }
}

extension Optional: Stringish where Wrapped == String {
    public var stringValue: String? { self }
}
