//
//  ConcreteAlertBuilder.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import UIKit

final class ConcreteAlertBuilder: AlertBuilder {
    var alert: UIAlertController
    
    init(style: UIAlertController.Style) {
        alert = UIAlertController(title: nil, message: nil, preferredStyle: style)
    }
    
    func setupTitle(_ text: String) -> AlertBuilder {
        alert.title = text
        return self
    }
    
    func setupMessage(_ text: String) -> AlertBuilder {
        alert.message = text
        return self
    }
    
    @discardableResult
    func setupAction(
        title: String,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder {
        alert.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    func build() -> UIAlertController {
        return alert
    }
}
