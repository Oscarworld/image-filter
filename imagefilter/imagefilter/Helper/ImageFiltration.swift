//
//  ImageFiltration.swift
//  imagefilter
//
//  Created by Oscar on 28/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

class ImageFiltration: Operation {
    let photoRecord: PhotoRecord
    
    init(photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        if photoRecord.state != .new {
            return
        }
        
        var filteredImage: UIImage? = nil
        
        guard let resizeImage = resizeImage(image: photoRecord.image) else {
            self.photoRecord.state = .failed
            return
        }
        
        photoRecord.image = resizeImage
        
        usleep((arc4random_uniform(6) + 1) * 5 * 100000)
        
        switch self.photoRecord.filterType {
        case .rotate:
            filteredImage = applyRotateFilter(image: photoRecord.image)
        case .bw:
            filteredImage = applyBWFilter(image: photoRecord.image)
        case .mirror:
            filteredImage = applyMirrorFilter(image: photoRecord.image)
        case .reflex:
            filteredImage = applyReflexFilter(image: photoRecord.image)
        case .invert:
            filteredImage = applyInvertFilter(image: photoRecord.image)
        default:
            return
        }
        
        if let filteredImage = filteredImage {
            photoRecord.image = filteredImage
            self.photoRecord.state = .filtered
        } else {
            self.photoRecord.state = .failed
        }
    }
}

extension ImageFiltration {
    func resizeImage(image: UIImage) -> UIImage? {
        let originalSize = image.size
        let targetSize = CGSize(width: 200, height: 200)
        
        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height
        
        let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: originalSize.width * ratio, height: originalSize.height * ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func applyRotateFilter(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        if isCancelled {
            return nil
        }
        
        let context = CIContext(options: nil)
        let newAngle = CGFloat(90 * Double.pi / 180)
        let transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(newAngle), 0, 0, 1)
        let affineTransform = CATransform3DGetAffineTransform(transform)
        
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: kCIInputTransformKey)
        
        if isCancelled {
            return nil
        }
        
        guard let filtered = filter?.outputImage, let cgImage = context.createCGImage(filtered, from: filtered.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func applyBWFilter(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        if isCancelled {
            return nil
        }
        
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey)
        
        if isCancelled {
            return nil
        }
        
        guard let filtered = filter?.outputImage, let cgImage = context.createCGImage(filtered, from: filtered.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func applyMirrorFilter(image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        if isCancelled {
            return nil
        }
        
        let context = CIContext(options: nil)
        let transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(1 * Double.pi), 0, 1, 0)
        let affineTransform = CATransform3DGetAffineTransform(transform)
        
        let filter = CIFilter(name: "CIAffineTransform")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(NSValue(cgAffineTransform: affineTransform), forKey: kCIInputTransformKey)
        
        if isCancelled {
            return nil
        }
        
        guard let filtered = filter?.outputImage, let cgImage = context.createCGImage(filtered, from: filtered.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func applyReflexFilter(image: UIImage) -> UIImage? {
        return nil
    }
    
    func applyInvertFilter(image: UIImage) -> UIImage? {
        return nil
    }
}
