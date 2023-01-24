//
//  UITableView.swift
//

#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

public typealias ReuseableTableCell = UITableViewCell & Reuseable

extension UITableView {
    
    /// Reactively updates the dragInteractionEnabled state of the table view.
    /// - parameter dragInteractionEnabled: A `SignalProducerConvertible` which will update the dragInteractionEnabled state of the table view.
    /// - returns: The `UITableView` it's called on.
    public func dragInteractionEnabled(_ enabled: any SignalProducerConvertible<Bool, Never>) -> Self {
        self.reactive.dragInteractionEnabled <~ enabled.producer
        return self
    }
    
    /// Sets the datasource of the table view
    /// - parameter datasource: the `UITableViewDataSource` to set as the datasource
    /// - returns: the `UITableView` it's called on
    @discardableResult
    public func dataSource(_ source: UITableViewDataSource) -> Self {
        self.dataSource = source
        return self
    }

    /// Sets the delegate of the table view.
    /// - parameter delegate: The delegate to set.
    /// - returns: The table view itself.
    @discardableResult
    public func delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    /// Registers all the `ReuseableTableCell` types in the given array.
    /// - parameter cells: An array of `ReuseableTableCell` types to register.
    /// - returns: The `UITableView` it's called on.
    @discardableResult
    public func register(_ cells: [ReuseableTableCell.Type]) -> Self {
        cells.forEach { type in
            self.register(type, forCellReuseIdentifier: type.reuseIdentifier)
        }
        return self
    }

    /// Dequeue a cell that conforms to `ReuseableTableCell` for the given index path.
    /// WARNING: This method will crash if the cell is not registered.
    ///
    /// - parameter indexPath: The index path of the cell to dequeue.
    /// - Returns: A cell that conforms to `ReuseableTableCell`.
    public func dequeue<T: ReuseableTableCell>(for indexPath: IndexPath) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
        return cell
    }
}

extension Reactive where Base: UITableView {
    
    /// A binding target to set the separator color of UITableView
    ///
    public var separatorColor: BindingTarget<UIColor?> {
        makeBindingTarget { (tableView, color) in
            tableView.separatorColor = color
        }
    }
    
    /// Binding target for tableview's separatorInset
    public var separatorInset: BindingTarget<UIEdgeInsets> {
        makeBindingTarget { (tableView, insets) in
            tableView.separatorInset = insets
        }
    }
    
    public var dragInteractionEnabled: BindingTarget<Bool> {
        makeBindingTarget { (tableView, enabled) in
            tableView.dragInteractionEnabled = enabled
        }
    }
}
#endif
