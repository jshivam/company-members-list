//
//  Company.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

class Company: Codable {
    let id: String
    let about: String
    let company: String
    let logo: URL
    let website: URL
    let members: [Member]
    var isfavorite = false
    var isfollwing = false

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case about = "about"
        case company = "company"
        case logo = "logo"
        case website = "website"
        case members = "members"
    }
}
