//
//  ChatViewController.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/9/24.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var photoUrl: String
    var senderId: String
    var displayName: String
}

class ChatViewController: MessagesViewController {
    
    private var messages = [Message]()
    private let selfSender = Sender(photoUrl: "",
                                    senderId: "1",
                                    displayName: "HardiB. Salih")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Populate messages array
        messages.append(Message(sender: selfSender,
                                 messageId: "1",
                                 sentDate: Date(),
                                 kind: .text("Hello World message")))
        messages.append(Message(sender: selfSender,
                                 messageId: "1",
                                 sentDate: Date(),
                                 kind: .text("Hello World message Hello World message Hello World message")))
        view.backgroundColor = .red
        // Set up MessagesCollectionView
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
}


extension ChatViewController : MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    var currentSender: MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}
