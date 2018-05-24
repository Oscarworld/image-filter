//
//  FilterPresenter.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

protocol FilterPresenterProtocol: class {
    func viewDidLoad()
    func exifButtonClicked()
}

class FilterPresenter: FilterPresenterProtocol {
    weak var view: (FilterViewProtocol & BaseViewController)!
    var interactor: FilterInteractorProtocol!
    
    required init(view: FilterViewProtocol & BaseViewController) {
        self.view = view
    }
    
    func viewDidLoad() {
        view.showLoading()
        interactor.retrieveImages()
    }
    
    func didRetrieveImages() {
        view.hideLoading()
        view.showImages()
    }
    
    func onError() {
        view.hideLoading()
        view.showError()
    }
    
    func exifButtonClicked() {
        if let navigation = view.navigationController {
            Wireframe.shared.show(
                type: DetailsViewController.self,
                as: .asNext(navigation)
            )
        }
    }
}
