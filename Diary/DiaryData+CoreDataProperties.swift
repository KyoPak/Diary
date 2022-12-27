//
//  DiaryData+CoreDataProperties.swift
//  Diary
//
//  Created by parkhyo on 2022/12/26.
//
//

import Foundation
import CoreData

extension DiaryData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiaryData> {
        return NSFetchRequest<DiaryData>(entityName: "DiaryData")
    }

    @NSManaged public var body: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension DiaryData: Identifiable {
}