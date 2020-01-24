
import Foundation
import UIKit

@IBDesignable
class BorderedButton : UIButton{
    
    @IBInspectable public var bordercolor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = bordercolor.cgColor
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    // MARK: Initialization
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
