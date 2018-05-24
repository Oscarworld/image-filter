//
//  FilterViewController.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol FilterViewProtocol: class {
    var tableView: UITableView! { get set }
    var presenter: FilterPresenterProtocol! { get set }
    
    func showImages()
    func showLoading()
    func hideLoading()
    func showError()
}

class FilterViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBAction func moreDetailsClicked(_ sender: Any) {
        presenter.exifButtonClicked()
    }
    
    var presenter: FilterPresenterProtocol!
    let configurator: FilterConfiguratorProtocol = FilterConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        configurator.configure(with: self)
    }
}

extension FilterViewController: FilterViewProtocol {
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

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default_cell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
