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
    
    func setImage(_ image: UIImage?)
    func updateImageView()
    func updateProgressBar(to value: Float)
    
    func buildCell(_ cell: ResultCell, at indexPath: IndexPath) -> ResultCell
    func buildHeader(_ header: FilterHeaderView, at section: Int) -> FilterHeaderView
    
    func headerHeight() -> CGFloat
    func cellHeight() -> CGFloat
    func numberSection() -> Int
    func numberRow() -> Int
}

class FilterPresenter: FilterPresenterProtocol {
    weak var view: (FilterViewProtocol & BaseViewController)!
    weak var headerDelegate: FilterHeaderUpdateDelegate! {
        didSet {
            headerDelegate.updateImage(interactor.retrieveImage())
        }
    }
    var interactor: FilterInteractorProtocol!
    
    required init(view: FilterViewProtocol & BaseViewController) {
        self.view = view
    }
}

// MARK: Implementation of FilterPresenterProtocol
extension FilterPresenter {
    func setImage(_ image: UIImage?) {
        interactor.saveImage(image)
    }
    
    func updateImageView() {
        headerDelegate.updateImage(interactor.retrieveImage())
    }
    
    func updateProgressBar(to value: Float) {
        headerDelegate.updateProgress(uploaded: value)
    }
}

// MARK: Implementation of UITableViewDelegate
extension FilterPresenter {
    func buildCell(_ cell: ResultCell, at indexPath: IndexPath) -> ResultCell {
        let model = interactor.getOutputModel(at: indexPath)
        cell.setModel(model)
        return cell
    }
    
    func buildHeader(_ header: FilterHeaderView, at section: Int) -> FilterHeaderView {
        header.delegate = self
        self.headerDelegate = header
        return header
    }
    
    func headerHeight() -> CGFloat {
        return 200
    }
    
    func cellHeight() -> CGFloat {
        return 160
    }
    
    func numberSection() -> Int {
        return 1
    }
    
    func numberRow() -> Int {
        return interactor.outputImagesCount()
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
    
    func didTapRotate(image: UIImage?) {
        if let image = image {
            interactor.rotateImage(image)
            let indexPath = IndexPath(row: 0, section: 0)
            view.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Изображение не загружено", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Готово", style: .cancel, handler: nil))
            
            self.view.present(alert, animated: true, completion: nil)
        }
    }
    
    func didTapInvertColors(image: UIImage?) {
        if let image = image {
            interactor.invertColorImage(image)
            let indexPath = IndexPath(row: 0, section: 0)
            view.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Изображение не загружено", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Готово", style: .cancel, handler: nil))
            
            self.view.present(alert, animated: true, completion: nil)
        }
    }
    
    func didTapMirrorImage(image: UIImage?) {
        if let image = image {
            interactor.reflectImage(image)
            let indexPath = IndexPath(row: 0, section: 0)
            view.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Изображение не загружено", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Готово", style: .cancel, handler: nil))
            
            self.view.present(alert, animated: true, completion: nil)
        }
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


