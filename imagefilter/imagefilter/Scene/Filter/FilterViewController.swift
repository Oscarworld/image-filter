//
//  FilterViewController.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterViewProtocol: UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var tableView: UITableView! { get set }
    var presenter: FilterPresenterProtocol! { get set }
    var imagePicker: UIImagePickerController! { get set }
    
    func showImagePicker()
    func showImages()
    func showLoading()
    func hideLoading()
    func showError()
}

class FilterViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FilterPresenterProtocol!
    var imagePicker: UIImagePickerController!
    
    let configurator: FilterConfiguratorProtocol = FilterConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        configurator.configure(with: self)
    }
}

// MARK: Implementation of FilterViewProtocol
extension FilterViewController: FilterViewProtocol {
    func showImagePicker() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showImages() {
        tableView.reloadData()
    }
    
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func showError() {
        
    }
}

// MARK: Implementation of UITableViewDataSource and UITableViewDelegate
extension FilterViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "result_cell", for: indexPath) as? ResultCell else {
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header_view") as? FilterHeaderView else {
            return nil
        }
        
        header.delegate = presenter
        if let image = presenter.getMainImage() {
            header.mainImageView.image = image
        } else {
            header.mainImageView.image = UIImage(named: "add_photo")
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberRow()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberSection()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return presenter.headerHeight()
    }
}

extension FilterViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            presenter.setImage(pickedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
