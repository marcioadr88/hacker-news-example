//
//  AlertUtils.swift
//  Hacker News Example
//
//  Created by Marcio Duarte on 10/24/20.
//

import UIKit

/// Utility to construct Alerts
class AlertUtils {
    
    /// Build a simple alert with title, message and Ok Action
    static func buildAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        return alertController
    }
}
