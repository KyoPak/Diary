//
//  ViewIdentifiable.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import UIKit

protocol ViewIdentifiable where Self: UIView { }

extension ViewIdentifiable {
    static var identifiable: String {
        return String.init(describing: self)
    }
}
