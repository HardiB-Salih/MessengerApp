//
//  ConversationsViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
    //MARK: -UI Elements
    private let tableView : UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    } ()
    
    private let noConversationsLable : UILabel = {
        let lable = UILabel()
        lable.text = "No Conversations"
        lable.textAlignment = .center
        lable.textColor = .systemGray
        lable.font = .systemFont(ofSize: 20, weight: .medium)
        lable.isHidden = true
        return lable
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Logout",
            style: .done,
            target: self,
            action: #selector(logoutButtonTapped))
        
        setUpSubviews()
        setUpTableView()
        fetchConversations()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
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
    }
    
    
    //MARK: Objc.
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Hardi B Salih"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
