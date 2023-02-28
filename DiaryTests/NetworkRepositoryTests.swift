//
//  NetworkRepositoryTests.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/02/28.
//

import XCTest
@testable import Diary

final class NetworkRepositoryTests: XCTestCase {
    var repository: NetworkRepository!
    var networkService: NetworkSevice!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = MockNetworkService()
        repository = DefaultNetworkRepository(networkService: networkService)
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        repository = nil
        networkService = nil
    }
    
    func test_fetch() throws {
        // Given
        // Data 셋팅
        let mockData = "mock data".data(using: .utf8)!
        let mockNetworkService = MockNetworkService()
        mockNetworkService.data = mockData
        
        // Request 셋팅
        guard let mockRequest = try? NetworkRequest.loadImage(id: "TEST").generateRequest() else { return }
        let sut = DefaultNetworkRepository(networkService: mockNetworkService)
        let expectation = XCTestExpectation(description: "completion")
        
        // When
        sut.fetch(request: mockRequest) { result in
            // Then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, mockData)
                expectation.fulfill() //테스트 성공
            case .failure(let error):
                XCTFail("unexpected error: \(error)")
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
