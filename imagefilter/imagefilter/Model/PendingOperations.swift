//
//  PendingOperations.swift
//  imagefilter
//
//  Created by Oscar on 28/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import Foundation

class PendingOperations {
    lazy var filtrationsInProgress = [Int: Operation]()
    lazy var filtrationQueue: OperationQueue = {
       var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        //queue.maxConcurrentOperationCount = 1
        return queue
    }()
}
