//
//  Button.swift
//
#if os(iOS)
import Foundation
import UIKit
import ReactiveSwift

/// Creates a button
/// - parameter animationDuration: The duration for animation changes
/// - parameter content: A closure which returns a view to be used as content for the button
///   This closure receives a `Property<Bool>` which indicates whether the button is currently pressed
/// - parameter onPress: An action to run when the button is pressed
/// - returns: A `UIButton` with the specified content
public func Button(
    animationDuration: TimeInterval = 0.2, 
    content: (Property<Bool>) -> UIView, 
    onPress: (() -> Void)? = nil
) -> UIButton {
    let button = UIButton.wrap(animationDuration: animationDuration, content)
    if let onPress = onPress {
        button.onPress(onPress)
    }
    return button
}
#endif