//
//  CellViewModel.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

final class CellViewModel {
    private let diary: DiaryReport
    private let weatherImageUseCase: LoadWeatherImageUseCase
    
    private let cacheUseCase: CheckCacheUseCase
    
    init(
        diary: DiaryReport,
        weatherImageUseCase: LoadWeatherImageUseCase,
        cacheUseCase: CheckCacheUseCase
    ) {
        self.diary = diary
        self.weatherImageUseCase = weatherImageUseCase
        self.cacheUseCase = cacheUseCase
    }
    
    func bindData(completion: @escaping (DiaryReport) -> Void) {
        completion(diary)
    }
    
    func fetchImageData(completion: @escaping (Data) -> Void) {
        guard let iconID = diary.weather.iconID else { return }
        
        if let data = cacheUseCase.check(id: iconID) {
            completion(data)
        } else {
            weatherImageUseCase.loadImage(id: iconID) { data in
                
                DispatchQueue.main.async {
                    completion(data)
                    self.saveCacheData(id: iconID, data: data)
                }
            }
        }
    }
}
