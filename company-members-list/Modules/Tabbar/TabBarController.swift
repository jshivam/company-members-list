//
//  TabBarController.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

private struct Constants {
    static let companyTitle = "Companies"
    static let memberTitle = "Members"
}

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let companyController = UINavigationController(
            rootViewController: CompanyListController(viewModel: CompanyListViewModel())
        )

        let memberConroller = UINavigationController(
            rootViewController: MemberListController(viewModel: MemberListViewModel())
        )
        
        setViewControllers([companyController, memberConroller], animated: false)

        companyController.tabBarItem = UITabBarItem(title: Constants.companyTitle, image: nil, tag: 0)
        memberConroller.tabBarItem = UITabBarItem(title: Constants.memberTitle, image: nil, tag: 1)

    }
}

