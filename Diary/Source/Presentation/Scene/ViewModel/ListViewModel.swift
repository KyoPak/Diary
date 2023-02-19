//
//  ListViewModel.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

final class ListViewModel {
    private let fetchUseCase: FetchDiaryReportsUseCase
    private let deleteUseCase: DeleteDiaryReportUseCase
    
    private var diaryReports: [DiaryReport] = [] {
        didSet {
            dataHandler?(diaryReports)
        }
    }
    
    private var dataHandler: (([DiaryReport]) -> Void)?
    
    init(fetchUseCase: FetchDiaryReportsUseCase, deleteUseCase: DeleteDiaryReportUseCase) {
        self.fetchUseCase = fetchUseCase
        self.deleteUseCase = deleteUseCase
        fetchData()
    }
    
    private func fetchData() {
        let result = fetchUseCase.fetchData()
        
        switch result {
        case .success(let datas):
            diaryReports = datas
        case .failure(let error):
            sendError(error: error)
        }
    }
    
    private func sendError(error: Error) {
        guard let error = error as? DataError else { return }
        print(error)
        // TODO: Delegate 호출하여 얼럿 팝업
    }
}

extension ListViewModel {
    func bindData(completion: @escaping ([DiaryReport]) -> Void) {
        dataHandler = completion
    }
    
    func deleteData(index: Int) {
        let deleteData = diaryReports.remove(at: index)
        
        do {
            try deleteUseCase.deleteData(id: deleteData.id)
        } catch {
            sendError(error: error)
        }
    }
}
