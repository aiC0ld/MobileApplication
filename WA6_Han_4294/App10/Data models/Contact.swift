//
//  Contact.swift
//  App10
//
//  Created by Sakib Miazi on 5/25/23.
//

import Foundation
//MARK: struct for a contact...
struct Contact{
    var name:String
    var email:String
    var phone: Int
    
    init(name: String, email: String, phone: Int) {
        self.name = name
        self.email = email
        self.phone = phone
    }
}
