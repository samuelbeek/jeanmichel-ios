//
//  MasterViewController.swift
//  jeanmichel
//
//  Created by Samuel Beek on 20/05/16.
//  Copyright © 2016 Samuel Beek. All rights reserved.
//

import UIKit
import Cartography

class MasterViewController : UINavigationController {
    
    let infoView = InfoView()
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showInfoView()

    }
    
    func showInfoView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideInfoView))
        infoView.addGestureRecognizer(tap)
        infoView.frame = view.bounds
        infoView.backgroundColor = Styles.Colors.lightPinkColor
        self.view.addSubview(infoView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.hideInfoView()
        }

    }
    
    func hideInfoView() {
        if (self.infoView.alpha == 1) {
            UIView.animate(withDuration: 0.35, animations: { [weak self] in
                self?.infoView.alpha = 0
            }, completion: { [weak self]  _ in
                self?.infoView.removeFromSuperview()
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

}

