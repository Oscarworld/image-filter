//
//  Wireframe+Appearance.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

extension Wireframe {
    internal final func configureAppearance(with color: UIColor) {
        configureButtonAppearance(with: color)
    }
    
    private func configureButtonAppearance(with color: UIColor) {
        let button = UIButton.appearance()
        button.setTitleColor(color, for: .normal)
    }
}
