

import Foundation
import UIKit
// MARK: - UICOLOR
extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
}

extension UIColor {
    struct MyTheme {
//        static var graycolor : UIColor  { return UIColor(hex: 0x9A9A9A) }
                static var graycolor: UIColor { return UIColor(named: "MaroonTheme")! }
//        static var marooncolor: UIColor { return UIColor(hex: 0x1C9767) }
                static var marooncolor: UIColor { return UIColor(named: "MaroonTheme")! }
        
    }
}

extension CGColor {
    
    class func colorWithHex(hex: Int) -> CGColor {
        
        return UIColor(hex: hex).cgColor
        
    }
    
}
