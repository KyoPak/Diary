//
//  CurrentWeatherRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

protocol CurrentWeatherRepository {
    func configureRequest(type: NetworkRequest) throws -> URLRequest
    func fetch(request: URLRequest, completion: @escaping (Result<Data, SessionError>) -> Void)
}
