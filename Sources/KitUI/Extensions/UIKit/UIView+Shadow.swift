//
//  UIView+Shadow.swift
//  
#if os(iOS)

import Foundation
import UIKit
import ReactiveSwift

extension UIView {
    
    public func shadow(
        cornerRadius: Int = 0,
        hideShadow: Property<Bool> = .constant(false)
    ) -> UIView {
        let shadow = UIView()
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = .init(width: 0, height: 1)
        shadow.layer.shadowRadius = 5
        shadow.layer.shadowOpacity = 0.3
        shadow.layer.cornerRadius = .init(cornerRadius)
        
        shadow.addSubview(self)
        self.cornerRadius(cornerRadius)
        self.edgesToSuperview()
        return shadow
    }
}
#endif