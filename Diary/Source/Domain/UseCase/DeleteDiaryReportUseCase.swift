//
//  DeleteDiaryReportUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

protocol DeleteDiaryReportUseCase {
    func deleteData(id: UUID) throws
}

final class DefaultDeleteDiaryReportUseCase: DeleteDiaryReportUseCase {
    private let coreDataRepository: CoreDataRepository
    
    init(coreDataRepository: CoreDataRepository) {
        self.coreDataRepository = coreDataRepository
    }
    
    func deleteData(id: UUID) throws {
        do {
            try coreDataRepository.delete(id: id)
        } catch {
            if let error = error as? DataError {
                throw error
            }
        }
    }
}
