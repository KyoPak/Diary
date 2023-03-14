//
//  DeleteDiaryReportUseCaseTest.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/02/28.
//

import XCTest

final class DeleteDiaryReportUseCaseTest: XCTestCase {

    var deleteDiaryUseCase: DeleteDiaryReportUseCase!
    var diaryDataRepository: DiaryDataRepository!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        diaryDataRepository = MockDiaryDataRepository()
        deleteDiaryUseCase = DefaultDeleteDiaryReportUseCase(diaryDataRepository: diaryDataRepository)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        diaryDataRepository = nil
        deleteDiaryUseCase = nil
    }
    
    func test_deleteData_success() {
        //given
        let testID = UUID()
        diaryDataRepository.create(
            data: DiaryReport(id: testID, contentText: "test1", createdAt: Date(), weather: CurrentWeather())
        )
        diaryDataRepository.create(
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
        diaryDataRepository.fetch { result in
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
