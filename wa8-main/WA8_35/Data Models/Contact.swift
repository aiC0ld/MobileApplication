//
//  Contact.swift
//  WA8_35
//
//  Created by Zhang Xinjia on 2024/11/7.
//

import Foundation
import FirebaseFirestore

struct Contact: Codable {
    var id: String?
    var name: String
    var email: String

    init(id: String?, name: String, email: String) {
        self.id = id
        self.name = name
        self.email = email
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.id = document.documentID
        self.name = data["name"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
    }
}
