//
//  ConversationsViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
        if !isLoggedIn {
            HelperManager.presentViewController(
                LoginViewController(),
                from: self,
                modalPresentationStyle: .fullScreen)
        }
    }

    
}
