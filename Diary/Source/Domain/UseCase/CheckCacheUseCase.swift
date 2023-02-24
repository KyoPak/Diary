//
//  CheckCacheUseCase.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import Foundation

protocol CheckCacheUseCase {
    func check(id: String) -> Data?
    func save(id: String, data: Data)
}

final class DefaultCacheCheckUseCase: CheckCacheUseCase {
    private let cacheRepository: CacheRepository
    
    init(cacheRepository: CacheRepository) {
        self.cacheRepository = cacheRepository
    }
    
    func check(id: String) -> Data? {
        guard let wrapperData = cacheRepository.fetchCacheData(id: id) else {
            return nil
        }
        return wrapperData.data
    }
    
    func save(id: String, data: Data) {
        cacheRepository.saveCache(id: id, wrapperData: WrapperData(data: data))
    }
}
