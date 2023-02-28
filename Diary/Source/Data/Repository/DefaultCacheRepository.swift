//
//  DefaultCacheRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import Foundation

final class DefaultCacheRepository: CacheRepository {
    private let cacheService: CacheService
    
    init(cacheService: CacheService) {
        self.cacheService = cacheService
    }
    
    func fetchCacheData(id: String) -> WrapperData? {
        let cacheKey = NSString(string: id)
        return cacheService.fetch(key: cacheKey)
    }
    
    func saveCache(id: String, wrapperData: WrapperData) {
        let cacheKey = NSString(string: id)
        cacheService.save(key: cacheKey, wrapperData: wrapperData)
    }
}
