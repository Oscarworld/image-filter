//
//  DetailsConfigurator.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

protocol DetailsConfiguratorProtocol: class {
    func configure(with viewController: DetailsViewController)
}

class DetailsConfigurator: DetailsConfiguratorProtocol {
    func configure(with viewController: DetailsViewController) {
        let presenter = DetailsPresenter(view: viewController)
        let interactor = DetailsInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        viewController.configureTitle("Информация")
        presenter.interactor = interactor
        presenter.viewDidLoad()
    }
}
