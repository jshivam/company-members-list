//
//  CompanyDataManager.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol CompanyDataManagerProtocol: AnyObject {
    func fetchCompanies(completionHandler: @escaping (Result<[Company], NetworkError>) -> Void)
    func fetchMembers(completionHandler: @escaping (Result<[Member], NetworkError>) -> Void)

    var companies: [Company] { get set }
    var members: [Member] { get set }
}

class CompanyDataManager: CompanyDataManagerProtocol {
    static let shared = CompanyDataManager()
    private let service: CompanyServiceProtocol
    private var isFetching = false
    var companies = [Company]()
    var members = [Member]()
    private var activeMemberCallBacks = [(Result<[Member], NetworkError>) -> Void]()

    init(service: CompanyServiceProtocol = CompanyServiceService()) {
        self.service = service
    }

    func fetchCompanies(completionHandler: @escaping (Result<[Company], NetworkError>) -> Void) {
        isFetching = true
        service.fetchCompanies { [weak self] (result) in
            guard let `self` = self else { return }
            self.isFetching = false
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                self.activeMemberCallBacks.forEach({$0(.failure(error))})
            case .success(let companies):
                self.companies = companies
                self.members = companies.reduce([]) { $0 + $1.members }
                self.activeMemberCallBacks.forEach({$0(.success(self.members))})
                completionHandler(.success(companies))
            }
        }
    }

    func fetchMembers(completionHandler: @escaping (Result<[Member], NetworkError>) -> Void) {
        if isFetching { activeMemberCallBacks.append(completionHandler); return }
        completionHandler(.success(members))
    }
}
