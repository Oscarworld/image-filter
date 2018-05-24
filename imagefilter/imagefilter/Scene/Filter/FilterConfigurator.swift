//
//  FilterConfigurator.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

protocol FilterConfiguratorProtocol: class {
    func configure(with viewController: FilterViewController)
}

class FilterConfigurator: FilterConfiguratorProtocol {
    func configure(with viewController: FilterViewController) {
        let presenter = FilterPresenter(view: viewController)
        let interactor = FilterInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        viewController.tableView.delegate = viewController
        viewController.tableView.dataSource = viewController
        viewController.configureTitle("Фильтр")
        presenter.interactor = interactor
        presenter.viewDidLoad()
    }
}
