//
//  UIViewControllerExtensions.swift
//  jeanmichel
//
//  Created by Samuel Beek on 22/07/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Shows AlertView inside a UIViewController
     
     - parameter title:   Title of the alert
     - parameter message: What it says
     - parameter button:  What the button says, defaults to OK
     */
    func showAlert(title: String, message: String, button: String = "OK", handler: ((UIAlertAction) -> Void)? = nil)  {
        if let _ = self.presentingViewController as? UIAlertController {
            return
        }
        
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: button, style: .Default, handler: handler)
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

