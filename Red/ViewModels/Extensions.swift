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
