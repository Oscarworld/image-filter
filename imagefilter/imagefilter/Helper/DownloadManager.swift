//
//  DownloadManager.swift
//  imagefilter
//
//  Created by Oscar on 25/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import Foundation

protocol DownloadManagerDelegate: class {
    func updateProgress(uploaded: Float)
    func downloadCompleted(location: URL)
    func taskCompleted(error: Error?)
}

class DonwloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    weak var delegate: DownloadManagerDelegate!
    
    var session: URLSession {
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier ??  "main_background_session")")
        return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let percents = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        delegate.updateProgress(uploaded: percents)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        delegate.downloadCompleted(location: location)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        delegate.taskCompleted(error: error)
    }
}
