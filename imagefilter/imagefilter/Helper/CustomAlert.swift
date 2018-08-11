//
//  CustomAlert.swift
//  imagefilter
//
//  Created by Oscar on 25/05/2018.
//  Copyright © 2018 Oscar. All rights reserved.

import UIKit

public class CustomAlert {
    static let exit = CustomAlert(title: "Отмена", style: .destructive)
    
    var title: String
    var style: UIAlertActionStyle
    var handler: ((UIAlertAction) -> Void)? = nil
    
    init(title: String, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    
    var alert: UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}
