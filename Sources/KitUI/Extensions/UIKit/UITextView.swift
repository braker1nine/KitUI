//
//  UITextView.swift
//

#if !os(macOS)

import Foundation
import UIKit
import ReactiveSwift

extension Reactive where Base: UITextView {
    public var textContainerInset: BindingTarget<UIEdgeInsets> {
        makeBindingTarget { textView, insets in
            textView.textContainerInset = insets
        }
    }
}
#endif
