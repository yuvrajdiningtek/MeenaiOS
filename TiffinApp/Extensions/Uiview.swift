

import UIKit


extension UIView{
    
    func setGradientBackground(colorTop : UIColor,colorBottom : UIColor ) {
        let colorTop =  colorTop.cgColor
        let colorBottom = colorBottom.cgColor
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    func lookForSuperviewOfType<T: UIView>(type: T.Type) -> T? {
        return superview as? T ?? superview?.superviewOfClassType(type) as? T
    }
}
