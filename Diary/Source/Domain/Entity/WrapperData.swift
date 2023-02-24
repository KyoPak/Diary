//
//  WrapperData.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//
// This type is used in relation to caching.

import Foundation

class WrapperData {
    var data: Data?
    
    init(data: Data?) {
        self.data = data
    }
}
