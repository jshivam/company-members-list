//
//  TableViewProtocol.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

@objc protocol TableViewProtocol {
    var tableView: UITableView! { get }
}

protocol TableViewHeaderLoadable: TableViewProtocol {
    func showHeaderLoader()
    func hideHeaderLoader()
}

extension TableViewHeaderLoadable {
    func showHeaderLoader() {
        let loaderView = LoaderView(frame: .zero)
        let height = loaderView.preferredHeight
        loaderView.frame = CGRect.init(x: 0, y: 0, width: 0, height: height)
        loaderView.loader.startAnimating()
        tableView.tableHeaderView = loaderView
        loaderView.setNeedsLayout()
    }

    func hideHeaderLoader() {
        tableView.tableHeaderView = UIView()
    }
}


