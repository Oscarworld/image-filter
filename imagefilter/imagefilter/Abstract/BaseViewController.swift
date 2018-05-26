//
//  BaseViewController.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol {
    static func build<T: BaseViewControllerProtocol & UIViewController>(nibName: String) -> T
    func decode(arguments: [String: Any])
    func moveToPreviousController()
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    static func build<T: BaseViewControllerProtocol & UIViewController>(nibName: String) -> T {
        return T(nibName: nibName, bundle: nil)
    }
    
    func configureTitle(_ title: String) {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.title = title
        } else {
            navigationItem.title = title
        }
    }
    
    func moveToPreviousController() {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

extension BaseViewController {
    func decode(arguments: [String : Any]) { }
}

extension BaseViewController {
    private func createAlertController(title: String?, message: String?, style: UIAlertControllerStyle, actions: [CustomAlert] = []) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for action in actions {
            alertController.addAction(action.alert)
        }
        
        return alertController
    }
    
    func showMenu(title: String, message: String, style: UIAlertControllerStyle = .actionSheet, actions: [CustomAlert]) {
        present(createAlertController(
                title: title,
                message: message,
                style: style,
                actions: actions),
            animated: true)
    }
}
