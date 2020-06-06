//
//  FetchRequestStatus.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

enum FetchRequestStatus {
    case fetched
    case error(NetworkError)
}

