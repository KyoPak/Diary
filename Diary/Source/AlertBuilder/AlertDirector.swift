//
//  AlertDirector.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import UIKit

final class AlertDirector {
    private let alert: ConcreteAlertBuilder
    
    init(style: UIAlertController.Style) {
        alert = ConcreteAlertBuilder(style: style)
    }
    
    func setupAlert(title: String, message: String) -> UIAlertController {
        return alert
            .setupTitle(title)
            .setupMessage(message)
            .setupAction(title: "취소", style: .cancel, handler: nil)
            .build()
    }
    
    func setupActionSheet(title: String, message: String) -> UIAlertController {
        return alert
            .setupTitle(title)
            .setupMessage(message)
            .setupAction(title: "취소", style: .cancel, handler: nil)
            .build()
    }
    
    func addAction(title: String,
                   style: UIAlertAction.Style,
                   handler: ((UIAlertAction) -> Void)?
    ) {
        alert.setupAction(title: title, style: style, handler: handler)
    }
}
