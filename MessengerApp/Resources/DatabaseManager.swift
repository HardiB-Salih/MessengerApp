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
    
    public enum DatabaseError: Error {
        case failedToGetAllUsers
        
    }
    
    
    
    
    public func safeEmail(_ emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
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
    public func insertUser(with user: ChatAppUser, completion: @escaping CompletionHandler<Bool>) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastname
        ], withCompletionBlock: {error, _ in
            guard error == nil else {
                print("faild to write to database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var userCollection = snapshot.value as? [[String: String]] {
                    //append to user dictionsry
                    let newElement = [
                        "name": user.firstName + " " + user.lastname,
                        "email": user.safeEmail
                    ]
                    userCollection.append(newElement)
                    self.database.child("users").setValue(userCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            print("faild to append users collection")
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                    
                } else {
                    // create That Array
                    let newCollection : [[String: String]] = [
                        [
                            "name": user.firstName + " " + user.lastname,
                            "email": user.safeEmail
                            
                        ]
                    ]
                    
                    self.database.child("users").setValue(newCollection, withCompletionBlock: {error, _ in
                        guard error == nil else {
                            print("faild to add users collection")
                            completion(false)
                            return
                        }
                        
                        completion(true)
                    })
                }
            })
        })
    }
    
    public func getAllUsers(completion: @escaping ResultCompletion<[[String : String]]>) {
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String : String]] else {
                completion(.failure(DatabaseError.failedToGetAllUsers))
                return
            }
            completion(.success(value))
        })
    }


    
    /*
     users = [
        [
            "name":
            "email":
        ],
        [
            "name":
            "email":
        ],
     ]
     */
}

// MARK: -Sending messages / conversations
extension _DatabaseManager {
    /*
     "hnfjjnfj" => {
        messages : [
            "id" string
            "type": Text, photo, video
            "content": String
            "date" : Date()
            "sender_email" : String
            "isRead" : true/false
        ]
     }
     
     
     conversation = [
        [
            "conversation_id": "hnfjjnfj"
            "other_user_email":
            "latest_message": => {
                    "date":
                    "latest_message":
                    "is_read":
                }
        ],
     ]
     */
    /// create a new conversation with target user email and first message sent.
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message, completion: @escaping CompletionHandler<Bool>){
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = safeEmail(currentEmail)
        let ref = database.child(safeEmail)
        
        ref.observeSingleEvent(of: .value, with: {snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("User Not Found")
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            var message = ""
            switch firstMessage.kind {
            case .text( let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            let conversationId = "conversation_\(firstMessage.messageId)"
            let newConversationData: [String : Any] = [
                "id": conversationId,
                "other_user_email": otherUserEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            
            if var conversations = userNode["conversations"] as? [[String : Any]] {
                // conversation array exsist for current user
                // you should append
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(conversationId: conversationId, firstMessage: firstMessage, completion: completion)
                })
            } else {
                // conversation array dose not exsist
                // you should create it.
                userNode["conversations"] = [ newConversationData ]
                ref.setValue(userNode, withCompletionBlock: { [weak self] error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(conversationId: conversationId, firstMessage: firstMessage, completion: completion)
                })
            }
        })
        
    }
    
    private func finishCreatingConversation(conversationId: String, firstMessage: Message, completion: @escaping CompletionHandler<Bool>) {
        //        "hnfjjnfj" => {
        //           messages : [
//                       "id" string
//                       "type": Text, photo, video
//                       "content": String
//                       "date" : Date()
//                       "sender_email" : String
//                       "isRead" : true/false
        //           ]
        //        }
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeCurrntEmail = safeEmail(currentUserEmail)
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        var content = ""
        switch firstMessage.kind {
        case .text( let messageText):
            content = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        let message : [String: Any] = [
            "id" : firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": content,
            "date" : dateString,
            "sender_email" : safeCurrntEmail,
            "is_read" : false
        ]
        
        let value : [ String: Any ] = [
            "messages" : [
                message
            ]
        ]
        
        
        database.child("\(conversationId)").setValue(value, withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            
        })
    }
    
    /// fetches and results all conversations for the user with passwd in email.
    public func getAllConversations(for email: String, completion: @escaping ResultCompletion<String>) {
        
    }
    /// get All Messages For given Conversation.
    public func getAllMessagesForConversations(with id: String, completion: @escaping ResultCompletion<String>) { }
    
    /// send a message with target conversation message.
    public func sendMessage(to conversation : String, message: Message, completion: @escaping CompletionHandler<Bool>) { }
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
    var profilePictureFileName: String {
        return "\(safeEmail)_profile_picture.png"
    }
}



