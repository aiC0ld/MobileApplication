//
//  Authen.swift
//  App10
//
//  Created by Xinyue Han on 11/4/24.
//

import Foundation

struct AuthToken: Codable {
    let auth: Bool
    let token: String?
}

struct User: Codable {
    let _id: String
    let name: String
    let email: String
}
