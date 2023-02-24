//
//  DefaultCacheRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import Foundation

final class DefaultCacheRepository: CacheRepository {
    private let cache = NSCache<NSString, WrapperData>()
    
    func fetchCacheData(id: String) -> WrapperData? {
        let cacheKey = NSString(string: id)
        if let cacheWrapperData = cache.object(forKey: cacheKey) {
            return cacheWrapperData
        } else {
            return nil
        }
    }
    
    func saveCache(id: String, wrapperData: WrapperData) {
        let cacheKey = NSString(string: id)
        cache.setObject(wrapperData, forKey: cacheKey)
    }
}
