//
//  Observed.swift
//  testPJ
//
//  Created by yilin on 2024/6/26.
//

import Foundation

@propertyWrapper
public class Observed<T> {
    private var _value: T {
        didSet {
            execute()
        }
    }
    
    private var _closure: ((T) -> Void)? {
        didSet {
            execute()
        }
    }
    
    private var _queue: DispatchQueue? = nil
    
    public var wrappedValue: T {
        get {
            _value
        }
        set {
            _value = newValue
        }
    }

    public var projectedValue: Observed<T> {
        self
    }
    
    public init(wrappedValue: T, queue: DispatchQueue? = nil) {
        self._value = wrappedValue
        self._queue = queue
    }

    public func observe(using block: @escaping (T) -> Void) {
        _closure = block
    }

    public func callAsFunction(using block: @escaping (T) -> Void) {
        observe(using: block)
    }

    public func cancel() {
        _closure = nil
    }
    
    private func execute() {
        guard let closure = _closure else {
            return
        }
        
        let value = _value
        
        if let queue = _queue, (queue != DispatchQueue.main || Thread.isMainThread == false) {
            queue.async {
                closure(value)
            }
        } else {
            closure(value)
        }
    }
}
