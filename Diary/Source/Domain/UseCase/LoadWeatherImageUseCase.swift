//
//  LoadWeatherImageUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

protocol LoadWeatherImageUseCase {
    func loadImage(id: String, completion: @escaping (Data) -> Void)
}

final class DefaultLoadWeatherImageUseCase: LoadWeatherImageUseCase {
    private let networkRepository: NetworkRepository
    
    init(networkRepository: NetworkRepository) {
        self.networkRepository = networkRepository
    }
    
    func loadImage(id: String, completion: @escaping (Data) -> Void) {
        guard let url = NetworkRequest.loadImage(id: id).generateURL() else { return }
        
        networkRepository.fetch(url: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
