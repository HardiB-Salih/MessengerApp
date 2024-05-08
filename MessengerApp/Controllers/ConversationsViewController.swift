//
//  ConversationsViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
   
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .done,
            target: self,
            action: #selector(logoutButtonTapped))
       
    }
    
    
    //MARK: PRIVATE
    /// Save the updated value of logged_in to UserDefaults
    private func userSgiOut(){
        UserDefaults.standard.set(false, forKey: "logged_in")
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
    }

    //
    @objc private func logoutButtonTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            userSgiOut()
        } catch (let error) {
            showAlert(title: "Error Signing Out", message: error.localizedDescription )
        }
    }
    
    
}


//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let isLoggedIn = UserDefaults.standard.bool(forKey: "logged_in")
//        if !isLoggedIn {
//            HelperManager.presentViewController(
//                LoginViewController(),
//                from: self,
//                modalPresentationStyle: .fullScreen)
//        }
//    }
