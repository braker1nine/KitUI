//
//  ReceiveTests.swift
//  
//
//  Created by Chris Brakebill on 10/3/22.
//

import XCTest
@testable import KitUI
import ReactiveSwift

class TestObject: NSObject {
    var value: Int = 0
}

final class ReceiveTests: XCTestCase {

    func testReceive() throws {
        
        let (signal, observer) = Signal<Int, Never>.pipe()
        var object = TestObject().receive(\TestObject.value, signal.producer)
        
        observer.send(value: 2)
        XCTAssertEqual(object.value, 2)
        
        observer.send(value: 3)
        XCTAssertEqual(object.value, 3)
        
        observer.send(value: 100)
        XCTAssertEqual(object.value, 100)
        
        observer.sendCompleted()
    }
}
