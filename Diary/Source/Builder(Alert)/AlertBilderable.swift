//
//  AlertBilderable.swift
//  Diary
//
//  Created by Kyo on 2023/02/24.
//

import UIKit

protocol AlertBuilderable {
    var alert: UIAlertController { get set }
    func setupTitle(_ text: String) -> AlertBuilderable
    func setupMessage(_ text: String) -> AlertBuilderable
    func setupStyle(_ style: UIAlertController.Style) -> AlertBuilderable
    func setupAction(
        title: String,
        style: UIAlertAction.Style,
        handler: ((UIAlertAction) -> Void)?
    ) -> AlertBuilderable
    
    func build() -> UIAlertController
}
