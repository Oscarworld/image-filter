//
//  ResultCell.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol ResultCellUpdateDelegate: class {
    func updateProgress(uploaded: Float)
    func updateImage(_ image: UIImage?)
}

class ResultCell: UITableViewCell {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var outputImageView: UIImageView!
    
    private var model: OutputImage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureComponents()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configureComponents() {
        outputImageView.contentMode = .scaleAspectFit
        progressView.isHidden = true
        progressView.progressTintColor = Wireframe.shared.mainColor
    }
    
    public func setModel(_ model: OutputImage) {
        self.model = model
        updateProgress(uploaded: 1)
        updateImage(model.image)
        model.delegateImage.delegate(to: self) { (self, image) in
            self.updateImage(image)
        }
        model.delegateProgress.delegate(to: self) { (self, value) in
            self.updateProgress(uploaded: value)
        }
    }
}

extension ResultCell: ResultCellUpdateDelegate {
    public func updateProgress(uploaded: Float) {
        DispatchQueue.main.async { [weak self] in
            let rounded = round(uploaded * 100) / 100
//            self?.progressView.progress = uploaded
//            self?.progressView.isHidden = rounded == 1.0
//            self?.outputImageView.isHidden = rounded != 1.0
            if let progress = self?.progressView.progress, uploaded - 0.02 > progress {
                //print("Error with uploaded: \(uploaded) and progress \(progress)")
            } else {
                self?.progressView.progress = uploaded
                self?.progressView.isHidden = rounded == 1.0
                self?.outputImageView.isHidden = rounded != 1.0
            }
        }
    }
    
    public func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.outputImageView.image = image
        }
    }   
}
