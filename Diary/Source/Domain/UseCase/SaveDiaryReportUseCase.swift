//
//  CreateDiaryReportUseCase.swift
//  Diary
//
//  Created by parkhyo on 2023/02/21.
//

import Foundation

protocol SaveDiaryReportUseCase {
    func createData(data: DiaryReport)
    func updateData(data: DiaryReport, completion: @escaping (DataError?) -> Void)
}

final class DefaultSaveDiaryReportUseCase: SaveDiaryReportUseCase {
    private let coreDataRepository: CoreDataRepository
    
    init(coreDataRepository: CoreDataRepository) {
        self.coreDataRepository = coreDataRepository
    }
    
    func createData(data: DiaryReport) {
        coreDataRepository.create(data: data)
    }
    
    func updateData(data: DiaryReport, completion: @escaping (DataError?) -> Void) {
        coreDataRepository.update(id: data.id, contentText: data.contentText) { error in
            if let error = error {
                completion(error)
            }
        }
    }
}
