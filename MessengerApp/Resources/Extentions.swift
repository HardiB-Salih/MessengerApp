//
//  Extentions.swift
//  MessengerApp
//
//  Created by HardiB.Salih on 5/7/24.
//

import Foundation
import UIKit


extension UIView {
    /// The width of the view.
    var width: CGFloat {
        return self.frame.size.width
    }
    
    /// The height of the view.
    var height: CGFloat {
        return self.frame.size.height
    }
    
    /// The left edge of the view.
    var left: CGFloat {
        guard let superview = self.superview else {
            return self.frame.origin.x
        }
        return self.frame.origin.x - superview.frame.origin.x
    }
    
    /// The right edge of the view.
    var right: CGFloat {
        return self.left + self.width
    }
    
    /// The top edge of the view.
    var top: CGFloat {
        guard let superview = self.superview else {
            return self.frame.origin.y
        }
        return self.frame.origin.y - superview.frame.origin.y
    }
    
    /// The bottom edge of the view.
    var bottom: CGFloat {
        return self.top + self.height
    }
}

extension UIViewController {
    func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension String {
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}

