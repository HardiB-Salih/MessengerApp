//
//  ProfileViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import FirebaseAuth
import SDWebImage

class ProfileViewController: UIViewController {

    let data = ["Log Out"]
    
    private let  activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
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
        tableView.tableHeaderView = createTableViewHeader()
    }
    
    private func createTableViewHeader() -> UIView? {
        activityIndicator.startAnimating()
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        let safeEmail = DatabaseManager.safeEmail(email)
        let fileName = "\(safeEmail)_profile_picture.png"
        let path = "images/" + fileName
        
        
        let headerView = UIView(frame: CGRect(x: 0,
                                       y: 0,
                                        width: self.view.width,
                                       height: 300))
        headerView.backgroundColor = .secondarySystemBackground
        let imageView = UIImageView(frame: CGRect(x: (headerView.width - 150) / 2,
                                       y: 75,
                                        width: 150,
                                       height: 150))
        activityIndicator.frame = CGRect(x: imageView.bounds.midX - 15, y: imageView.bounds.midX - 15 , width: 30, height: 30)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 40
        imageView.layer.cornerCurve = .continuous
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemBackground.cgColor
        imageView.clipsToBounds = true
        imageView.addSubview(activityIndicator)
        headerView.addSubview(imageView)
        
        StorageManager.downloadUrl(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url)
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        })
        return headerView
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: {data, _ , error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.sync {
                self.activityIndicator.stopAnimating()
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
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
