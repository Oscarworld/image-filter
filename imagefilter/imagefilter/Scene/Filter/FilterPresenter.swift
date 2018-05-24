//
//  FilterPresenter.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterPresenterProtocol: FilterHeaderDelegate {
    func viewDidLoad()
    func setImage(_ image: UIImage)
    func updateImageView()
    func getMainImage() -> UIImage?
    
    func headerHeight() -> CGFloat
    func cellHeight() -> CGFloat
    func numberSection() -> Int
    func numberRow() -> Int
    
    func didRetrieveImages()
    func onError()
}

class FilterPresenter: FilterPresenterProtocol {
    weak var view: (FilterViewProtocol & BaseViewController)!
    var interactor: FilterInteractorProtocol!
    
    required init(view: FilterViewProtocol & BaseViewController) {
        self.view = view
    }
}

// MARK: Implementation of FilterPresenterProtocol
extension FilterPresenter {
    func viewDidLoad() {
        view.showLoading()
    }
    
    func setImage(_ image: UIImage) {
        interactor.saveImage(image)
    }
    
    func updateImageView() {
        let section = numberSection() - 1
        view.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func getMainImage() -> UIImage? {
        return interactor.retrieveImages()
    }
    
    func didRetrieveImages() {
        view.hideLoading()
        view.showImages()
    }
    
    func onError() {
        view.hideLoading()
        view.showError()
    }
}

// MARK: Implementation of UITableViewDelegate
extension FilterPresenter {
    func headerHeight() -> CGFloat {
        return 200
    }
    
    func cellHeight() -> CGFloat {
        return 20
    }
    
    func numberSection() -> Int {
        return 1
    }
    
    func numberRow() -> Int {
        return 10
    }
}

// MARK: Implementation of FilterHeaderDelegate
extension FilterPresenter {
    func didTapImageView() {
        view.showImagePicker()
    }
    
    func didTapRotate() {
        
    }
    
    func didTapInvertColors() {
        
    }
    
    func didTapMirrorImage() {
        
    }
    
    func didTapEXIF() {
        if let navigation = view.navigationController {
            Wireframe.shared.show(
                type: DetailsViewController.self,
                as: .asNext(navigation)
            )
        }
    }
}


