//
//  NewConversationsViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import JGProgressHUD

class NewConversationsViewController: UIViewController {
    public var comptetion : (([String : String]) -> Void)?
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    
    private let searchBar : UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search for Users..."
        return search
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let noResultLable: UILabel = {
        let lable = UILabel()
        lable.isHidden = true
        lable.text = "No Result"
        lable.textAlignment = .center
        lable.textColor = .red
        lable.font = .systemFont(ofSize: 20, weight: .medium)
        return lable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        
        noResultLable.sizeToFit()
        noResultLable.frame = CGRect(x: view.bounds.midX - (noResultLable.width / 2),
                                   y: view.bounds.midY - (noResultLable.height / 2), 
                                   width: noResultLable.width,
                                   height: noResultLable.height)
    }
    
    //MARK: -Private
    private func setUpUI(){
        view.backgroundColor = .secondarySystemBackground
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        searchBar.becomeFirstResponder()
        
        view.addSubview(tableView)
        view.addSubview(noResultLable)
    }
    
    private func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: -Objc
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}


extension NewConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = results[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.comptetion?(targetUserData)
        }
    }
}


extension NewConversationsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        searchBar.resignFirstResponder()
        
        results.removeAll()
        spinner.show(in: view)
        self.searchUsers(query: text)
    }
    
    func searchUsers(query: String) {
        // check if array has firbase result
        if hasFetched {
            // if it dose: filter
            filterUser(with: query)
        } else {
            // if not, fetch then filter
            DatabaseManager.getAllUsers(completion: { [ weak self ] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUser(with: query)
                case .failure(let error):
                    print("Faild to get users: \(error)")
                }
            })
        }
    }
    
    func filterUser(with term: String) {
        // update the UI: ether show result or show table no result lable
        guard hasFetched else {
            return
        }
        
        spinner.dismiss()
        
        let results : [[String: String]] = self.users.filter ({
            guard let name = $0["name"]?.lowercased() as? String else { return false }
            
            return name.hasPrefix(term.lowercased())
        })
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            noResultLable.isHidden = false
            tableView.isHidden = true
        } else {
            noResultLable.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}



