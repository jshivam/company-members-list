//
//  BaseService.swift
//  company-members-list
//
//  Created by Shivam Jaiswal on 06/06/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import Foundation

class BaseService {
    let netwrok: NetworkManagerProtocol
    init(netwrok: NetworkManagerProtocol = NetworkManager.shared) {
        self.netwrok = netwrok
    }

    /// handles REST respone
    func handleResponse<Model: Decodable>(data: Data?,
                                          error: NetworkError?,
                                          completionHandler: @escaping (Result<Model, NetworkError>) -> Void) {
        if let error = error {
           completionHandler(.failure(error))
        } else if let data = data {
           do {
               let responseData = try JSONDecoder().decode(Model.self, from: data)
               completionHandler(.success(responseData))
           } catch let error {
               completionHandler(.failure(.parsingError(error)))
           }
        } else {
            completionHandler(.failure(.standardError))
        }
    }
}
