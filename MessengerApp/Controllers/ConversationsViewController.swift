//
//  ConversationsViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    //MARK: -UI Elements
    private let tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        table.separatorStyle = .none
        return table
    } ()
    
    private let noConversationsLable : UILabel = {
        let lable = UILabel()
        lable.isHidden = true
        lable.text = "No Conversations"
        lable.textAlignment = .center
        lable.textColor = .systemGray
        lable.font = .systemFont(ofSize: 20, weight: .medium)
        
        return lable
        
    }()
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Logout",
//            style: .done,
//            target: self,
//            action: #selector(logoutButtonTapped))
        setUpSubviews()
        setUpTableView()
        fetchConversations()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        noConversationsLable.sizeToFit()
        noConversationsLable.frame = CGRect(x: view.bounds.midX - (noConversationsLable.width / 2),
                                   y: view.bounds.midY - (noConversationsLable.height / 2),
                                   width: noConversationsLable.width,
                                   height: noConversationsLable.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: PRIVATE
    /// post didChangeNotification so Scene delegate confirm it.
    private func userSgiOut(){
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
    }
    
    private func setUpSubviews() {
        view.addSubview(tableView)
        view.addSubview(noConversationsLable)
    }
    
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func fetchConversations() {
        tableView.isHidden = false
//        noConversationsLable.isHidden = false
    }
    
    
    //MARK: Objc.
    @objc private func didTapComposeButton() {
        let vc = NewConversationsViewController()
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            userSgiOut()
        } catch (let error) {
            showAlert(title: "Error Signing Out", message: error.localizedDescription )
        }
    }
}


//MARK: -TableView Implementaions
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Hardi B Salih"
        vc.navigationItem.largeTitleDisplayMode = .never
//        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
