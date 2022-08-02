//
//  UIToolbar.swift
//

#if os(iOS)

import Foundation
import ReactiveSwift
import UIKit

extension Reactive where Base: UIToolbar {
    public var items: BindingTarget<[UIBarButtonItem]> {
        makeBindingTarget { toolbar, items in
            toolbar.items = items
        }
    }
    
    public var barStyle: BindingTarget<UIBarStyle> {
        makeBindingTarget { (bar, style) in
            bar.barStyle = style
        }
    }
}
#endif
