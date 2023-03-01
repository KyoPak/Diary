//
//  MockCacheService.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/03/01.
//

import Foundation

final class MockCacheService: CacheService {
    private var datas: [NSString: WrapperData] = [:]
    
    func fetch(key: NSString) -> WrapperData? {
        return datas[key]
    }
    
    func save(key: NSString, wrapperData: WrapperData) {
        datas[key] = wrapperData
    }
}
