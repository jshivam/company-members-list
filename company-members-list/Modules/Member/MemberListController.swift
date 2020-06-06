//
//  MemberListController.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia
private struct Constants {
    static let sortText = "Sort"
    static let ascendingNameText = "Ascending Name"
    static let decendingNameText = "Decending Name"
    static let ascendingAgeText = "Ascending Age"
    static let decendingAgeText = "Decending Age"
    static let cancel = "Cancel"
    static let placeHolder = "Search Members"
}

class MemberListController: UITableViewController {
    private let viewModel: MemberListViewModelProtocol
    private let searchController = UISearchController(searchResultsController: nil)

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

        let sort = UIBarButtonItem(title: Constants.sortText,
                                   style: .plain,
                                   target: self,
                                   action: #selector(sortTapped))
        navigationItem.rightBarButtonItem = sort

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.placeHolder
        searchController.searchBar.autocapitalizationType = .none
        definesPresentationContext = true

        dowloadData()
    }

    private func dowloadData() {
        showHeaderLoader()
        viewModel.fetchMembers { [weak self] (status) in
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
        let ascendingName = UIAlertAction(title: Constants.ascendingNameText, style: .default) { [weak self] _ in
            self?.viewModel.sort(ascending: true, sortBy: .name, completion: {
                self?.tableView.reloadData()
            })
        }

        let decendingName = UIAlertAction(title: Constants.decendingNameText, style: .default) { [weak self] _ in
            self?.viewModel.sort(ascending: false, sortBy: .name, completion: {
                self?.tableView.reloadData()
            })
        }

        let ascendingAge = UIAlertAction(title: Constants.ascendingAgeText, style: .default) { [weak self] _ in
            self?.viewModel.sort(ascending: true, sortBy: .age, completion: {
                self?.tableView.reloadData()
            })
        }

        let decendingAge = UIAlertAction(title: Constants.decendingAgeText, style: .default) { [weak self] _ in
            self?.viewModel.sort(ascending: false, sortBy: .age, completion: {
                self?.tableView.reloadData()
            })
        }

        let cancel = UIAlertAction(title: Constants.cancel, style: .cancel) { _ in }

        sheet.addAction(ascendingName)
        sheet.addAction(decendingName)
        sheet.addAction(ascendingAge)
        sheet.addAction(decendingAge)
        sheet.addAction(cancel)

        present(sheet, animated: false, completion: nil)
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

extension MemberListController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filter(with: searchController.searchBar.text) { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        viewModel.filteredMembers = []
    }
}

extension MemberListController: SearchListDelegate {
    func isFiltering() -> Bool {
        return searchController.isActive && !isSearchBarEmpty()
    }

    func isSearchBarEmpty() -> Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }
}

extension MemberListController: TableViewHeaderLoadable {}
