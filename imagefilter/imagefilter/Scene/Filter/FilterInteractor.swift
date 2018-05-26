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
    
    func retrieveImage() -> UIImage?
    func saveImage(_ image: UIImage?)
    func downloadImage(from url: String?)
    
    func outputImagesCount() -> Int
    func getOutputModel(at indexPath: IndexPath) -> OutputImage
    
    func rotateImage(_ image: UIImage)
    func invertColorImage(_ image: UIImage)
    func reflectImage(_ image: UIImage)
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
        dataSource.downloader.didDownload.delegate(to: self) { (self, image) in
            self.dataSource.mainImage = image
        }
        
        dataSource.downloader.updateProgress.delegate(to: self) { (self, value) in
            self.presenter.updateProgressBar(to: value)
        }
        
        dataSource.didSetImage.delegate(to: self) { (self, image) in
            self.presenter.updateImageView()
        }
    }
}

// MARK: Implementation of FilterInteractor
extension FilterInteractor {
    func saveImage(_ image: UIImage?) {
        dataSource.mainImage = image
    }
    
    func retrieveImage() -> UIImage? {
        return dataSource.mainImage
    }
    
    func downloadImage(from url: String?) {
        if let url = url, let imageURL = NSURL(string: url) {
            self.dataSource.downloader.downloadImage(url: imageURL)
        }
    }
    
    func getOutputModel(at indexPath: IndexPath) -> OutputImage {
        return dataSource.outputImages[indexPath.row]
    }
    
    func outputImagesCount() -> Int {
        return dataSource.outputImages.count
    }
}

// MARK: Implementation of Filtering image
extension FilterInteractor {
    func rotateImage(_ image: UIImage) {
        let outputImage = OutputImage()
        dataSource.outputImages.insert(outputImage, at: 0)
        
        let queue = DispatchQueue(label: "rotate \(dataSource.outputImages.count)")
        
        queue.async {
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
            
            let sem = DispatchSemaphore(value: 2)
            DispatchQueue.concurrentPerform(iterations: 50) { (id: Int) in
                //print(queue.label)
                sem.wait(timeout: DispatchTime.distantFuture)
                usleep(arc4random_uniform(200) * 1000)
                outputImage.progress += 0.02
                sem.signal()
            }
            
            queue.async (flags: .barrier) {
                outputImage.image = newImage
            }
        }
    }
    
    func invertColorImage(_ image: UIImage) {
        let outputImage = OutputImage()
        dataSource.outputImages.insert(outputImage, at: 0)
        
        let queue = DispatchQueue(label: "rotate \(dataSource.outputImages.count)")
        
        queue.async {
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
            
            let sem = DispatchSemaphore(value: 2)
            DispatchQueue.concurrentPerform(iterations: 50) { (id: Int) in
                //print(queue.label)
                sem.wait(timeout: DispatchTime.distantFuture)
                usleep(arc4random_uniform(200) * 1000)
                outputImage.progress += 0.02
                sem.signal()
            }
            
            queue.async (flags: .barrier) {
                outputImage.image = newImage
            }
        }
    }
    
    func reflectImage(_ image: UIImage) {
        let outputImage = OutputImage()
        dataSource.outputImages.insert(outputImage, at: 0)
        
        let queue = DispatchQueue(label: "rotate \(dataSource.outputImages.count)")
        
        queue.async {
            guard let ciImage = CIImage(image: image) else {
                return
            }
            
            let transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(1 * Double.pi), 0, 1, 0)
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
            
            let sem = DispatchSemaphore(value: 2)
            DispatchQueue.concurrentPerform(iterations: 50) { (id: Int) in
                //print(queue.label)
                sem.wait(timeout: DispatchTime.distantFuture)
                usleep(arc4random_uniform(200) * 1000)
                outputImage.progress += 0.02
                sem.signal()
            }
            
            queue.async (flags: .barrier) {
                outputImage.image = newImage
            }
        }
    }
}
