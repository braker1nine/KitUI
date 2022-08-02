//
//  LayoutEdge.swift
//  

import Foundation
import TinyConstraints

public extension Array where Element == LayoutEdge {
    
    /// All layout edges
    static var all: [LayoutEdge] = [.top, .trailing, .bottom, .leading]
    
    /// Horizontal layout edges (`trailing` and `leading`)
    static var horizontal: [LayoutEdge] = [.trailing, .leading]
    
    /// Vertical layout edges (`top` and `bottom`)
    static var vertical: [LayoutEdge] = [.top, .bottom]
    
    /// Returns all layout edges but the specified edge
    static func all(but: LayoutEdge) -> [LayoutEdge] {
        return [LayoutEdge].all.filter { $0 != but }
    }
}
