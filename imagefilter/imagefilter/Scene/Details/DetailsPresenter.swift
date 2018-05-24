//
//  DetailsPresenter.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

protocol DetailsPresenterProtocol: class {
    func viewDidLoad()
}

class DetailsPresenter: DetailsPresenterProtocol {
    weak var view: (DetailsViewProtocol & BaseViewController)!
    var interactor: DetailsInteractorProtocol!
    
    required init(view: DetailsViewProtocol & BaseViewController) {
        self.view = view
    }
    
    func viewDidLoad() {
        view.showData()
    }
}
