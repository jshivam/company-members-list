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

        let companyController:  UINavigationController  = {
            let viewModel = CompanyListViewModel()
            let controller = CompanyListController(viewModel: viewModel)
            viewModel.searchDelegate = controller
            return UINavigationController(rootViewController: controller)
        }()

        let memberConroller:  UINavigationController  = {
            let viewModel = MemberListViewModel()
            let controller = MemberListController(viewModel: viewModel)
            viewModel.searchDelegate = controller
            return UINavigationController(rootViewController: controller)
        }()

        setViewControllers([companyController, memberConroller], animated: false)

        companyController.tabBarItem = UITabBarItem(title: Constants.companyTitle, image: #imageLiteral(resourceName: "company"), tag: 0)
        memberConroller.tabBarItem = UITabBarItem(title: Constants.memberTitle, image: #imageLiteral(resourceName: "employee"), tag: 1)

    }
}

