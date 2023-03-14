//
//  CreateDiaryReportUseCase.swift
//  Diary
//
//  Created by parkhyo on 2023/02/21.
//

import Foundation

protocol SaveDiaryReportUseCase {
    func createData(_ data: DiaryReport)
    func updateData(_ data: DiaryReport, completion: @escaping (DataError?) -> Void)
}

final class DefaultSaveDiaryReportUseCase: SaveDiaryReportUseCase {
    private let diaryDataRepository: DiaryDataRepository
    
    init(diaryDataRepository: DiaryDataRepository) {
        self.diaryDataRepository = diaryDataRepository
    }
    
    func createData(_ data: DiaryReport) {
        diaryDataRepository.create(data: data)
    }
    
    func updateData(_ data: DiaryReport, completion: @escaping (DataError?) -> Void) {
        diaryDataRepository.update(id: data.id, contentText: data.contentText) { error in
            completion(error)
        }
    }
}
