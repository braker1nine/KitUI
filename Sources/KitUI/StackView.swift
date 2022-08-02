//
//  StackView.swift
//

import Foundation
import UIKit

public func Vertical(@UIViewBuilder builder: () -> [UIView]) -> UIStackView {
    .init(axis: .vertical, builder: builder)
}

public func Horizontal(@UIViewBuilder builder: () -> [UIView]) -> UIStackView {
    .init(axis: .horizontal, builder: builder)
}
