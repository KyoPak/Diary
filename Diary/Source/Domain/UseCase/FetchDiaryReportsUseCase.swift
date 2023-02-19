//
//  FetchDiaryReportsUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

protocol FetchDiaryReportsUseCase {
    func fetchData() -> Result<[DiaryReport], DataError>
}

final class DefaultFetchDiaryReportsUseCase: FetchDiaryReportsUseCase {
    private let coreDataRepository: CoreDataRepository
    
    init(coreDataRepository: CoreDataRepository) {
        self.coreDataRepository = coreDataRepository
    }
    
    func fetchData() -> Result<[DiaryReport], DataError>  {
        let result = coreDataRepository.fetch()
        
        switch result {
        case .success(let datas):
            return .success(datas)
        case .failure(let error):
            return .failure(error)
        }
    }
}
