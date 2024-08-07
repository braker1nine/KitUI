#if canImport(UIKit)
import Foundation
import ReactiveCocoa
import ReactiveSwift
import UIKit

extension Reactive where Base: UIApplication {
    
    /// A `SignalProducer` with values for the `UIApplication.preferredContentSizeCatetory`.
    /// It sends an initial value with the current 
    public var preferredContentSizeCategory: SignalProducer<UIContentSizeCategory, Never> {
        .merge(
            SignalProducer<UIContentSizeCategory, Never>(value: self.base.preferredContentSizeCategory),
            NotificationCenter.default.reactive.notifications(forName: UIContentSizeCategory.didChangeNotification).map { _ in
                self.base.preferredContentSizeCategory
            }
        )
    }
}
#endif
