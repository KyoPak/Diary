//
//  DetailViewModel.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

final class DetailViewModel {
    private let fetchWeatherDataUseCase: FetchWeatherDataUseCase
    private let weatherImageUseCase: LoadWeatherImageUseCase
    private let createDiaryDataUseCase: CreateDiaryReportUseCase
    
    private var diary: DiaryReport
    
    init(
        data: DiaryReport?,
        fetchWeatherDataUseCase: FetchWeatherDataUseCase,
        weatherImageUseCase: LoadWeatherImageUseCase,
        createDiaryUseCase: CreateDiaryReportUseCase
    ) {
        self.fetchWeatherDataUseCase = fetchWeatherDataUseCase
        self.weatherImageUseCase = weatherImageUseCase
        self.createDiaryDataUseCase = createDiaryUseCase
        
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
    
    func convertDateText() -> String {
        return Formatter.changeCustomDate(diary.createdAt)
    }
    
    func fetchWeatherData(lat: String, long: String) {
        fetchWeatherDataUseCase.fetchWeatherData(lat: lat, lon: long) { data in
            self.diary.weather = data
        }
    }
    
    func fetchImageData(completion: @escaping (Data) -> Void) {
        guard let iconID = diary.weather.iconID else { return }
        weatherImageUseCase.loadImage(id: iconID) { data in
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
}
