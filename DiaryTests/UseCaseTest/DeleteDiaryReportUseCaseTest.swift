//
//  DeleteDiaryReportUseCaseTest.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/02/28.
//

import XCTest

final class DeleteDiaryReportUseCaseTest: XCTestCase {

    var deleteDiaryUseCase: DeleteDiaryReportUseCase!
    var coreDataRepository: CoreDataRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        coreDataRepository = MockCoreDataRepository()
        deleteDiaryUseCase = DefaultDeleteDiaryReportUseCase(coreDataRepository: coreDataRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        coreDataRepository = nil
        deleteDiaryUseCase = nil
    }
    
    func test_deleteData_success() {
        //given
        let testID = UUID()
        coreDataRepository.create(
            data: DiaryReport(id: testID, contentText: "test1", createdAt: Date(), weather: CurrentWeather())
        )
        coreDataRepository.create(
            data: DiaryReport(id: UUID(), contentText: "test2", createdAt: Date(), weather: CurrentWeather())
        )
        
        let expectation = XCTestExpectation(description: "삭제 후, Count, Content 확인")
        
        //when
        deleteDiaryUseCase.deleteData(id: testID) { error in
            if error != nil {
                XCTFail("Error ")
            }
        }
        
        //then
        coreDataRepository.fetch { result in
            switch result {
            case .success(let datas):
                XCTAssertEqual(datas.count, 1)
                XCTAssertEqual(datas[0].contentText, "test2")
                expectation.fulfill()
            case .failure:
                XCTFail("Completion should not return failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
