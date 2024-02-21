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

enum CollectionViewError: Error {
    case failedToCastCell(UICollectionViewCell, ReuseableCollectionCell.Type)
}

public typealias ReuseableCollectionCell = UICollectionViewCell & Reuseable

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
}

#endif
