//
//  Extensions.swift
//  Red
//
//  Created by Tolga Sarikaya on 19.06.23.
//

import Foundation
import UIKit


extension UIView {
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat {
        return self.frame.origin.x
    }
    
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
    
}

extension UIAlertController {
  public  static func Alert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
         let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
         
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         
         return alertController
     }
       
}

extension UIViewController : UIGestureRecognizerDelegate {
    
  @objc  public func tapGesture() {
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapGesture))
        view.addGestureRecognizer(tap)
        view.endEditing(true)
    }
}

extension UINavigationController {
    public func setBackground() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.systemBlue
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
    
    extension UIViewController {
        func setLightMode() {
            if #available(iOS 13.0, *) {
                overrideUserInterfaceStyle = .light
            }
        }
    }

extension UINavigationController {
    func setNavigationBarTitleColor(_ color: UIColor) {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
}
    




