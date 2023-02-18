//
//  CoreDataRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation
import CoreData

final class CoreDataRepository {
    private let modelName = "DiaryData"
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    private lazy var context = persistentContainer.viewContext
    
    func fetchData() -> Result<[DiaryData], DataError> {
        var diaryDataList: [DiaryData] = []
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        
        let dataOrder = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [dataOrder]
        
        do {
            if let dataList = try context.fetch(request) as? [DiaryData] {
                diaryDataList = dataList
            }
        } catch {
            return .failure(.coreDataError)
        }
        
        return .success(diaryDataList)
    }
    
    func saveData(diaryData: CurrentDiary, weatherData: CurrentWeather) throws -> UUID? {
        
        guard let entity = NSEntityDescription.entity(forEntityName: self.modelName,
                                                      in: context) else {
            throw DataError.coreDataError
        }
        guard let content = NSManagedObject(entity: entity,
                                            insertInto: context) as? DiaryData else {
            throw DataError.coreDataError
        }
        
        content.id = UUID()
        content.createdAt = diaryData.createdAt
        content.contentText = diaryData.contentText
        
        let weather = WeatherData(context: context)
        weather.iconID = weatherData.iconID
        weather.main = weatherData.main
        
        content.weather = weather
        
        if context.hasChanges {
            do {
                try context.save()
                return content.id
            } catch {
                throw DataError.coreDataError
            }
        }
        
        return content.id
    }
    
    func updateData(id: UUID, contentText: String) throws {
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let fetchedDatas = try context.fetch(request) as? [DiaryData] else {
                throw DataError.coreDataError
            }
            guard let diaryData = fetchedDatas.first else {
                throw DataError.coreDataError
            }
            
            diaryData.setValue(contentText, forKey: "contentText")
            if context.hasChanges {
                do {
                    try context.save()
                    return
                } catch {
                    throw DataError.coreDataError
                }
            }
        } catch {
            throw DataError.coreDataError
        }
        return
    }

    func deleteData(id: UUID) throws {
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            guard let fetchedDatas = try context.fetch(request) as? [DiaryData] else {
                throw DataError.coreDataError
            }
            guard let diaryData = fetchedDatas.first else {
                throw DataError.coreDataError
            }
            
            context.delete(diaryData)
            
            if context.hasChanges {
                do {
                    try context.save()
                    return
                } catch {
                    throw DataError.coreDataError
                }
            }
        } catch {
            throw DataError.coreDataError
        }
        return
    }
}
