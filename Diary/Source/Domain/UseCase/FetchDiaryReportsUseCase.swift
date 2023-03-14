//
//  FetchDiaryReportsUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

protocol FetchDiaryReportsUseCase {
    func fetchData(completion: @escaping (Result<[DiaryReport], DataError>) -> Void)
}

final class DefaultFetchDiaryReportsUseCase: FetchDiaryReportsUseCase {
    private let diaryDataRepository: DiaryDataRepository
    
    init(diaryDataRepository: DiaryDataRepository) {
        self.diaryDataRepository = diaryDataRepository
    }
    
    private func convert(from data: DiaryData) -> DiaryReport {
        let weatherData = CurrentWeather(iconID: data.weather?.iconID, main: data.weather?.main)
        
        let diaryReport = DiaryReport(
            id: data.id ?? UUID(),
            contentText: data.contentText ?? "",
            createdAt: data.createdAt ?? Date(),
            weather: weatherData
        )
        
        return diaryReport
    }
    
    func fetchData(completion: @escaping (Result<[DiaryReport], DataError>) -> Void) {
        diaryDataRepository.fetch { result in
            switch result {
            case .success(let datas):
                completion(.success(datas.map(self.convert(from:))))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
