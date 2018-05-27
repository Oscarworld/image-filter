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
}

class FilterViewController: BaseViewController, FilterViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FilterPresenterProtocol!
    var imagePicker: UIImagePickerController!
    
    let configurator: FilterConfiguratorProtocol = FilterConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
    }
}

// MARK: Implementation of UITableViewDataSource and UITableViewDelegate
extension FilterViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return presenter.buildCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return presenter.buildHeader(at: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.showCellMenu(for: indexPath)
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
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        presenter.didFinishPicking(with: info)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presenter.didCancelPicking()
    }
}
