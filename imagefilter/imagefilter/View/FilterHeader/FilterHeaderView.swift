//
//  FilterHeaderView.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterHeaderDelegate: class {
    func didTapImageView()
    func didTapRotate(image: UIImage?)
    func didTapInvertColors(image: UIImage?)
    func didTapMirrorImage(image: UIImage?)
    func didTapEXIF()
}

protocol FilterHeaderUpdateDelegate: class {
    func updateProgress(uploaded: Float)
    func updateImage(_ image: UIImage?)
}

class FilterHeaderView: UITableViewHeaderFooterView {
    weak var delegate: FilterHeaderDelegate!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var invertButton: UIButton!
    @IBOutlet weak var mirrorButton: UIButton!
    @IBOutlet weak var exifButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func didTapRotate(_ sender: Any) {
        delegate.didTapRotate(image: mainImageView.image)
    }
    
    @IBAction func didTapInvertColors(_ sender: Any) {
        delegate.didTapInvertColors(image: mainImageView.image)
    }
    
    @IBAction func didTapMirrorImage(_ sender: Any) {
        delegate.didTapMirrorImage(image: mainImageView.image)
    }
    
    @IBAction func didTapEXIF(_ sender: Any) {
        delegate.didTapEXIF()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureComponents()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureComponents() {
        mainImageView.contentMode = .scaleAspectFit
        progressView.isHidden = true
        progressView.progressTintColor = Wireframe.shared.mainColor
        configureButton(rotateButton)
        configureButton(invertButton)
        configureButton(mirrorButton)
        configureButton(exifButton)
    }
    
    private func configureButton(_ button: UIButton) {
        button.layer.borderColor = Wireframe.shared.mainColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        delegate.didTapImageView()
    }
}

extension FilterHeaderView: FilterHeaderUpdateDelegate {
    func updateProgress(uploaded: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.progress = uploaded
            self?.progressView.isHidden = uploaded == 1
        }
    }
    
    func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            if let image = image {
                self?.mainImageView.image = image
            } else {
                self?.mainImageView.image = UIImage(named: "add_photo")
            }
        }
    }
}
