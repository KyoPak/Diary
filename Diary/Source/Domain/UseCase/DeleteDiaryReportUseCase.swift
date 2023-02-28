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
    private let coreDataRepository: CoreDataRepository
    
    init(coreDataRepository: CoreDataRepository) {
        self.coreDataRepository = coreDataRepository
    }
    
    func deleteData(id: UUID, completion: @escaping (DataError?) -> Void) {
        coreDataRepository.delete(id: id) { error in
            if let error = error {
                completion(error)
            }
        }
    }
}
