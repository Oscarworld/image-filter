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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        configureComponents()
    }
    
    private func configureComponents() {
        outputImageView.contentMode = .scaleAspectFit
        progressView.isHidden = true
        progressView.progressTintColor = Wireframe.shared.mainColor
    }
    
    func setModel(_ model: OutputImage) {
        updateProgress(uploaded: model.progress)
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
    func updateProgress(uploaded: Float) {
        DispatchQueue.main.async { [weak self] in
            let rounded = round(uploaded * 100) / 100
            if let progress = self?.progressView.progress, uploaded - 0.02 > progress {
                print("Error with uploaded: \(uploaded) and progress \(progress)")
            }
            self?.progressView.progress = uploaded
            self?.progressView.isHidden = rounded == 1.0
            self?.outputImageView.isHidden = rounded != 1.0
        }
    }
    
    func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.outputImageView.image = image
        }
    }   
}
