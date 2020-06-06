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

private struct Constants {
    static let sortText = "Sort"
    static let ascendingText = "Ascending"
    static let decendingText = "Decending"
    static let cancel = "Cancel"
    static let placeHolder = "Search Companies"
}

class CompanyListController: UITableViewController {
    private let viewModel: CompanyListViewModelProtocol
    private let searchController = UISearchController(searchResultsController: nil)

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

        let sort = UIBarButtonItem(title: Constants.sortText,
                                   style: .plain,
                                   target: self,
                                   action: #selector(sortTapped))
        navigationItem.rightBarButtonItem = sort

        tableView.style {
            $0.estimatedRowHeight = 40
            $0.rowHeight = UITableView.automaticDimension
            $0.tableFooterView = UIView()
            $0.register(ofType: CompanyCell.self)
        }

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.placeHolder
        searchController.searchBar.autocapitalizationType = .none
        definesPresentationContext = true

        dowloadData()
    }

    private func dowloadData() {
        showHeaderLoader()
        viewModel.fetchCompanies { [weak self] (status) in
            self?.hideHeaderLoader()
            self?.tableView.tableHeaderView = self?.searchController.searchBar
            switch status {
            case .error(let error):
                self?.view.showToast(error.localizedDescription)
            case .fetched:
                self?.tableView.reloadData()
            }
        }
    }

    @objc private func sortTapped() {
        let sheet = UIAlertController(title: Constants.sortText, message: nil, preferredStyle: .actionSheet)
        let ascending = UIAlertAction(title: Constants.ascendingText, style: .default) { [weak self] _ in
            self?.viewModel.sort(ascending: true, completion: {
                self?.tableView.reloadData()
            })
        }

        let decending = UIAlertAction(title: Constants.decendingText, style: .default) { [weak self] _ in
            self?.viewModel.sort(ascending: false, completion: {
                self?.tableView.reloadData()
            })
        }

        let cancel = UIAlertAction(title: Constants.cancel, style: .cancel) { _ in }

        sheet.addAction(ascending)
        sheet.addAction(decending)
        sheet.addAction(cancel)

        present(sheet, animated: false, completion: nil)
    }
}

extension CompanyListController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: CompanyCell.self, for: indexPath)
        cell.configure(company: viewModel.item(at: indexPath))
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CompanyListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(with: searchController.searchBar.text) { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.filteredCompanies = []
    }
}

extension CompanyListController: CompanyListViewModelDelegate {
    func isFiltering() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }

    func isSearchBarEmpty() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
}

extension CompanyListController: TableViewHeaderLoadable {}
