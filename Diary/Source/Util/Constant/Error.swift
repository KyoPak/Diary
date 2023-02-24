//
//  Error.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

enum DataError: Error {
    case noneDataError
    case fetchError
    case updateError
    case deleteError
}

enum SessionError: Error {
    case noneDataError
    case networkError
    case decodeError
    case urlError
}

extension DataError: CustomStringConvertible {
    var description: String {
        switch self {
        case .noneDataError:
            return "NoneData Error"
        case .fetchError:
            return "Fetch Error"
        case .updateError:
            return "Update Error"
        case .deleteError:
            return "Delete Error"
        }
    }
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noneDataError:
            return "입력을 확인해주세요."
        case .fetchError:
            return "코어데이터 불러오기 실패"
        case .updateError:
            return "업데이트 및 저장 실패"
        case .deleteError:
            return "삭제 실패"
        }
    }
}
