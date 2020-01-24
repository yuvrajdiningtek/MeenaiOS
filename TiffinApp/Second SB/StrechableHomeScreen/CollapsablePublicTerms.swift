
import Foundation
import UIKit

class CollapsablePublicTerms : NSObject{
    
    let hederViewHeight : CGFloat = 300
    static var topSafeAreaMargin : CGFloat? {
        return (UIApplication.shared.keyWindow?.safeAreaInsets.top)
    }
}
