//
//  TableCell.swift
//
#if !os(macOS)

import Foundation
import UIKit
import TinyConstraints

/// A wrapper for creating a `UITableViewCell` with any generic view as it's content view
///
open class TableCell<T: UIView>: UITableViewCell/*, Reuseable*/ {
    public static var reuseIdentifier: String { String(describing: T.self) }
    
    /// Intializes the content view. Subclasses can override this to use a custom initializer
    open func viewInitializer() -> T {
        T.init(frame: .zero)
    }
    
    /// Insets for setting content padding from the edge of the cell
    open var insets: UIEdgeInsets { .init(top: 16, left: 24, bottom: 16, right: 24) }
    
    public lazy var content: T = self.viewInitializer()
    
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
        self.content.horizontalToSuperview(insets: self.insets, usingSafeArea: true)
        self.content.verticalToSuperview(insets: self.insets, usingSafeArea: false)
        
        self.accessibilityElements = [self.content]
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif
