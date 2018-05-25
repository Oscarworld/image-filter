//
//  FilterPresenter.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterPresenterProtocol: FilterHeaderDelegate {
    var headerDelegate: FilterHeaderUpdateDelegate! { get set }
    
    func viewDidLoad()
    func setImage(_ image: UIImage?)
    func updateImageView()
    func updateProgressBar(to value: Float)
    
    func headerHeight() -> CGFloat
    func cellHeight() -> CGFloat
    func numberSection() -> Int
    func numberRow() -> Int
    
    func didRetrieveImages()
    func onError()
}

class FilterPresenter: FilterPresenterProtocol {
    weak var view: (FilterViewProtocol & BaseViewController)!
    weak var headerDelegate: FilterHeaderUpdateDelegate! {
        didSet {
            headerDelegate.updateImage(interactor.retrieveImages())
        }
    }
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
    
    func setImage(_ image: UIImage?) {
        interactor.saveImage(image)
    }
    
    func updateImageView() {
        headerDelegate.updateImage(interactor.retrieveImages())
    }
    
    func updateProgressBar(to value: Float) {
        headerDelegate.updateProgress(uploaded: value)
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
        return 0
    }
}

// MARK: Implementation of FilterHeaderDelegate
extension FilterPresenter {
    func didTapImageView() {
        let actionTakePhoto = CustomAlert(title: "Снять фото", style: .default) { [weak self] _ in
            guard let imagePicker = self?.view.imagePicker else {
                return
            }
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                let alertController = UIAlertController(title: "Ошибка", message: "Устройство не имеет камеру", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Хорошо", style: .default)
                alertController.addAction(okAction)
                self?.view.present(alertController, animated: true, completion: nil)
                return
            }
            
            imagePicker.sourceType = .camera
            
            self?.view.present(imagePicker, animated: true, completion: nil)
        }
        
        let actionFromPhotoLibrary = CustomAlert(title: "Выбрать из библиотеки", style: .default) { [weak self] _ in
            guard let imagePicker = self?.view.imagePicker else {
                return
            }
            
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            self?.view.present(imagePicker, animated: true, completion: nil)
        }
        
        let actionFromURL = CustomAlert(title: "Загрузить из сети", style: .default) { [weak self] _ in
            let alert = UIAlertController(title: "Загрузить изображение из интернета", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            
            alert.addTextField { textField in
                textField.placeholder = "Введите url изображения"
            }
            
            alert.addAction(UIAlertAction(title: "Загрузить", style: .default) { action in
                if let url = alert.textFields?.first?.text {
                    self?.interactor.downloadImage(from: url)
                }
            })
            
            self?.view.present(alert, animated: true, completion: nil)
        }
        
        self.view.showMenu(title: "Загрузить изображение", message: "Выберите откуда вы хотите загрузить изображение", actions: [actionTakePhoto, actionFromPhotoLibrary, actionFromURL, CustomAlert.exit])
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


