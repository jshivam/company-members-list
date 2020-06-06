//
//  CompanyServiceProtocol.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

protocol CompanyServiceProtocol {
    func fetchCompanies(completionHandler: @escaping (Result<[Company], NetworkError>) -> Void)
}

class CompanyServiceService: BaseService, CompanyServiceProtocol {
    func fetchCompanies(completionHandler: @escaping (Result<[Company], NetworkError>) -> Void) {
        netwrok.get(endpoint: EndPoint.companyList.rawValue, parameters: [:]) { [weak self] (data, error) in
            guard let `self` = self else { return }
            self.handleResponse(data: data, error: error) { (result: Result<[Company], NetworkError>) in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let companies):
                    companies.isEmpty ? completionHandler(.failure(.zeroItems("Companies"))) : completionHandler(.success(companies))
                }
            }
        }
    }
}
