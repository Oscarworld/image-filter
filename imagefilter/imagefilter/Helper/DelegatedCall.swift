//
//  DelegatedCall.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import Foundation

struct DelegatedCall<T> {
    private(set) var callback: ((T) -> Void)?
    
    mutating func delegate<Object: AnyObject>(to object: Object, with callback: @escaping(Object, T) -> Void) {
        self.callback = { [weak object] input in
            guard let object = object else { return }
            callback(object, input)
        }
    }
}
