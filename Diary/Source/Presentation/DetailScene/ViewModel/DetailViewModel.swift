//
//  DetailViewModel.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

final class DetailViewModel {
    private let fetchWeatherDataUseCase: FetchWeatherDataUseCase
    private var diary: DiaryReport
    
    init(data: DiaryReport?, fetchWeatherDataUseCase: FetchWeatherDataUseCase) {
        self.fetchWeatherDataUseCase = fetchWeatherDataUseCase
        guard let data = data else {
            diary = DiaryReport(
                id: UUID(),
                contentText: "",
                createdAt: Date(),
                weather: CurrentWeather()
            )
            
            return
        }
        diary = data
    }
}

extension DetailViewModel {
    func bindData(completion: @escaping (DiaryReport) -> Void) {
        completion(diary)
    }
    
    func fetchWeatherData(lat: String, long: String) {
        fetchWeatherDataUseCase.fetchWeatherData(lat: lat, lon: long) { data in
            self.diary.weather = data
        }
    }
}
