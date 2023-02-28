//
//  SaveDiaryReportUseCaseTest.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/02/28.
//

import XCTest
@testable import Diary

final class SaveDiaryReportUseCaseTest: XCTestCase {

    var saveDiaryUseCase: SaveDiaryReportUseCase!
    var coreDataRepository: CoreDataRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataRepository = MockCoreDataRepository()
        saveDiaryUseCase = DefaultSaveDiaryReportUseCase(coreDataRepository: coreDataRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        coreDataRepository = nil
        saveDiaryUseCase = nil
    }
    
    func test_createData_success() {
        //given, when
        saveDiaryUseCase.createData(DiaryReport(id: UUID(), contentText: "test1", createdAt: Date(), weather: CurrentWeather()))
        
        let expectation = XCTestExpectation(description: "Count, Content 확인")
        
        //then
        coreDataRepository.fetch { result in
            switch result {
            case .success(let datas):
                XCTAssertEqual(datas.count, 1)
                XCTAssertEqual(datas.first?.contentText, "test1")
                expectation.fulfill()
            case .failure:
                XCTFail("Completion should not return failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func test_updateData_success() {
        //given
        var testData = DiaryReport(id: UUID(), contentText: "test1", createdAt: Date(), weather: CurrentWeather())
        saveDiaryUseCase.createData(testData)
        
        testData.contentText = "updateContent"
        
        let expectation = XCTestExpectation(description: "Error값 확인")
        
        //when
        saveDiaryUseCase.updateData(testData) { error in
            if error == nil {
                //then
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
