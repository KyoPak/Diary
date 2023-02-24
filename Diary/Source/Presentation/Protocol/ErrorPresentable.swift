//
//  ErrorPresentable.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import Foundation

protocol ErrorPresentable: AnyObject {
    func presentErrorAlert(title: String, message: String)
}
