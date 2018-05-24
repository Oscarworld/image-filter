//
//  FilterInteractor.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

protocol FilterInteractorProtocol {
    func retrieveImages()
}

class FilterInteractor: FilterInteractorProtocol {
    weak var presenter: FilterPresenterProtocol!
    
    required init(presenter: FilterPresenterProtocol) {
        self.presenter = presenter
    }
    
    func retrieveImages() {
        
    }
}
