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
    func didTapRotate()
    func didTapInvertColors()
    func didTapMirrorImage()
    func didTapEXIF()
}

class FilterHeaderView: UITableViewHeaderFooterView {
    weak var delegate: FilterHeaderDelegate!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var invertButton: UIButton!
    @IBOutlet weak var mirrorButton: UIButton!
    @IBOutlet weak var exifButton: UIButton!
    
    @IBAction func didTapRotate(_ sender: Any) {
        delegate.didTapRotate()
    }
    
    @IBAction func didTapInvertColors(_ sender: Any) {
        delegate.didTapInvertColors()
    }
    
    @IBAction func didTapMirrorImage(_ sender: Any) {
        delegate.didTapMirrorImage()
    }
    
    @IBAction func didTapEXIF(_ sender: Any) {
        delegate.didTapEXIF()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainImageView.contentMode = .scaleAspectFit
        configureButtons()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        mainImageView.isUserInteractionEnabled = true
        mainImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func configureButtons() {
        setStyle(for: rotateButton)
        setStyle(for: invertButton)
        setStyle(for: mirrorButton)
        setStyle(for: exifButton)
    }
    
    private func setStyle(for button: UIButton) {
        button.layer.borderColor = Wireframe.shared.mainColor.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.height / 2
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        delegate.didTapImageView()
    }
}
