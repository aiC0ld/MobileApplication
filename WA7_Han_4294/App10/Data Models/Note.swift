//
//  Note.swift
//  App10
//
//  Created by Xinyue Han on 11/3/24.
//

import Foundation

struct Note: Codable {
    let _id: String
    let userId: String
    var text: String
    let __v: Int
}

struct AllNotes: Codable {
    let notes: [Note]
}

struct AddNote: Codable {
    let posted: Bool
    let note: Note
}

struct DeleteNote: Codable {
    let delete: Bool
    let message: String
}
