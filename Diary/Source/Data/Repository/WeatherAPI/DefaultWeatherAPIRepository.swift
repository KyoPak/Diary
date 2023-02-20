//
//  WeatherAPIRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

final class DefaultWeatherAPIRepository: WeatherAPIRepository {
    func fetch(url: URL, completion: @escaping (Result<Data, SessionError>) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let sesseion = URLSession(configuration: .default)
        
        sesseion.dataTask(with: urlRequest) { data, response, error in
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
