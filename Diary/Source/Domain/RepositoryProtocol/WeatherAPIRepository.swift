//
//  WeatherAPIRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

protocol WeatherAPIRepository {
    func fetch(url: URL, completion: @escaping (Result<Data, SessionError>) -> Void)
}
