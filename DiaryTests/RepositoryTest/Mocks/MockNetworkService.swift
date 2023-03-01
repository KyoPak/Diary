//
//  MockNetworkService.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/02/28.
//

import Foundation

final class MockNetworkService: NetworkSevice {
    var data: Data?
    var error: SessionError?
    
    func request(_ request: URLRequest, completion: @escaping (Result<Data, SessionError>) -> Void) {
        guard let data = data else {
            completion(.failure(.networkError))
            return
        }
        completion(.success(data))
    }
}
