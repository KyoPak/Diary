//
//  CoreDataRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation
import CoreData

final class CoreDataRepository {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
}

extension CoreDataRepository {
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
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataRepository {
    func fetch() -> Result<[DiaryReport], DataError> {
        let request = DiaryData.fetchRequest()
        
        let dataOrder = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [dataOrder]
        
        do {
            let dataList = try context.fetch(request)
            return .success(dataList.map(convert(from:)))
        } catch {
            return .failure(.coreDataError)
        }
    }
    
    func create(data: DiaryReport) throws {
        let diaryEntity = DiaryData(context: context)
        
        diaryEntity.id = data.id
        diaryEntity.createdAt = data.createdAt
        diaryEntity.contentText = data.contentText
        
        let weatherEntity = WeatherData(context: context)
        weatherEntity.iconID = data.weather.main
        weatherEntity.main = data.weather.main
        
        diaryEntity.weather = weatherEntity
        
        saveContext()
    }
    
    func update(id: UUID, contentText: String) throws {
        let request = DiaryData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchedDatas = try context.fetch(request)
            guard let diaryData = fetchedDatas.first else {
                throw DataError.coreDataError
            }
            diaryData.setValue(contentText, forKey: "contentText")
            
            saveContext()
        } catch {
            throw DataError.coreDataError
        }
    }

    func delete(id: UUID) throws {
        let request = DiaryData.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchedDatas = try context.fetch(request)
            guard let diaryData = fetchedDatas.first else {
                throw DataError.coreDataError
            }
            
            context.delete(diaryData)
            saveContext()
        } catch {
            throw DataError.coreDataError
        }
    }
}
