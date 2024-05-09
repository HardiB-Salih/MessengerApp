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

        let conversationVc = ConversationsViewController()
        let conversationNavVC = UINavigationController(rootViewController: conversationVc)
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        conversationVc.navigationItem.backBarButtonItem = backButtonItem
        conversationNavVC.navigationBar.tintColor = .link
        
        let settingVc = SettingViewController()
        let settingNavVC = UINavigationController(rootViewController: settingVc)
        settingVc.navigationItem.backBarButtonItem = backButtonItem
        settingNavVC.navigationBar.tintColor = .link

        
        conversationNavVC.tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "ellipsis.message.fill"), tag: 0)
        settingNavVC.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "gear"), tag: 0)

        viewControllers = [conversationNavVC, settingNavVC]
    }
}


