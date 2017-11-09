//
//  SettingsRemindersViewController.swift
//  MovieStore
//
//  Created by Nhat (Norman) H.M. VU on 11/2/17.
//  Copyright © 2017 enclaveit. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsRemindersViewControllerDelegate: class {
    func closeViewController(_ viewController: SettingsRemindersViewController, didTapBackButton button: UIBarButtonItem)
}

class SettingsRemindersViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    weak var delegate: SettingsRemindersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.closeViewController(self, didTapBackButton: backButton)
    }
}
