//
//  Downloader.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

class Downloader {
    var didDownload = DelegatedCall<UIImage>()
    
    func downloadImage(url: NSURL) {
        guard let data = try? Data(contentsOf: url as URL), let image = UIImage(data: data) else {
            return
        }
        
        self.didDownload.callback?(image)
    }
}
