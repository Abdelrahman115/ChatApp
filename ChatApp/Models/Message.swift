//
//  Message.swift
//  ChatApp
//
//  Created by Abdelrahman on 11/08/2023.
//

import Foundation
import MessageKit


struct Message:MessageType{
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

