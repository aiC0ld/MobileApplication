//
//  Message.swift
//  WA8_35
//
//  Created by Zhang Xinjia on 2024/11/7.
//
//

import Foundation
import FirebaseFirestore

struct Message {
    var id: String?
    var senderID: String
    var receiverID: String
    var text: String
    var timestamp: Date
    var chatID: String

    init(id: String?, senderID: String, receiverID: String, text: String, timestamp: Date, chatID: String) {
        self.id = id
        self.senderID = senderID
        self.receiverID = receiverID
        self.text = text
        self.timestamp = timestamp
        self.chatID = chatID
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.id = document.documentID
        self.senderID = data["senderID"] as? String ?? ""
        self.receiverID = data["receiverID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
        if let timestamp = data["timestamp"] as? Timestamp {
            self.timestamp = timestamp.dateValue()
        } else {
            self.timestamp = Date()
        }
        self.chatID = data["chatID"] as? String ?? ""
    }
}
