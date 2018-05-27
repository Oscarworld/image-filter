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
    func getOutputModel(at indexPath: IndexPath) -> OutputImage
    
    func rotateImage(_ image: UIImage)
    func invertColorImage(_ image: UIImage)
    func reflectImage(_ image: UIImage)
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
        if let image = dataSource.outputImages[indexPath.row].image {
            dataSource.mainImage = image
            return true
        } else {
            return false
        }
    }
    
    public func saveImageToLibrary(at indexPath: IndexPath) -> Bool {
//        UIImageWriteToSavedPhotosAlbum(dataSource.outputImages[indexPath.row], self, nil, nil)
//        return true
        if let image = dataSource.outputImages[indexPath.row].image {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
            return true
        } else {
            return false
        }
    }
    
    public func deleteImage(at indexPath: IndexPath) {
        dataSource.outputImages.remove(at: indexPath.row)
    }
    
    public func getOutputModel(at indexPath: IndexPath) -> OutputImage {
        return dataSource.outputImages[indexPath.row]
    }
    
    public func rowCount() -> Int {
        return dataSource.outputImages.count
    }
}

// MARK: Implementation of Filtering image
extension FilterInteractor {
    public func rotateImage(_ image: UIImage) {
//        dataSource.outputImages.insert(image, at: 0)
//        guard let ciImage = CIImage(image: image) else {
//            return
//        }
//        
//        let angel = 90 * Double.pi / 180
//        let newAngle = CGFloat(angel) * CGFloat(-1)
//        let transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(newAngle), 0, 0, 1)
//        let affineTransform = CATransform3DGetAffineTransform(transform)
//        
//        let filter = CIFilter(name: "CIAffineTransform")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        filter?.setDefaults()
//        
//        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: kCIInputTransformKey)
//        
//        let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])
//        
//        guard let filtered = filter?.outputImage, let cgImage = contex.createCGImage(filtered, from: filtered.extent) else {
//            return
//        }
//        
//        let newImage = UIImage(cgImage: cgImage)
//        dataSource.outputImages.insert(newImage, at: 0)
        
        let outputImage = OutputImage()
        dataSource.outputImages.insert(outputImage, at: 0)

        let queue = DispatchQueue(label: "rotate \(dataSource.outputImages.count)")

        queue.async { [weak self] in
            guard let ciImage = CIImage(image: image) else {
                return
            }

            let angel = 90 * Double.pi / 180
            let newAngle = CGFloat(angel) * CGFloat(-1)
            let transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(newAngle), 0, 0, 1)
            let affineTransform = CATransform3DGetAffineTransform(transform)

            let filter = CIFilter(name: "CIAffineTransform")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setDefaults()

            filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: kCIInputTransformKey)

            let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])

            guard let filtered = filter?.outputImage, let cgImage = contex.createCGImage(filtered, from: filtered.extent) else {
                return
            }

            let newImage = UIImage(cgImage: cgImage)

            let slowerQueue = DispatchQueue(label: "rotate slower \(self?.dataSource.outputImages.count ?? -1)")

            for _ in 0..<50 {
                slowerQueue.sync {
                    usleep(arc4random_uniform(200) * 1000)
                    outputImage.progress += 0.02
                }
            }

            outputImage.image = newImage
        }
    }
    
    public func invertColorImage(_ image: UIImage) {
        let outputImage = OutputImage()
        dataSource.outputImages.insert(outputImage, at: 0)

        let queue = DispatchQueue(label: "inverte \(dataSource.outputImages.count)")

        queue.async { [weak self] in
            guard let ciImage = CIImage(image: image) else {
                return
            }

            let filter = CIFilter(name: "CIColorControls")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setValue(0.0, forKey: kCIInputSaturationKey)

            let contex = CIContext(options: [kCIContextUseSoftwareRenderer:true])

            guard let filtered = filter?.outputImage, let cgImage = contex.createCGImage(filtered, from: filtered.extent) else {
                return
            }

            let newImage = UIImage(cgImage: cgImage)

            let slowerQueue = DispatchQueue(label: "inverte slower \(self?.dataSource.outputImages.count ?? -1)")

            for _ in 0..<50 {
                slowerQueue.sync {
                    usleep(arc4random_uniform(200) * 1000)
                    outputImage.progress += 0.02
                }
            }

            outputImage.image = newImage
        }
    }
    
    public func reflectImage(_ image: UIImage) {
        let outputImage = OutputImage()
        dataSource.outputImages.insert(outputImage, at: 0)

        let queue = DispatchQueue(label: "reflect \(dataSource.outputImages.count)")

        queue.async { [weak self] in
            guard let ciImage = CIImage(image: image) else {
                return
            }

            let transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(1 * Double.pi), 0, 1, 0)
            let affineTransform = CATransform3DGetAffineTransform(transform)

            let filter = CIFilter(name: "CIAffineTransform")
            filter?.setValue(ciImage, forKey: kCIInputImageKey)
            filter?.setDefaults()

            filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: kCIInputTransformKey)

            let contex = CIContext(options: [kCIContextUseSoftwareRenderer: true])

            guard let filtered = filter?.outputImage, let cgImage = contex.createCGImage(filtered, from: filtered.extent) else {
                return
            }

            let newImage = UIImage(cgImage: cgImage)

            let slowerQueue = DispatchQueue(label: "reflect slower \(self?.dataSource.outputImages.count ?? -1)")

            for _ in 0..<50 {
                slowerQueue.sync {
                    usleep(arc4random_uniform(200) * 1000)
                    outputImage.progress += 0.02
                }
            }

            outputImage.image = newImage
        }
    }
}
