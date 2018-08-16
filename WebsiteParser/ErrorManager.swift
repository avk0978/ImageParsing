//
//  ErrorManager.swift
//  WebsiteParser
//
//  Created by Andrey Kolpakov on 16.08.2018.
//  Copyright © 2018 Andrey Kolpakov. All rights reserved.
//

import Foundation
import UIKit

protocol  ErrorMessage {
    
    func errorMessageAC(_ errorMessage: String) -> UIAlertController
}

extension ErrorMessage {
    
    func errorMessageAC(_ errorMessage: String) -> UIAlertController {
        let ac = UIAlertController(title: "Ошибка",
                                   message: errorMessage,
                                   preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel)
        ac.addAction(ok)
        return ac
    }
    
}

