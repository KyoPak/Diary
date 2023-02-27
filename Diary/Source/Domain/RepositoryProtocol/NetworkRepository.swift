//
//  NetworkRepository.swift
//  Diary
//
//  Created by Kyo on 2023/02/20.
//

import Foundation

protocol NetworkRepository {
    func fetch(url: URL, completion: @escaping (Result<Data, SessionError>) -> Void)
}
