//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Abdelrahman on 10/08/2023.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {
    
    private var messages:[Message] = []
    private let selfSender = Sender(photoURL: "", senderId: "1", displayName: "Ahmed")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messages.append(Message(sender: selfSender, messageId: "2", sentDate: Date(), kind: .text("Hello world Message")))
        
        messages.append(Message(sender: selfSender, messageId: "2", sentDate: Date(), kind: .text("Hello world Message number 2")))
    }

}



extension ChatViewController:MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate{
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
}
