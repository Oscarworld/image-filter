//
//  DetailsViewController.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol DetailsViewProtocol: class {
    var presenter: DetailsPresenterProtocol! { get set }
    
    func showData()
}

class DetailsViewController: BaseViewController {
    var presenter: DetailsPresenterProtocol!
    let configurator: DetailsConfiguratorProtocol = DetailsConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
    }
}

extension DetailsViewController: DetailsViewProtocol {
    func showData() {
        
    }
}
