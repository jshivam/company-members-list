//
//  CompanyListController.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia
import SafariServices

class CompanyListController: UITableViewController {
    let viewModel: CompanyListViewModelProtocol

    init(viewModel: CompanyListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.viewTitle

        tableView.style {
            $0.estimatedRowHeight = 40
            $0.rowHeight = UITableView.automaticDimension
            $0.tableFooterView = UIView()
            $0.register(ofType: CompanyCell.self)
        }

        dowloadData()
    }

    private func dowloadData() {
        showHeaderLoader()
        viewModel.fetchCompanies { [weak self] (status) in
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

extension CompanyListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: CompanyCell.self, for: indexPath)
        cell.delegate = self
        cell.configure(company: viewModel.item(at: indexPath))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CompanyListController: CompanyCellDelegate {
    func companyCellDidTapWebsiteButton(_ cell: CompanyCell) {
        
    }
}

extension CompanyListController: TableViewHeaderLoadable {}
