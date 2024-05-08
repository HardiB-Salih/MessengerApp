//
//  DatabaseManager.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/8/24.
//

import Foundation
import Firebase

let DatabaseManager = _DatabaseManager()
final class _DatabaseManager {
    
    private let database = Database.database().reference()
    
    
    
}

//MARK: Acount Managment
extension _DatabaseManager {
    /// check the database if user exists
    public func userExists(  with email: String,
                             completion: @escaping ((Bool)-> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: { snapshot in
            
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    
    /// insert new user to databae
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastname
        ])
    }
}

struct ChatAppUser {
    let firstName: String
    let lastname: String
    let emailAddress: String
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    //    let profilePictureUrl: String
}



