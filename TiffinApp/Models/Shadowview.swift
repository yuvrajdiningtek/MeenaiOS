// https://stackoverflow.com/questions/4754392/uiview-with-rounded-corners-and-drop-shadow
import Foundation
import UIKit

class ShadowView: UIView {
    @IBInspectable public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}


class ShadowButton : UIButton{
    @IBInspectable public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupShadow()
    }
    
    private func setupShadow() {
        
        self.layer.shadowColor = UIColor.MyTheme.graycolor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        

    }
}
