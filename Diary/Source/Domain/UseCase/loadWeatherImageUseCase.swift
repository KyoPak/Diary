//
//  loadWeatherImageUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

protocol loadWeatherImageUseCase {
    func loadImage(id: String, completion: @escaping (Data) -> Void)
}

final class DefaultLoadWeatherImageUseCase: loadWeatherImageUseCase {
    private let weatherAPIRepository: WeatherAPIRepository
    
    init(weatherAPIRepository: WeatherAPIRepository) {
        self.weatherAPIRepository = weatherAPIRepository
    }
    
    func loadImage(id: String, completion: @escaping (Data) -> Void) {
        guard let url = NetworkRequest.loadImage(id: id).generateURL() else { return }
        
        weatherAPIRepository.fetch(url: url) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
