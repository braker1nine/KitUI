//
//  AsyncStreams.swift
//  KitUI
//
//  Created by Chris Brakebill on 9/23/22.
//

import Foundation
import ReactiveSwift

extension AsyncStream: SignalProducerConvertible {
    public var producer: SignalProducer<Element, Never> {
        .init { observer, _ in
            Task {
                for await value in self {
                    observer.send(value: value)
                }
                observer.sendCompleted()
            }
        }
    }
}

extension AsyncThrowingStream: SignalProducerConvertible {
    public var producer: SignalProducer<Element, Error> {
        .init { observer, _ in
            Task {
                do {
                    for try await value in self {
                        observer.send(value: value)
                    }
                } catch {
                    observer.send(error: error)
                }
                observer.sendCompleted()
            }
        }
    }
}
