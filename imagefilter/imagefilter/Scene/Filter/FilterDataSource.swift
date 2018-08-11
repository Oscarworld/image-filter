//
//  FilterDataSource.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterDataSourceProtocol {
    var mainImage: UIImage? { get set }
    var photos: [PhotoRecord] { get set }
    var pendingOperations: PendingOperations { get set }
    var downloader: Downloader! { get set }
    var didSetImage: DelegatedCall<UIImage?> { get set }
}

class FilterDataSource: FilterDataSourceProtocol {
    public var mainImage: UIImage? {
        didSet {
            didSetImage.callback?(mainImage)
        }
    }

    public var photos = [PhotoRecord]()
    public var pendingOperations = PendingOperations()
    
    public var downloader: Downloader!
    public var didSetImage = DelegatedCall<UIImage?>()
}
