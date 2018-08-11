//
//  PhotoRecord.swift
//  imagefilter
//
//  Created by Oscar on 28/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

enum PhotoRecordState {
    case new
    case filtered
    case failed
}

enum PhotoFilterType {
    case without
    case rotate
    case mirror
    case bw
    case invert
    case reflex
}

class PhotoRecord {
    var id: Int
    var state = PhotoRecordState.new
    var filterType: PhotoFilterType
    var image: UIImage
    
    init(id: Int, image: UIImage, filterType: PhotoFilterType = .without) {
        self.id = id
        self.image = image
        self.filterType = filterType
    }
}

