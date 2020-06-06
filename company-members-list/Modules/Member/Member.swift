//
//  Member.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

class Member: Codable {
    let id: String
    let age: Int
    let email: String
    let phone: String
    let name: Name
    var isfavorite = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case age = "age"
        case email = "email"
        case phone = "phone"
        case name = "name"
    }
}

extension Member {
    struct Name: Codable {
        let first: String
        let last: String
    }
}
