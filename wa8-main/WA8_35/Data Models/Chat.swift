//
//  Chat.swift
//  WA8_35
//
//  Created by Xinyue Han on 11/15/24.
//

import Foundation
import FirebaseFirestore

struct Chat {
    let contact: Contact
    let senderName: String
    let lastMessage: String
    let timestamp: Date
}
