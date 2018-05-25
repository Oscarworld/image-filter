//
//  FilterInteractor.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterInteractorProtocol {
    var dataSource: FilterDataSourceProtocol! { get set }
    
    func retrieveImages() -> UIImage?
    func saveImage(_ image: UIImage?)
    func downloadImage(from url: String?)
}

class FilterInteractor: FilterInteractorProtocol {
    weak var presenter: FilterPresenterProtocol!
    var dataSource: FilterDataSourceProtocol!
    
    required init(presenter: FilterPresenterProtocol, dataSource: FilterDataSourceProtocol) {
        self.presenter = presenter
        self.dataSource = dataSource
        self.dataSource.downloader = Downloader()

        configureObservers()
    }
    
    func configureObservers() {
        self.dataSource.downloader.didDownload.delegate(to: self) { (self, image) in
            self.dataSource.mainImage = image
        }
        
        self.dataSource.downloader.updateProgress.delegate(to: self) { (self, value) in
            self.presenter.updateProgressBar(to: value)
        }
        
        self.dataSource.didSetImage.delegate(to: self) { (self, image) in
            self.presenter.updateImageView()
        }
    }
}

// MARK: Implementation of FilterInteractor
extension FilterInteractor {
    func saveImage(_ image: UIImage?) {
        dataSource.mainImage = image
    }
    
    func retrieveImages() -> UIImage? {
        return dataSource.mainImage
    }
    
    func downloadImage(from url: String?) {
        if let url = url, let imageURL = NSURL(string: url) {
            self.dataSource.downloader.downloadImage(url: imageURL)
        }
    }
}
