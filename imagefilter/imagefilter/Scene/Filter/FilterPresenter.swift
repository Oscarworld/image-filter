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
    
    func didFinishPicking(with info: [String: Any])
    func didCancelPicking()
    
    func updateHeaderImageView()
    func updateHeaderProgressBar(to value: Float)
    
    func buildCell(at indexPath: IndexPath) -> UITableViewCell
    func buildHeader(at section: Int) -> UITableViewHeaderFooterView?
    func showCellMenu(for indexPath: IndexPath)
    
    func headerHeight() -> CGFloat
    func cellHeight() -> CGFloat
    func numberSection() -> Int
    func numberRow() -> Int
}

class FilterPresenter: FilterPresenterProtocol {
    private weak var view: (FilterViewProtocol & BaseViewController)!
    public weak var headerDelegate: FilterHeaderUpdateDelegate!
    public var interactor: FilterInteractorProtocol!
    
    required init(view: FilterViewProtocol & BaseViewController) {
        self.view = view
    }
}

// MARK: Implementation of ImagePicker
extension FilterPresenter {
    public func didFinishPicking(with info: [String: Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            interactor.saveImage(pickedImage)
        }
        view.dismiss(animated: true, completion: nil)
    }
    
    public func didCancelPicking() {
        view.dismiss(animated: true, completion: nil)
    }
}

// MARK: Implementation of FilterPresenterProtocol
extension FilterPresenter {
    public func updateHeaderImageView() {
        headerDelegate.updateImage(interactor.retrieveImage())
    }
    
    public func updateHeaderProgressBar(to value: Float) {
        headerDelegate.updateProgress(uploaded: value)
    }
}

// MARK: Implementation of UITableViewDelegate
extension FilterPresenter {
    private func createAlertController(title: String?, message: String?, alertTitle: String?, alertStyle: UIAlertActionStyle = .default) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: alertTitle, style: alertStyle)
        alertController.addAction(okAction)
        return alertController
    }
    
    public func buildCell(at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = view.tableView.dequeueReusableCell(withIdentifier: "result_cell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        
        let model = interactor.getOutputModel(at: indexPath)
        cell.setModel(model)
        return cell
    }
    
    public func buildHeader(at section: Int) -> UITableViewHeaderFooterView? {
        guard let header = view.tableView.dequeueReusableHeaderFooterView(withIdentifier: "header_view") as? FilterHeaderView else {
            return nil
        }
        
        header.delegate = self
        self.headerDelegate = header
        return header
    }
    
    public func showCellMenu(for indexPath: IndexPath) {
        let actionSaveImage = CustomAlert(title: "Сохранить изображение", style: .default) { [weak self] _ in
            guard
                self?.interactor.saveImageToLibrary(at: indexPath) != true,
                let alertController = self?.createAlertController(
                    title: "Ошибка",
                    message: "Изображение ещё обрабатывается",
                    alertTitle: "ОК") else {
                return
            }
            
            self?.view.present(alertController, animated: true, completion: nil)
        }
        
        let actionReuseImage = CustomAlert(title: "Использовать как основное", style: .default) { [weak self] _ in
            guard
                self?.interactor.setMainImage(at: indexPath) != true,
                let alertController = self?.createAlertController(
                    title: "Ошибка",
                    message: "Изображение ещё обрабатывается",
                    alertTitle: "ОК") else {
                        return
            }
            
            self?.view.present(alertController, animated: true, completion: nil)
        }
        
        let actionDeleteImage = CustomAlert(title: "Удалить изображение", style: .destructive) { [weak self] _ in
            self?.interactor.deleteImage(at: indexPath)
            self?.view.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        self.view.showMenu(
            title: "Выберите действие",
            message: "Что вы хотите сделать с изображением?",
            actions: [actionSaveImage, actionReuseImage, actionDeleteImage, CustomAlert.exit])
    }
    
    public func headerHeight() -> CGFloat {
        return 200
    }
    
    public func cellHeight() -> CGFloat {
        return 100
    }
    
    public func numberSection() -> Int {
        return 1
    }
    
    public func numberRow() -> Int {
        return interactor.rowCount()
    }
}

// MARK: Implementation of FilterHeaderDelegate
extension FilterPresenter {
    public func didTapImageView() {
        let actionTakePhoto = CustomAlert(title: "Снять фото", style: .default) { [weak self] _ in
            guard let imagePicker = self?.view.imagePicker else {
                return
            }
            
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                if let alertController = self?.createAlertController(
                    title: "Ошибка",
                    message: "Устройство не имеет камеру",
                    alertTitle: "ОК") {
                    self?.view.present(alertController, animated: true, completion: nil)
                }
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
        
        self.view.showMenu(
            title: "Загрузить изображение",
            message: "Выберите откуда вы хотите загрузить изображение",
            actions: [actionTakePhoto, actionFromPhotoLibrary, actionFromURL, CustomAlert.exit])
    }
    
    public func didTapRotate(image: UIImage?) {
        if let image = image {
            interactor.rotateImage(image)
            let indexPath = IndexPath(row: 0, section: 0)
            view.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let alertController = createAlertController(
                title: "Ошибка",
                message: "Изображение не загруженоу",
                alertTitle: "Готово",
                alertStyle: .cancel)
            self.view.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func didTapInvertColors(image: UIImage?) {
        if let image = image {
            interactor.invertColorImage(image)
            let indexPath = IndexPath(row: 0, section: 0)
            view.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let alertController = createAlertController(
                title: "Ошибка",
                message: "Изображение не загруженоу",
                alertTitle: "Готово",
                alertStyle: .cancel)
            self.view.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func didTapMirrorImage(image: UIImage?) {
        if let image = image {
            interactor.reflectImage(image)
            let indexPath = IndexPath(row: 0, section: 0)
            view.tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let alertController = createAlertController(
                title: "Ошибка",
                message: "Изображение не загруженоу",
                alertTitle: "Готово",
                alertStyle: .cancel)
            self.view.present(alertController, animated: true, completion: nil)
        }
    }
    
    public func didTapEXIF() {
        if let navigation = view.navigationController {
            Wireframe.shared.show(
                type: DetailsViewController.self,
                as: .asNext(navigation)
            )
        }
    }
}


