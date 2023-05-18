import Foundation
import ReactiveSwift
import UIKit

public func VisualEffect(
    effect: UIVisualEffect = UIBlurEffect(style: .regular),
    disable: some SignalProducerConvertible<Bool, Never> = false,
    content: () -> UIView
) -> UIView {
    let wrap = UIVisualEffectView(effect: effect)
    disable.producer.take(duringLifetimeOf: wrap).startWithValues { [weak wrap] disabled in
        guard let wrap = wrap else { return }
        if disabled {
            wrap.effect = nil
        } else {
            wrap.effect = effect
        }
    }
    let contentView = content()
    wrap.contentView.addSubview(contentView)
    contentView.edgesToSuperview()
    return wrap
}

public func Vibrancy(
    blurEffect: UIBlurEffect,
    style: UIVibrancyEffectStyle,
    disable: some SignalProducerConvertible<Bool, Never> = false,
    content: () -> UIView
) -> UIView {
    
    let effect = UIVibrancyEffect(blurEffect: blurEffect, style: style)
    let wrap = UIVisualEffectView(effect: effect)
    disable.producer.take(duringLifetimeOf: wrap).startWithValues { [weak wrap] disabled in
        wrap?.effect = disabled ? nil : effect
    }
    let view = content()
    wrap.contentView.addSubview(view)
    view.edgesToSuperview()
    return wrap
}

extension UIView {
    public func vibrancy(
        blurEffect: UIBlurEffect.Style,
        style: UIVibrancyEffectStyle,
        disable: some SignalProducerConvertible<Bool, Never> = false
    ) -> UIView {
        Vibrancy(blurEffect: .init(style: blurEffect), style: style) {
            self
        }
    }
    
    public func visualEffect(_ effect: UIVisualEffect, disable: some SignalProducerConvertible<Bool, Never> = false) -> UIView {
        VisualEffect(effect: effect, disable: disable, content: { self })
    }
}
