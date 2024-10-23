//
//  TraitCollectionReader.swift
//  KitUI
//
//  Created by Chris Brakebill on 10/23/24.
//

#if os(iOS)
import ReactiveSwift
import UIKit

private class TraitCollectionView: UIView {
    
    private var traitCollectionProperty: MutableProperty<UITraitCollection>!
    init(_ generateContent: (Property<UITraitCollection>) -> UIView) {
        
        super.init(frame: .zero)
        self.traitCollectionProperty = .init(self.traitCollection)
        let content = generateContent(Property(self.traitCollectionProperty))
        self.addSubview(content)
        content.edgesToSuperview()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.traitCollectionProperty.value = self.traitCollection
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// A function that creates a `UIView` which allows its child views to update their view
/// based on the trait collection of this view.
/// 
/// - Parameter generateContent: A closure that takes a `Property<UITraitCollection>`
///   and returns a `UIView`. This closure is used to generate the content of the view
///   based on the trait collection.
/// - Returns: A `UIView` that updates its child views based on its trait collection.
public func TraitCollectionReader(_ generateContent: (Property<UITraitCollection>) -> UIView) -> UIView {
    TraitCollectionView(generateContent)
}

#endif
