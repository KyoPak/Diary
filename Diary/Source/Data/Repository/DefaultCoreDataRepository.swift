//
//  File.swift
//  Diary
//
//  Created by parkhyo on 2023/02/27.
//

import Foundation

final class DefaultCoreDataRepository {
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    private func convert(from data: DiaryData) -> DiaryReport {
        let weatherData = CurrentWeather(iconID: data.weather?.iconID, main: data.weather?.main)
        
        let diaryReport = DiaryReport(
            id: data.id ?? UUID(),
            contentText: data.contentText ?? "",
            createdAt: data.createdAt ?? Date(),
            weather: weatherData
        )
        
        return diaryReport
    }
}

extension DefaultCoreDataRepository: CoreDataRepository {
    func fetch(completion: @escaping (Result<[DiaryData], DataError>) -> Void) {
        let request = DiaryData.fetchRequest()
        
        let dataOrder = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [dataOrder]
        
        coreDataService.access { context in
            do {
                let dataList = try context.fetch(request)
                completion(.success(dataList))
            } catch {
                completion(.failure(.fetchError))
            }
        }
    }
    
    func create(data: DiaryReport) {
        
        coreDataService.access { context in
            let diaryEntity = DiaryData(context: context)
            
            diaryEntity.id = data.id
            diaryEntity.createdAt = data.createdAt
            diaryEntity.contentText = data.contentText
            
            let weatherEntity = WeatherData(context: context)
            weatherEntity.iconID = data.weather.iconID
            weatherEntity.main = data.weather.main
            
            diaryEntity.weather = weatherEntity
            
            self.coreDataService.saveContext()
        }
    }
    
    func update(id: UUID, contentText: String, completion: @escaping (DataError?) -> Void) {
        let request = DiaryData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        coreDataService.access { context in
            do {
                let fetchedDatas = try context.fetch(request)
                
                if let diaryData = fetchedDatas.first {
                    diaryData.setValue(contentText, forKey: "contentText")
                    completion(nil)
                } else {
                    completion(.fetchError)
                }
            } catch {
                completion(.updateError)
            }
            
            self.coreDataService.saveContext()
        }
    }
    
    func delete(id: UUID, completion: @escaping (DataError?) -> Void) {
        let request = DiaryData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        coreDataService.access { context in
            do {
                let fetchedDatas = try context.fetch(request)
                if let diaryData = fetchedDatas.first {
                    context.delete(diaryData)
                    completion(nil)
                } else {
                    completion(.fetchError)
                }
            } catch {
                completion(.deleteError)
            }
            
            self.coreDataService.saveContext()
        }
    }
}
