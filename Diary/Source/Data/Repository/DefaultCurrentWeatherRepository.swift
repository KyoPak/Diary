//
//  DefaultCurrentWeatherRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/27.
//

import Foundation

final class DefaultCurrentWeatherRepository: CurrentWeatherRepository {
    private let networkService: NetworkSevice
    
    init(networkService: NetworkSevice) {
        self.networkService = networkService
    }
    
    func configureRequest(type: NetworkRequest) throws -> URLRequest {
        do {
            let request = try type.generateRequest()
            return request
        } catch let error as SessionError {
            throw(error)
        } catch {
            throw(error)
        }
    }
    
    func fetch(request: URLRequest, completion: @escaping (Result<Data, SessionError>) -> Void) {
        
        networkService.request(request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
