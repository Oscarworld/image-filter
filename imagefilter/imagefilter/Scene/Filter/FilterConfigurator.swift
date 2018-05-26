//
//  FilterConfigurator.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterConfiguratorProtocol: class {
    func configure(with viewController: FilterViewProtocol & BaseViewController)
}

class FilterConfigurator: FilterConfiguratorProtocol {
    func configure(with viewController: FilterViewProtocol & BaseViewController) {
        let presenter = FilterPresenter(view: viewController)
        let dataSource = FilterDataSource()
        let interactor = FilterInteractor(presenter: presenter, dataSource: dataSource)
        let imagePicker = UIImagePickerController()
        
        interactor.dataSource = dataSource
        
        viewController.configureTitle("Filter")
        viewController.presenter = presenter
        viewController.imagePicker = imagePicker
        
        viewController.tableView.register(UINib(nibName: "FilterHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header_view")
        viewController.tableView.register(UINib(nibName: "ResultCell", bundle: nil), forCellReuseIdentifier: "result_cell")
        
        viewController.tableView.delegate = viewController
        viewController.tableView.dataSource = viewController
        viewController.imagePicker.delegate = viewController
        
        presenter.interactor = interactor
    }
}
