//
//  CACornerMask.swift
//  

import Foundation
import UIKit

public extension CACornerMask {
    static var all: CACornerMask = [.topLeft, .topRight, .bottomLeft, .bottomRight]
    static var top: CACornerMask = [.topLeft, .topRight]
    static var bottom: CACornerMask = [.bottomLeft, .bottomRight]
    static var topLeft: CACornerMask = .layerMinXMinYCorner
    static var topRight: CACornerMask = .layerMaxXMinYCorner
    static var bottomLeft: CACornerMask = .layerMinXMaxYCorner
    static var bottomRight: CACornerMask = .layerMaxXMaxYCorner
}
