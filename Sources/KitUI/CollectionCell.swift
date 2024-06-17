//
//  CollectionCell.swift
//
#if !os(macOS)

import Foundation
import UIKit
import TinyConstraints

/// A wrapper for creating a `UICollectionViewCell` with any generic view as it's content view
///
open class CollectionCell<Content: UIView>: UICollectionViewCell, Reuseable {
    public static var reuseIdentifier: String { String(describing: Content.self) }
    
    /// Intializes the content view. Subclasses can override this to use a custom initializer
    open func viewInitializer() -> Content {
        Content(frame: .zero)
    }
    
    public lazy var content: Content = self.viewInitializer()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setup()
    }    
    
    private func setup() {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.contentView.addSubview(self.content)
        self.content.edgesToSuperview()
        self.accessibilityElements = [self.content]
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionCell where Content: Reuseable {
    public static var reuseIdentifier: String { Content.reuseIdentifier }
}
#endif
