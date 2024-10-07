//
//  Contact.swift
//  WA4_Han_4294
//
//  Created by Xinyue Han on 10/6/24.
//

import Foundation

struct Contact {
    var name: String?
    var email: String?
    var phoneType: String?
    var phoneNumber: Int?
    var address: String?
    var cityState: String?
    var zip: String?

    init(name: String? = nil, email: String? = nil, phoneType: String? = nil, phoneNumber: Int? = nil, address: String? = nil, cityState: String? = nil, zip: String? = nil) {
        self.name = name
        self.email = email
        self.phoneType = phoneType
        self.phoneNumber = phoneNumber
        self.address = address
        self.cityState = cityState
        self.zip = zip
    }
}
