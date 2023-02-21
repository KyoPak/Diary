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
}

extension DetailViewModel {
    func bindData(completion: @escaping (DiaryReport) -> Void) {
        completion(diary)
    }

    func saveData(contents: String) {
        diary.contentText = contents
        
        if mode == .new {
            createDiaryDataUseCase.createData(data: diary)
            mode = .edit
            return
        }
        do {
            try createDiaryDataUseCase.updateData(data: diary)
        } catch {
            print(error)
        }
    }
    
    func deleteData() {
        do {
            try deleteUseCase.deleteData(id: diary.id)
        } catch {
            print(error)
        }
    }
    
    func deleteDataAfterCheck() {
        guard diary.contentText == "" || diary.contentText ==  checkTextViewPlaceHolder()
        else {
            return
        }
        
        do {
            try deleteUseCase.deleteData(id: diary.id)
        } catch {
            print(error)
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
    
    func checkTextViewPlaceHolder() -> String {
        return "오늘의 일기를 입력해주세요."
    }
}
