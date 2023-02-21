//
//  CreateDiaryReportUseCase.swift
//  Diary
//
//  Created by parkhyo on 2023/02/21.
//

import Foundation

protocol SaveDiaryReportUseCase {
    func createData(data: DiaryReport)
    func updateData(data: DiaryReport) throws
}

final class DefaultSaveDiaryReportUseCase: SaveDiaryReportUseCase {
    private let coreDataRepository: CoreDataRepository
    
    init(coreDataRepository: CoreDataRepository) {
        self.coreDataRepository = coreDataRepository
    }
    
    func createData(data: DiaryReport) {
        coreDataRepository.create(data: data)
    }
    
    func updateData(data: DiaryReport) throws {
        
        do {
            try coreDataRepository.update(id: data.id, contentText: data.contentText)
        } catch {
            if let error = error as? DataError {
                throw error
            }
        }
    }
}
