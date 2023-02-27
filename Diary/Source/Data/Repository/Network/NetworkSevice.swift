//
//  WeatherAPIRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

protocol NetworkSevice {
    func request(_ request: URLRequest, completion: @escaping (Result<Data, SessionError>) -> Void)
}

final class DefaultNetworkSevice: NetworkSevice {
    func request(_ request: URLRequest, completion: @escaping (Result<Data, SessionError>) -> Void) {
        let sesseion = URLSession(configuration: .default)
        
        sesseion.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completion(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noneDataError))
                return
            }
            
            completion(.success(data))

        }.resume()
    }
}
