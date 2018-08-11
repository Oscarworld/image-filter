//
//  FilterInteractor.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterInteractorProtocol {
    func retrieveImage() -> UIImage?
    func saveImage(_ image: UIImage?)
    func downloadImage(from url: String?)
    
    func setMainImage(at indexPath: IndexPath) -> Bool
    func saveImageToLibrary(at indexPath: IndexPath) -> Bool
    func deleteImage(at indexPath: IndexPath)
    
    func rowCount() -> Int
    func getPhoto(at indexPath: IndexPath) -> PhotoRecord
    
    func applyFilter(for photo: PhotoRecord, at indexPath: IndexPath)
    func createImage(_ image: UIImage, with filter: PhotoFilterType)
}

class FilterInteractor: FilterInteractorProtocol {
    private weak var presenter: FilterPresenterProtocol!
    private var dataSource: FilterDataSourceProtocol!
    
    required init(presenter: FilterPresenterProtocol, dataSource: FilterDataSourceProtocol) {
        self.presenter = presenter
        self.dataSource = dataSource
        self.dataSource.downloader = Downloader()

        configureObservers()
    }
    
    private func configureObservers() {
        dataSource.downloader.didDownload.delegate(to: self) { (self, image) in
            self.dataSource.mainImage = image
        }
        
        dataSource.downloader.updateProgress.delegate(to: self) { (self, value) in
            self.presenter.updateHeaderProgressBar(to: value)
        }
        
        dataSource.didSetImage.delegate(to: self) { (self, image) in
            self.presenter.updateHeaderImageView()
        }
    }
}

// MARK: Implementation of FilterInteractor
extension FilterInteractor {
    public func saveImage(_ image: UIImage?) {
        dataSource.mainImage = image
    }
    
    public func retrieveImage() -> UIImage? {
        return dataSource.mainImage
    }
    
    public func downloadImage(from url: String?) {
        if let url = url, let imageURL = NSURL(string: url) {
            self.dataSource.downloader.downloadImage(url: imageURL)
        }
    }
    
    public func setMainImage(at indexPath: IndexPath) -> Bool {
//        dataSource.mainImage = dataSource.outputImages[indexPath.row]
//        return true
//        if let image = dataSource.outputImages[indexPath.row].image {
//            dataSource.mainImage = image
//            return true
//        } else {
//            return false
//        }
        return false
    }
    
    public func saveImageToLibrary(at indexPath: IndexPath) -> Bool {
//        UIImageWriteToSavedPhotosAlbum(dataSource.outputImages[indexPath.row], self, nil, nil)
//        return true
//        if let image = dataSource.outputImages[indexPath.row].image {
//            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
//            return true
//        } else {
//            return false
//        }
        return false
    }
    
    public func deleteImage(at indexPath: IndexPath) {
        let photoId = dataSource.photos[indexPath.row].id
        dataSource.pendingOperations.filtrationsInProgress[photoId]?.cancel()
        dataSource.pendingOperations.filtrationsInProgress.removeValue(forKey: photoId)
        dataSource.photos.remove(at: indexPath.row)
    }
    
    public func getPhoto(at indexPath: IndexPath) -> PhotoRecord {
        return dataSource.photos[indexPath.row]
    }
    
    public func rowCount() -> Int {
        return dataSource.photos.count
    }
}

// MARK: Implementation of Filtering image
extension FilterInteractor {
    func createImage(_ image: UIImage, with filter: PhotoFilterType) {
        let lastId = dataSource.photos.sorted(by: {$0.id > $1.id}).first?.id ?? 0
        let newPhoto = PhotoRecord(id: lastId + 1, image: image, filterType: filter)
        dataSource.photos.insert(newPhoto, at: 0)
    }
    
    func applyFilter(for photo: PhotoRecord, at indexPath: IndexPath) {
        guard dataSource.pendingOperations.filtrationsInProgress[photo.id] == nil else {
            return
        }
        
        let filterer = ImageFiltration(photoRecord: photo)
        filterer.completionBlock = {
            if filterer.isCancelled {
                return
            }
            DispatchQueue.main.async {
                self.dataSource.pendingOperations.filtrationsInProgress.removeValue(forKey: photo.id)
                self.presenter.reloadTableView()
                //self.presenter.reloadRow(at: [indexPath])
            }
        }
        dataSource.pendingOperations.filtrationsInProgress[photo.id] = filterer
        dataSource.pendingOperations.filtrationQueue.addOperation(filterer)
    }
}
