//
//  MessagePresenter.swift
//  PwrARNav
//
//  Created by Oleksii Furman on 15/10/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

protocol MessagePresenter {
    func presentMessage(title: String, message: String)
}

extension MessagePresenter where Self: UIViewController {
    func presentMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}
