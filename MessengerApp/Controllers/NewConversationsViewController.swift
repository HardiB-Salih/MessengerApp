//
//  NewConversationsViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import UIKit
import JGProgressHUD

class NewConversationsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
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
//        lable.isHidden = true
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
    
    private func setUpTableView(){}
    
    
    
    //MARK: -Objc
    @objc private func dismissSelf() {
        dismiss(animated: true)
    }
}

extension NewConversationsViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
