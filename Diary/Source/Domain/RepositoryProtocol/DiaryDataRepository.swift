//
//  DiaryDataRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

protocol DiaryDataRepository {
    func fetch(completion: @escaping (Result<[DiaryData], DataError>) -> Void)
    func create(data: DiaryReport)
    func update(id: UUID, contentText: String, completion: @escaping (DataError?) -> Void)
    func delete(id: UUID, completion: @escaping (DataError?) -> Void)
}
