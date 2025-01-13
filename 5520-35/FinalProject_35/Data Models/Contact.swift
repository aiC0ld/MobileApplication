//
//  Contact.swift
//  FinalProject_35
//
//  Created by Xinyue Han on 12/1/24.
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
