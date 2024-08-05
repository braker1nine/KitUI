//
//  UICollectionView.swift
//  KitUI
//
//  Created by Chris Brakebill on 2/21/24.
//

#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

public enum CollectionViewError: Error {
    case failedToCastCell(UICollectionViewCell, ReuseableCollectionCell.Type)
}

public typealias ReuseableCollectionCell = UICollectionViewCell & Reuseable
public typealias ReuseableSupplementaryCell = UICollectionReusableView & Reuseable

extension UICollectionView {
    
    /// Sets the datasource of the collection view
    /// - parameter datasource: the `UICollectionViewDataSource` to set as the datasource
    /// - returns: the `UICollectionView` it's called on
    @discardableResult
    public func dataSource(_ source: UICollectionViewDataSource) -> Self {
        self.dataSource = source
        return self
    }
    
    /// Sets the delegate of the collection view.
    /// - parameter delegate: The delegate to set.
    /// - returns: The collection view itself.
    @discardableResult
    public func delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    /// Registers all the `ReuseableCollectionCell` types in the given array.
    /// - parameter cells: An array of `ReuseableCollectionCell` types to register.
    /// - returns: The `UICollectionView` it's called on.
    @discardableResult
    public func register(_ types: [ReuseableCollectionCell.Type]) -> Self {
        types.forEach { type in
            self.register(type, forCellWithReuseIdentifier: type.reuseIdentifier)
        }
        return self
    }
    
    /// Dequeue a cell that conforms to `ReuseableCollectionCell` for the given index path.
    ///
    /// - parameter indexPath: The index path of the cell to dequeue.
    /// - Returns: A cell that conforms to `ReuseableCollectionCell`.
    /// 
    /// Throws an error if the cell can't be cast to the expected type
    public func dequeue<T: ReuseableCollectionCell>(for indexPath: IndexPath) throws -> T {
        let cell = self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath)
        if let cell = cell as? T {
            return cell
        } else {
            throw CollectionViewError.failedToCastCell(cell, T.self)
        }
    }
    
    /// Register a `Reuseable` type as a header
    /// - parameter header: The type to register with the collection view
    /// - returns: The `UICollectionView` it was called on
    @discardableResult
    public func registerHeader(_ header: ReuseableSupplementaryCell.Type) -> Self {
        self.register(header, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: header.reuseIdentifier)
        return self
    }
    
    /// Dequeue a header with a specific type
    /// - parameter indexPath: The `IndexPath` to dequeue a header for
    /// - returns: An optional view with the inferred type
    public func dequeueHeader<T: ReuseableSupplementaryCell>(for indexPath: IndexPath) -> T? {
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier, for: indexPath)
        return cell as? T
    }
    
    /// Register a `Reuseable` type as a footer
    /// - parameter header: The type to register with the collection view
    /// - returns: The `UICollectionView` it was called on
    @discardableResult
    public func registerFooter(_ footer: ReuseableSupplementaryCell.Type) -> Self {
        self.register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footer.reuseIdentifier)
        return self
    }
    
    /// Dequeue a footer with a specific type
    /// - parameter indexPath: The `IndexPath` to dequeue a footer for
    /// - returns: An optional view with the inferred type
    public func dequeueFooter<T: ReuseableSupplementaryCell>(for indexPath: IndexPath) -> T? {
        let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier, for: indexPath)
        return cell as? T
    }
}

#endif
