//
//  DeleteDiaryReportUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

protocol DeleteDiaryReportUseCase {
    func deleteData(id: UUID, completion: @escaping (DataError?) -> Void)
}

final class DefaultDeleteDiaryReportUseCase: DeleteDiaryReportUseCase {
    private let diaryDataRepository: DiaryDataRepository
    
    init(diaryDataRepository: DiaryDataRepository) {
        self.diaryDataRepository = diaryDataRepository
    }
    
    func deleteData(id: UUID, completion: @escaping (DataError?) -> Void) {
        diaryDataRepository.delete(id: id) { error in
            if let error = error {
                completion(error)
            }
        }
    }
}
