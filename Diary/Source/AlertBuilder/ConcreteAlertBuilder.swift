//
//  ConcreteAlertBuilder.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import UIKit

final class ConcreteAlertBuilder: AlertBuilder {
    var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    
    func setupTitle(_ text: String) -> AlertBuilder {
        alert.title = text
        return self
    }
    
    func setupMessage(_ text: String) -> AlertBuilder {
        alert.message = text
        return self
    }
    
    func setupStyle(_ style: UIAlertController.Style) -> AlertBuilder {
        alert = UIAlertController(title: alert.title, message: alert.message, preferredStyle: style)
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
