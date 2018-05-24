//
//  Wireframe.swift
//  imagefilter
//
//  Created by Oscar on 23/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.
//

import UIKit

enum WireframeTypeTransition {
    case asRoot
    case asNext(UINavigationController)
}

class Wireframe {
    static let shared: Wireframe = Wireframe()
    
    private lazy var delegate: AppDelegate = {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        } else {
            fatalError("Can not get application delegate - something wrong")
        }
    }()
    
    private lazy var window: UIWindow = {
        if let window = delegate.window {
            return window
        } else {
            delegate.window = UIWindow(frame: UIScreen.main.bounds)
            
            guard var window = delegate.window else {
                fatalError("Can not get application window - something wrong")
            }
            window.makeKeyAndVisible()
            return window
        }
    }()
    
    public func enterToApplication() -> Bool {
        show(type: FilterViewController.self, as: .asRoot)
        return true
    }
    
    public func show(controller: UIViewController, as mode: WireframeTypeTransition) {
        switch mode {
        case .asRoot:
            let nav = UINavigationController()
            nav.viewControllers = [controller]
            window.rootViewController = nav
        case .asNext(let navigation):
            navigation.pushViewController(controller, animated: true)
        }
    }
    
    public func show<T: BaseViewControllerProtocol & UIViewController>(type: T.Type, as mode: WireframeTypeTransition, with arguments: [String: Any]? = nil) {
        let controller: T = createController()
        
        if let arguments = arguments {
            controller.decode(arguments: arguments)
        }
        
        return show(controller: controller, as: mode)
        
    }
    
    private final func createController<T: UIViewController>() -> T {
        return T(nibName: String(describing: T.self), bundle: nil)
    }
}
