//
//  DetailViewModel.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

final class DetailViewModel {
    enum Mode {
        case new
        case edit
    }
    
    private(set) var mode: Mode = .edit
    
    private let fetchWeatherDataUseCase: FetchWeatherDataUseCase
    private let createDiaryDataUseCase: SaveDiaryReportUseCase
    private let deleteUseCase: DeleteDiaryReportUseCase
    private let weatherImageUseCase: LoadWeatherImageUseCase
    
    private var diary: DiaryReport
    
    weak var errorDelegate: ErrorPresentable?
    
    init(
        data: DiaryReport?,
        fetchWeatherDataUseCase: FetchWeatherDataUseCase,
        weatherImageUseCase: LoadWeatherImageUseCase,
        createDiaryUseCase: SaveDiaryReportUseCase,
        delteUseCase: DeleteDiaryReportUseCase
    ) {
        self.fetchWeatherDataUseCase = fetchWeatherDataUseCase
        self.weatherImageUseCase = weatherImageUseCase
        self.createDiaryDataUseCase = createDiaryUseCase
        self.deleteUseCase = delteUseCase
        
        guard let data = data else {
            mode = .new
            diary = DiaryReport(
                id: UUID(),
                contentText: "",
                createdAt: Date(),
                weather: CurrentWeather()
            )
            
            return
        }
        diary = data
    }
    
    private func sendError(error: Error) {
        guard let error = error as? DataError else { return }
        errorDelegate?.presentErrorAlert(
            title: error.description,
            message: error.errorDescription ?? ""
        )
    }
}

extension DetailViewModel {
    func bindData(completion: @escaping (DiaryReport) -> Void) {
        completion(diary)
    }

    func saveData(contents: String) {
        diary.contentText = contents
        
        if mode == .new {
            createDiaryDataUseCase.createData(diary)
            mode = .edit
            return
        }
        
        createDiaryDataUseCase.updateData(diary) { error in
            if let error = error {
                self.sendError(error: error)
            }
        }
    }
    
    func deleteData() {
        deleteUseCase.deleteData(id: diary.id) { error in
            if let error = error {
                self.sendError(error: error)
            }
        }
    }
    
    func deleteDataAfterCheck() {
        guard diary.contentText == "" || diary.contentText ==  checkTextViewPlaceHolder()
        else {
            return
        }
        
        deleteUseCase.deleteData(id: diary.id) { error in
            if let error = error {
                self.sendError(error: error)
            }
        }
    }
    
    func fetchWeatherData(
        lat: String,
        long: String,
        completion: @escaping () -> Void
    ) {
        fetchWeatherDataUseCase.fetchWeatherData(lat: lat, lon: long) { data in
            self.diary.weather = data
            completion()
        }
    }
    
    func fetchImageData(completion: @escaping (Data) -> Void) {
        guard let iconID = diary.weather.iconID else { return }
        weatherImageUseCase.loadImage(id: iconID) { data in
            
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    func fetchDiaryReport() -> DiaryReport {
        return diary
    }
    
    func checkTextViewPlaceHolder() -> String {
        return "오늘의 일기를 입력해주세요."
    }
}
