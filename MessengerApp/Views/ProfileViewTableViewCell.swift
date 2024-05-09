//
//  ProfileViewTableViewCell.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/9/24.
//

import UIKit

class ProfileViewTableViewCell: UITableViewCell {
    static let identifier = "ProfileViewTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
