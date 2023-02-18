//
//  DiaryReport.swift
//  Diary
//
//  Created by Kyo on 2023/02/19.
//

import Foundation

struct DiaryReport {
    var id: UUID
    var contentText: String
    var createdAt: Date
    var weather: CurrentWeather
}
