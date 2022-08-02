//
//  CAShapeLayer.swift
//

#if !os(macOS)

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

extension Reactive where Base: CAShapeLayer {
    
    /// BindingTarget for the shape layer's `fillColor`
    public var fillColor: BindingTarget<CGColor?> {
        
        makeBindingTarget { (layer, color) in
            layer.fillColor = color
        }
    }
    
    /// BindingTarget for the shape layer's `strokeColor`
    public var strokeColor: BindingTarget<CGColor?> {
        makeBindingTarget { layer, color in
            layer.strokeColor = color
        }
    }
    
    /// BindingTarget for the shape layer's `opacity`
    public var opacity: BindingTarget<Float> {
        makeBindingTarget { (layer, opacity) in
            layer.opacity = opacity
        }
    }
}
#endif
