//
//  TableCell.swift
//
#if !os(macOS)

import Foundation
import UIKit
import ReactiveSwift
import TinyConstraints

/// A wrapper for creating a `UITableViewCell` with any generic view as it's content view
///
open class TableCell<Content: UIView>: UITableViewCell, Reuseable {
    public static var reuseIdentifier: String { String(describing: Content.self) }
    
    /// Intializes the content view. Subclasses can override this to use a custom initializer
    open func viewInitializer() -> Content {
        Content(frame: .zero)
    }
    
    public lazy var content: Content = self.viewInitializer()
    
    /// Insets for setting content padding from the edge of the cell
    open var insets: UIEdgeInsets { .zero }
    
    public convenience init(style: UITableViewCell.CellStyle = .default) {
        self.init(style: style, reuseIdentifier: Self.reuseIdentifier)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear

        self.contentView.addSubview(self.content)
        self.content.edgesToSuperview(insets: self.insets)
        
        self.accessibilityElements = [self.content]
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableCell where Content: Reuseable {
    public static var reuseIdentifier: String { Content.reuseIdentifier }
}
#endif
