//
//  Button.swift
//
#if os(iOS)
import Foundation
import UIKit
import ReactiveSwift

public func Button(animationDuration: TimeInterval = 0.2, content: (Property<Bool>) -> UIView, onPress: (() -> Void)? = nil) -> UIButton {
    let button = UIButton.wrap(animationDuration: animationDuration, content)
    if let onPress = onPress {
        button.onPress(onPress)
    }
    return button
}
#endif