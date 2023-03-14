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
    private let currentWeatherRepository: CurrentWeatherRepository
    
    init(currentWeatherRepository: CurrentWeatherRepository) {
        self.currentWeatherRepository = currentWeatherRepository
    }
    
    func loadImage(id: String, completion: @escaping (Data) -> Void) {
        guard let request = try? currentWeatherRepository.configureRequest(
            type: .loadImage(id: id)
        ) else {
            return
        }
        
        currentWeatherRepository.fetch(request: request) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
