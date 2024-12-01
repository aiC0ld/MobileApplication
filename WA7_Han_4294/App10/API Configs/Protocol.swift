//
//  Protocol.swift
//  App10
//
//  Created by Xinyue Han on 11/4/24.
//

import Foundation

protocol Protocol{
    func addANewNote(note: Note)
    func deleteNote(note: Note)
    func editNote(note: Note, originalContact: Note)
    func getAllNotes()
    func getNoteDetails(note: String)
}
