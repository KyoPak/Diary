//
//  CacheRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import Foundation

protocol CacheRepository {
    func fetchCacheData(id: String) -> WrapperData?
    func saveCache(id: String, wrapperData: WrapperData)
}
