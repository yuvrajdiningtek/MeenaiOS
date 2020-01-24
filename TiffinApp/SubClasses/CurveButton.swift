

import Foundation
import UIKit

@IBDesignable
class CurveButton : UIButton{
    @IBInspectable var isCircle : Bool = false{
        didSet{
            if isCircle{
                
            }
        }
       
    }
    @IBInspectable var cornerCurve : Bool = false
    @IBInspectable var cornerRadius : CGFloat = 0{
        didSet{
            
        }
    }
    @IBInspectable var borderWidth : CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor : UIColor = UIColor.black{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
       
        setview()
    }
    func setview(){
        if isCircle{
            self.frame.size.width = self.frame.size.height
            self.layer.cornerRadius = min(self.frame.width,self.frame.height)/2
        }
        else  if cornerCurve {
            self.layer.cornerRadius = (self.frame.height)/2

        }
        else{
            self.layer.cornerRadius = cornerRadius
        }
       
    }
    
}
