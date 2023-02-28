//
//  MockCoreDataRepository.swift
//  DiaryTests
//
//  Created by parkhyo on 2023/02/28.
//

import Foundation
import CoreData

final class MockCoreDataRepository: CoreDataRepository {
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()


    var datas: [DiaryData] = []
    var diaryReports: [DiaryReport] = []

    func fetch(completion: @escaping (Result<[DiaryData], DataError>) -> Void) {
        completion(.success(datas))
    }

    func create(data: DiaryReport) {
        var diaryData = DiaryData(context: mockPersistentContainer.viewContext)

        diaryData.id = data.id
        diaryData.contentText = data.contentText
        diaryData.createdAt = data.createdAt

        var weatherData = WeatherData(context: mockPersistentContainer.viewContext)
        weatherData.iconID = data.weather.iconID
        weatherData.main = data.weather.main

        diaryData.weather = weatherData

        datas.append(diaryData)
        diaryReports.append(data)
    }

    func update(id: UUID, contentText: String, completion: @escaping (DataError?) -> Void) {
        var flag = false
        diaryReports.forEach { data in
            if data.id == id {
                flag = true
            }
        }

        if !flag {
            completion(.updateError)
        } else {
            completion(nil)
        }
    }

    func delete(id: UUID, completion: @escaping (DataError?) -> Void) {
        var flag = false
        diaryReports.forEach { data in
            if data.id == id {
                flag = true
            }
        }

        if !flag {
            completion(.deleteError)
        } else {
            completion(nil)
        }
    }
}
