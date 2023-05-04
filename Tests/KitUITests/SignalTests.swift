import ReactiveSwift
import XCTest

final class SignalTests: XCTestCase {

    func testSignalMapIf() throws {
        let signal = Signal<Bool, Never>.pipe()
        let inputs = [true, false, false, true, false]
        
        let expectation = self.expectation(description: "Wait for values")
        signal.output.mapIf(on: 10, off: 20).collect().observeResult { result in
            switch result {
            case .failure:
                XCTFail()
            case .success(let values):
                XCTAssertEqual(inputs.map { $0 ? 10 : 20 }, values)
                expectation.fulfill()
            }
        }
        
        for value in inputs {
            signal.input.send(value: value)
        }
        signal.input.sendCompleted()

        self.waitForExpectations(timeout: 5)
    }
    
    func testProducerMapIf() throws {
        let producer = SignalProducer<Bool, Never>.init(values: true, false, true, false)
        let expectation = self.expectation(description: "Wait for values")

        producer.mapIf(on: 10, off: 20)
            .collect()
            .startWithValues { values in
                XCTAssertEqual([10, 20, 10, 20], values)
                expectation.fulfill()
            }
        
        self.waitForExpectations(timeout: 5)
    }

}
