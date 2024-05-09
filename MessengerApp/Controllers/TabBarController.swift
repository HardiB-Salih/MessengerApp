//
//  TabBarController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/9/24.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setValue(CustomTabBar(), forKey: "tabBar")
        setUpTabBarItem()
    }
    
    private func setUpTabBarItem() {
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let conversationVc = ConversationsViewController()
        let conversationNavVC = UINavigationController(rootViewController: conversationVc)
        conversationVc.navigationItem.backBarButtonItem = backButtonItem
        conversationNavVC.navigationBar.tintColor = .link
        conversationNavVC.navigationBar.prefersLargeTitles = true

        
        let ProfileVc = ProfileViewController()
        let ProfileNavVC = UINavigationController(rootViewController: ProfileVc)
        ProfileVc.navigationItem.backBarButtonItem = backButtonItem
        ProfileNavVC.navigationBar.tintColor = .link
        ProfileNavVC.navigationBar.prefersLargeTitles = true

        
        conversationNavVC.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(systemName: "ellipsis.message.fill"), tag: 0)
        ProfileNavVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 0)

        viewControllers = [conversationNavVC, ProfileNavVC]
    }
}


