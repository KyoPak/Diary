//
//  FetchWeatherDataUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

protocol FetchWeatherDataUseCase {
    func fetchWeatherData(
        lat: String,
        lon: String,
        completion: @escaping (CurrentWeather) -> Void
    )
}

final class DefaultFetchWeatherDataUseCase {
    private let currentWeatherRepository: CurrentWeatherRepository
    
    init(currentWeatherRepository: CurrentWeatherRepository) {
        self.currentWeatherRepository = currentWeatherRepository
    }
    
    private func convertWeatherData(
        _ data: Data,
        completion: @escaping ((String, String)) -> Void
    ) {
        
        let decoder = DecoderManager<WeatherAPIData>()
        let data = decoder.decodeData(data)
        
        switch data {
        case .success(let data):
            guard let weatherData = data.weather.first else { return }
            completion((weatherData.icon, weatherData.main))
        case .failure(let error):
            print(error)
        }
    }
}

extension DefaultFetchWeatherDataUseCase: FetchWeatherDataUseCase {
    func fetchWeatherData(
        lat: String,
        lon: String,
        completion: @escaping (CurrentWeather) -> Void
    ) {
        
        guard let request = try? currentWeatherRepository.configureRequest(
            type: .fetchData(lat: lat, lon: lon)
        ) else {
            return
        }
        
        currentWeatherRepository.fetch(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                self?.convertWeatherData(data) { (iconID, main) in
                    let data = CurrentWeather(iconID: iconID, main: main)
                    completion(data)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
