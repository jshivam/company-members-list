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
}

protocol CompanyListViewModelProtocol: ViewModelProtocol {
    func fetchCompanies(completionHandler: @escaping (FetchRequestStatus) -> Void)
    func numberOfItems(inSection section: Int) -> Int
    func item(at indexPath: IndexPath) -> Company
}

class CompanyListViewModel: CompanyListViewModelProtocol {
    private let dataManager: CompanyDataManagerProtocol

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
        return dataManager.companies.count
    }

    func item(at indexPath: IndexPath) -> Company {
        return dataManager.companies[indexPath.row]
    }
}
