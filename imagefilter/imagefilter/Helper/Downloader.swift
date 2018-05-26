//
//  Downloader.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

class Downloader {
    var downloadManager = DonwloadManager()
    var didDownload = DelegatedCall<UIImage>()
    var updateProgress = DelegatedCall<Float>()
    
    init() {
        downloadManager.delegate = self
    }
    
    func downloadImage(url: NSURL) {
        let task = downloadManager.session.downloadTask(with: url as URL)
        task.resume()
    }
}

extension Downloader: DownloadManagerDelegate {
    func updateProgress(uploaded: Float) {
        self.updateProgress.callback?(uploaded)
    }
    
    func downloadCompleted(location: URL) {
        guard let data = try? Data(contentsOf: location), let image = UIImage(data: data) else {
            return
        }
        
        self.didDownload.callback?(image)
    }
    
    func taskCompleted(error: Error?) {
        //
    }
}
