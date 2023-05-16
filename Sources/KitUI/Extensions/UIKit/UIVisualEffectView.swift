import Foundation
import UIKit

public func VisualEffect(
    effect: UIVisualEffect = UIBlurEffect(style: .regular),
    content: () -> UIView
) -> UIView {
    let wrap = UIVisualEffectView(effect: effect)
    let contentView = content()
    wrap.contentView.addSubview(contentView)
    contentView.edgesToSuperview()
    return wrap
}

public func Vibrancy(
    blurEffect: UIBlurEffect,
    style: UIVibrancyEffectStyle,
    content: () -> UIView
) -> UIView {
    
    let effect = UIVibrancyEffect(blurEffect: blurEffect, style: style)
    let wrap = UIVisualEffectView(effect: effect)
    let view = content()
    wrap.contentView.addSubview(view)
    view.edgesToSuperview()
    return wrap
}

extension UIView {
    public func vibrancy(blurEffect: UIBlurEffect.Style, style: UIVibrancyEffectStyle) -> UIView {
        Vibrancy(blurEffect: .init(style: blurEffect), style: style) {
            self
        }
    }
    
    public func visualEffect(_ effect: UIVisualEffect) -> UIView {
        VisualEffect(effect: effect, content: { self })
    }
}
