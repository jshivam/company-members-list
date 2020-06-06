//
//  MemberListViewModel.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

private struct Constants {
    static let title = "Members"
}

protocol MemberListViewModelProtocol: ViewModelProtocol {
    func fetchMembers(completionHandler: @escaping (FetchRequestStatus) -> Void)
    func numberOfItems(inSection section: Int) -> Int
    func item(at indexPath: IndexPath) -> Member
    func filter(with text: String?, completion: () -> ())
    func sort(ascending: Bool, sortBy: MemberListViewModel.SortBy, completion: ()->())
    var filteredMembers: [Member] { get set }
}

class MemberListViewModel: MemberListViewModelProtocol {
    private let dataManager: CompanyDataManagerProtocol
    var filteredMembers = [Member]()
    weak var searchDelegate: SearchListDelegate?

    init(dataManager: CompanyDataManagerProtocol = CompanyDataManager.shared) {
        self.dataManager = dataManager
    }

    func fetchMembers(completionHandler: @escaping (FetchRequestStatus) -> Void) {
        dataManager.fetchMembers { (result) in
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
        guard let delegate = searchDelegate else { return dataManager.members.count }
        return delegate.isFiltering() ? filteredMembers.count : dataManager.members.count
    }

    func item(at indexPath: IndexPath) -> Member {
        guard let delegate = searchDelegate else { return dataManager.members[indexPath.row] }
        return delegate.isFiltering() ? filteredMembers[indexPath.row] : dataManager.members[indexPath.row]
    }

    func sort(ascending: Bool, sortBy: SortBy, completion: ()->()) {
        switch (ascending, sortBy) {
        case (true, .name):
            dataManager.members.sort(by: { $0.name < $1.name })
        case (false, .name):
            dataManager.members.sort(by: { $0.name > $1.name })
        case (true, .age):
            dataManager.members.sort(by: { $0.age < $1.age })
        case (false, .age):
            dataManager.members.sort(by: { $0.age > $1.age })
        }

        completion()
    }

    func filter(with text: String?, completion: () -> ()) {
        guard let text = text, !text.isEmpty else { filteredMembers = []; completion(); return }
        filteredMembers = dataManager.members.filter({ "\($0.name.first) \(($0.name.last))".lowercased().contains(text.lowercased()) })
        completion()
    }
}

extension MemberListViewModel {
    enum SortBy {
        case age, name
    }
}
