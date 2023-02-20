//
//  CellViewModel.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

final class CellViewModel {
    private let diary: DiaryReport
    private let weatherImageUseCase: loadWeatherImageUseCase
    
    init(diary: DiaryReport, weatherImageUseCase: loadWeatherImageUseCase) {
        self.diary = diary
        self.weatherImageUseCase = weatherImageUseCase
    }
    
    func fetchData(completion: @escaping (DiaryReport) -> Void) {
        completion(diary)
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
