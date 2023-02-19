//
//  Error.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import Foundation

enum DataError: Error {
    case noneDataError
    case noneContentError
    case fetchError
    case coreDataError
    case updateError
    case deleteError
}

enum SessionError: Error {
    case noneDataError
    case networkError
    case decodeError
    case urlError
}

extension DataError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noneDataError:
            return "입력을 확인해주세요."
        case .noneContentError:
            return "제목을 입력해주세요"
        case .coreDataError:
            return "코어데이터 오류"
        case .fetchError:
            return "코어데이터 불러오기 실패"
        case .updateError:
            return "업데이트 실패"
        case .deleteError:
            return "삭제 실패"
        }
    }
}
