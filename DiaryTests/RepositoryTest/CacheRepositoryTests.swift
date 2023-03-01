//
//  CacheRepositoryTests.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/03/01.
//

import XCTest
@testable import Diary

final class CacheRepositoryTests: XCTestCase {

    var repository: CacheRepository!
    var cacheService: CacheService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        cacheService = MockCacheService()
        repository = DefaultCacheRepository(cacheService: cacheService)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        cacheService = nil
        repository = nil
    }
    
    func test_save() {
        // Given
        let id = "test"
        let wrapperData = WrapperData(data: "test".data(using: .utf8))
        
        // When
        repository.saveCache(id: id, wrapperData: wrapperData)
        
        guard let fetchData = cacheService.fetch(key: NSString(string: id)) else {
            XCTFail("Error")
            return
        }
        
        // Then
        XCTAssertEqual(wrapperData.data, fetchData.data)
    }
    
    func test_fetch() {
        // Given
        let id = "test"
        let wrapperData = WrapperData(data: "test".data(using: .utf8))
        cacheService.save(key: NSString(string: id), wrapperData: wrapperData)
        
        // When
        guard let fetchData = repository.fetchCacheData(id: id) else {
            XCTFail("Error")
            return
        }
        
        // Then
        XCTAssertEqual(wrapperData.data, fetchData.data)
    }
}
