//
//  MemberListController.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia

class MemberListController: UITableViewController {

    let viewModel: MemberListViewModelProtocol

    init(viewModel: MemberListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.viewTitle
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.style {
            $0.estimatedRowHeight = 40
            $0.rowHeight = UITableView.automaticDimension
            $0.tableFooterView = UIView()
            $0.register(ofType: MemberCell.self)
        }

        dowloadData()
    }

    private func dowloadData() {
        showHeaderLoader()
        viewModel.fetchMembers { [weak self] (status) in
            self?.hideHeaderLoader()
            switch status {
            case .error(let error):
                self?.view.showToast(error.localizedDescription)
            case .fetched:
                self?.tableView.reloadData()
            }
        }
    }
}

extension MemberListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MemberCell.self, for: indexPath)
        cell.configure(member: viewModel.item(at: indexPath))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MemberListController: TableViewHeaderLoadable {}
