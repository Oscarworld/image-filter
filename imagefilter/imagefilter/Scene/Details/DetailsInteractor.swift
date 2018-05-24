//
//  DetailsInteractor.swift
//  imagefilter
//
//  Created by Oscar on 24/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

protocol DetailsInteractorProtocol {
    
}

class DetailsInteractor: DetailsInteractorProtocol {
    weak var presenter: DetailsPresenterProtocol!
    
    required init(presenter: DetailsPresenterProtocol) {
        self.presenter = presenter
    }
}
