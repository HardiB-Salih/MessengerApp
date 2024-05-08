//
//  HelperManager.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import Foundation
import UIKit

let HelperManager = _HelperManager()

final class _HelperManager {
    
    func presentViewController<T: UIViewController>(_ viewController: T, from presentingViewController: UIViewController, modalPresentationStyle: UIModalPresentationStyle, animated: Bool = true) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = modalPresentationStyle
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backButtonItem
        // Set the navigation bar's tint color
        navController.navigationBar.tintColor = .link
        presentingViewController.present(navController, animated: animated)
    }
    
}
