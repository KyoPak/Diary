//
//  FetchDiaryReportsUseCaseTest.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/02/28.
//

import XCTest
@testable import Diary

final class FetchDiaryReportsUseCaseTest: XCTestCase {
    var fetchDiaryUseCase: FetchDiaryReportsUseCase!
    var diaryDataRepository: DiaryDataRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        diaryDataRepository = MockDiaryDataRepository()
        fetchDiaryUseCase =  DefaultFetchDiaryReportsUseCase(diaryDataRepository: diaryDataRepository)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        fetchDiaryUseCase = nil
        diaryDataRepository = nil
    }
    
    func test_fetchData_success() {
        // given
        diaryDataRepository.create(
            data: DiaryReport(id: UUID(), contentText: "test1", createdAt: Date(), weather: CurrentWeather())
        )
        diaryDataRepository.create(
            data: DiaryReport(id: UUID(), contentText: "test2", createdAt: Date(), weather: CurrentWeather())
        )
        // when
        let expectation = XCTestExpectation(description: "Content, count 확인")
        fetchDiaryUseCase.fetchData { result in
            // then
            switch result {
            case .success(let diaryReports):
                XCTAssertEqual(diaryReports.count, 2)
                XCTAssertEqual(diaryReports[0].contentText, "test1")
                XCTAssertEqual(diaryReports[1].contentText, "test2")
                expectation.fulfill()
            case .failure:
                XCTFail("Completion should not return failure")
            }
            
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
