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
    var downloader: Downloader! { get set }
    var didSetImage: DelegatedCall<UIImage?> { get set }
}

class FilterDataSource: FilterDataSourceProtocol {
    var mainImage: UIImage? {
        didSet {
            didSetImage.callback?(mainImage)
        }
    }
    var downloader: Downloader!
    var didSetImage = DelegatedCall<UIImage?>()
}
