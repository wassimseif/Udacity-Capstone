//
//  AlertViewExtension.swift
//  Pin Me
//
//  Created by Wassim Seifeddine on 5/24/16.
//  Copyright © 2016 Abdallah ElMenoufy. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController{
     public func alertUserWithTitle (title: String, message: String) ->UIAlertController {
        
        //Create alert and show it to user.
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK",
                                     style: .Default,
                                     handler: nil)
        
        
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
        return alert
        
        
    }
}