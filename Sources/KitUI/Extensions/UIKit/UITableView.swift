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
    
    public func dragInteractionEnabled<T: SignalProducerConvertible>(_ enabled: T) -> Self where T.Value == Bool {
        self.reactive.dragInteractionEnabled <~ enabled.producer.eraseError()
        return self
    }
    
    @discardableResult
    public func dataSource(_ source: UITableViewDataSource) -> Self {
        self.dataSource = source
        return self
    }

    @discardableResult
    public func delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    @discardableResult
    public func register(_ cells: [ReuseableTableCell.Type]) -> Self {
        cells.forEach { type in
            self.register(type, forCellReuseIdentifier: type.reuseIdentifier)
        }
        return self
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
