//
//  CompanyListViewModel.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

private struct Constants {
    static let title = "Companies"
    static let sortText = "Sort"
}

protocol CompanyListViewModelDelegate: AnyObject {
    func isFiltering() -> Bool
    func isSearchBarEmpty() -> Bool
}

protocol CompanyListViewModelProtocol: ViewModelProtocol {
    func fetchCompanies(completionHandler: @escaping (FetchRequestStatus) -> Void)
    func numberOfItems(inSection section: Int) -> Int
    func item(at indexPath: IndexPath) -> Company
    func sort(ascending: Bool, completion: ()->())
    func filter(with text: String?, completion: () -> ())
    
    var filteredCompanies: [Company] { get set }
}

class CompanyListViewModel: CompanyListViewModelProtocol {
    private let dataManager: CompanyDataManagerProtocol
    var filteredCompanies = [Company]()
    weak var delegate: CompanyListViewModelDelegate?

    init(dataManager: CompanyDataManagerProtocol = CompanyDataManager.shared) {
        self.dataManager = dataManager
    }

    func fetchCompanies(completionHandler: @escaping (FetchRequestStatus) -> Void) {
        dataManager.fetchCompanies { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.error(error))
            case .success:
                completionHandler(.fetched)
            }
        }
    }

    var viewTitle: String? {
        return Constants.title
    }

    func numberOfItems(inSection section: Int) -> Int {
        guard let delegate = delegate else { return dataManager.companies.count }
        return delegate.isFiltering() ? filteredCompanies.count : dataManager.companies.count
    }

    func item(at indexPath: IndexPath) -> Company {
        guard let delegate = delegate else { return dataManager.companies[indexPath.row] }
        return delegate.isFiltering() ? filteredCompanies[indexPath.row] : dataManager.companies[indexPath.row]
    }

    func sort(ascending: Bool, completion: ()->()) {
        if ascending {
            dataManager.companies.sort(by: { $0.company < $1.company })
        } else {
            dataManager.companies.sort(by: { $0.company > $1.company })
        }
        completion()
    }

    func filter(with text: String?, completion: () -> ()) {
        guard let text = text, !text.isEmpty else { filteredCompanies = []; completion(); return }
        filteredCompanies = dataManager.companies.filter({ $0.company.lowercased().contains(text.lowercased()) })
        completion()
    }
}
