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
    public weak var delegate: FilterHeaderDelegate!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var defaultImageView: UIImageView!
    
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var invertButton: UIButton!
    @IBOutlet weak var mirrorButton: UIButton!
    @IBOutlet weak var exifButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func didTapRotate(_ sender: Any) {
        guard let image = mainImageView.image else {
            delegate.didTapImageView()
            return
        }

        delegate.didTapRotate(image: image)
    }
    
    @IBAction func didTapInvertColors(_ sender: Any) {
        guard let image = mainImageView.image else {
            delegate.didTapImageView()
            return
        }
        
        delegate.didTapInvertColors(image: image)
    }
    
    @IBAction func didTapMirrorImage(_ sender: Any) {
        guard let image = mainImageView.image else {
            delegate.didTapImageView()
            return
        }
        
        delegate.didTapMirrorImage(image: image)
    }
    
    @IBAction func didTapEXIF(_ sender: Any) {
        if mainImageView.image != nil {
            delegate.didTapEXIF()
        } else {
            delegate.didTapImageView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureComponents()
    }
    
    private func configureComponents() {
        mainImageView.contentMode = .scaleAspectFit
        defaultImageView.contentMode = .scaleAspectFit
        progressView.isHidden = true
        progressView.progressTintColor = Wireframe.shared.mainColor
        defaultImageView.image = UIImage(named: "add_photo")
        configureButton(rotateButton)
        configureButton(invertButton)
        configureButton(mirrorButton)
        configureButton(exifButton)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(tapGestureRecognizer)
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
    public func updateProgress(uploaded: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.progress = uploaded
            self?.progressView.isHidden = uploaded == 1
        }
    }
    
    public func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.mainImageView.image = image
            self?.defaultImageView.isHidden = image != nil
        }
    }
}
