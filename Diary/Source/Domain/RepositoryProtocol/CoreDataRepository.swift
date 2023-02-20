//
//  CoreDataRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

protocol CoreDataRepository {
    func fetch() -> Result<[DiaryReport], DataError>
    func create(data: DiaryReport)
    func update(id: UUID, contentText: String) throws
    func delete(id: UUID) throws
}
