//
//  OutputImage.swift
//  imagefilter
//
//  Created by Oscar on 26/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

class OutputImage {
    var image: UIImage? = nil {
        didSet {
            delegateImage.callback?(image)
        }
    }
    var progress: Float = 0 {
        didSet {
            delegateProgress.callback?(progress)
        }
    }
    
    var delegateImage = DelegatedCall<UIImage?>()
    var delegateProgress = DelegatedCall<Float>()
}
