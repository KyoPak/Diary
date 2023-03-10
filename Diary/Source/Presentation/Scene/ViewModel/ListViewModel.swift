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
    private(set) var cacheUseCase: CheckCacheUseCase
    
    private var diaryReports: [DiaryReport] = [] {
        didSet {
            dataHandler?(diaryReports)
        }
    }
    
    private var filterDiaryReports: [DiaryReport] = [] {
        didSet {
            if filterDiaryReports.isEmpty {
                dataHandler?(diaryReports)
            } else {
                dataHandler?(filterDiaryReports)
            }
        }
    }
    
    private var dataHandler: (([DiaryReport]) -> Void)?
    private var filterDataHandler: (([DiaryReport]) -> Void)?
    
    weak var errorDelegate: ErrorPresentable?
    
    init(
        fetchUseCase: FetchDiaryReportsUseCase,
        deleteUseCase: DeleteDiaryReportUseCase,
        cacheUseCase: CheckCacheUseCase
    ) {
        self.fetchUseCase = fetchUseCase
        self.deleteUseCase = deleteUseCase
        self.cacheUseCase = cacheUseCase
    }
    
    private func fetchData() {
        fetchUseCase.fetchData { result in
            switch result {
            case .success(let datas):
                self.diaryReports = datas
            case .failure(let error):
                self.sendError(error: error)
            }
        }
    }
    
    private func sendError(error: Error) {
        guard let error = error as? DataError else { return }
        errorDelegate?.presentErrorAlert(
            title: error.description,
            message: error.errorDescription ?? ""
        )
    }
}

extension ListViewModel {
    func setup() {
        fetchData()
    }
    
    func bindData(completion: @escaping ([DiaryReport]) -> Void) {
        dataHandler = completion
    }
    
    func setupFilterText(_ text: String) {
        filterDiaryReports = diaryReports.filter({ diaryReport in
            diaryReport.contentText.lowercased().contains(text)
        })
    }
    
    func deleteData(index: Int?) {
        guard let index = index else { return }
        
        let deleteData = diaryReports.remove(at: index)
        
        deleteUseCase.deleteData(id: deleteData.id) { error in
            if let error = error {
                self.sendError(error: error)
            }
        }
    }
    
    func clearFilterData() {
        filterDiaryReports.removeAll()
    }
    
    func fetchSelectData(index: Int?) -> DiaryReport? {
        guard let index = index else { return nil }
        
        return filterDiaryReports.isEmpty ? diaryReports[index] : filterDiaryReports[index]
    }
}
