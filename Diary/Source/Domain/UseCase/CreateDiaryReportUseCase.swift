//
//  CreateDiaryReportUseCase.swift
//  Diary
//
//  Created by parkhyo on 2023/02/21.
//

import Foundation

protocol CreateDiaryReportUseCase {
    func createData(data: DiaryReport)
}

final class DefaultCreateDiaryReportUseCase: CreateDiaryReportUseCase {
    private let coreDataRepository: CoreDataRepository
    
    init(coreDataRepository: CoreDataRepository) {
        self.coreDataRepository = coreDataRepository
    }
    
    func createData(data: DiaryReport) {
        coreDataRepository.create(data: data)
    }
}
