//
//  AlertBilder.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import UIKit

protocol AlertBuilder {
    var alert: UIAlertController { get set }
    func setupTitle(_ text: String) -> AlertBuilder
    func setupMessage(_ text: String) -> AlertBuilder
    func setupStyle(_ style: UIAlertController.Style) -> AlertBuilder
    func setupAction(
        title: String,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)?
    ) -> AlertBuilder
    
    func build() -> UIAlertController
}
