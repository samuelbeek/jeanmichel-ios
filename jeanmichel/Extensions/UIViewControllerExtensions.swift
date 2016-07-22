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
    func showAlert(title: String, message: String, button: String = "OK") {
        let alert = UIAlertView()
        alert.title = title
        alert.message = message
        alert.addButtonWithTitle(button)
        alert.show()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

