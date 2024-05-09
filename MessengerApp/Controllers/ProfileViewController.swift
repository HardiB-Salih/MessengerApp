//
//  ProfileViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    let data = ["Log Out"]
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProfileViewTableViewCell.self, forCellReuseIdentifier: ProfileViewTableViewCell.identifier)
        tableView.separatorStyle = .none
//        tableView.allowsSelection = false
        return tableView
    }()
    
    //MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Log Out",
            style: .done,
            target: self,
            action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .systemRed

        setUpTable()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
    }
    
    //MARK: -Private
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// post didChangeNotification so Scene delegate confirm it.
    private func userSgiOut(){
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
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

//MARK: SET TABLE VIEW
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewTableViewCell.identifier, for: indexPath)
        let result = data[indexPath.row]
        cell.textLabel?.text = result
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .systemRed
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
//        cell.detailTextLabel?.text = result.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 79
//    }
}
