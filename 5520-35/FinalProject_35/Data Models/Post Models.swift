//
//  Post Models.swift
//  FinalProject_35
//
//  Created by Yu huiying on 11/28/24.
//

//import Foundation
//import FirebaseFirestore
//
//struct Post: Codable {
//    var id: String
//    var imageURL: String?
//    var description: String?
//    var userId: String?
//
//    init(id: String, imageURL: String?, description: String?, userId: String?) {
//        self.id = id
//        self.imageURL = imageURL
//        self.description = description
//        self.userId = userId
//    }
//
//    init?(document: DocumentSnapshot) {
//        guard let data = document.data() else { return nil }
//        self.id = document.documentID
//        self.imageURL = data["imageURL"] as? String
//        self.description = data["description"] as? String
//        self.userId = data["userId"] as? String
//    }
//}

import Foundation
import FirebaseFirestore

struct Comment {
    let userId: String
    let username: String
    let text: String
    let timestamp: Date
}

//struct Post {
//    var id: String
//    var imageURL: String?
//    var description: String?
//    var userId: String?
//    var createdAt: Date
//    var likes: Int
//    var comments: [Comment]
//    
//    init(id: String, imageURL: String?, description: String?, userId: String?, createdAt: Date, likes: Int, comments: [Comment]) {
//        self.id = id
//        self.imageURL = imageURL
//        self.description = description
//        self.userId = userId
//        self.createdAt = createdAt
//        self.likes = likes
//        self.comments = comments
//    }
//    
//    init?(document: DocumentSnapshot) {
//        guard let data = document.data() else { return nil }
//        self.id = document.documentID
//        self.imageURL = data["imageURL"] as? String
//        self.description = data["description"] as? String
//        self.userId = data["userId"] as? String
//        self.likes = data["likes"] as? Int ?? 0
//        
//        // Parse comments
//        if let commentDicts = data["comments"] as? [[String: Any]] {
//            self.comments = commentDicts.compactMap { dict in
//                guard
//                    let userId = dict["userId"] as? String,
//                    let username = dict["username"] as? String,
//                    let text = dict["text"] as? String,
//                    let timestamp = dict["timestamp"] as? Timestamp
//                else {
//                    return nil
//                }
//                return Comment(userId: userId, username: username, text: text, timestamp: timestamp.dateValue())
//            }
//        } else {
//            self.comments = []
//        }
//        
//        if let timestamp = data["createdAt"] as? Timestamp {
//            self.createdAt = timestamp.dateValue()
//        } else {
//            self.createdAt = Date()
//        }
//    }
//}

struct Post {
    var id: String
    var imageURL: String?
    var description: String?
    var userId: String?
    var username: String? // new field
    var createdAt: Date
    var likes: Int
    var likesUserIds: [String]
    var comments: [Comment]

    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        self.id = document.documentID
        self.imageURL = data["imageURL"] as? String
        self.description = data["description"] as? String
        self.userId = data["userId"] as? String
        self.username = data["username"] as? String  // read the username
        self.likes = data["likes"] as? Int ?? 0
        self.likesUserIds = data["likesUserIds"] as? [String] ?? [] 
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }

        if let commentDicts = data["comments"] as? [[String: Any]] {
            self.comments = commentDicts.compactMap { dict in
                guard
                    let userId = dict["userId"] as? String,
                    let username = dict["username"] as? String,
                    let text = dict["text"] as? String,
                    let ts = dict["timestamp"] as? Timestamp
                else {
                    return nil
                }
                return Comment(userId: userId, username: username, text: text, timestamp: ts.dateValue())
            }
        } else {
            self.comments = []
        }
    }
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id &&
               lhs.imageURL == rhs.imageURL &&
               lhs.description == rhs.description &&
               lhs.userId == rhs.userId &&
               lhs.username == rhs.username &&
               lhs.likes == rhs.likes &&
               lhs.createdAt == rhs.createdAt
    }
}
