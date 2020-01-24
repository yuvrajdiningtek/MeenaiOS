
import Foundation
import UIKit

class BadgeButton : UIButton {
    
    var badgeValue : String! = "" {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override init(frame :CGRect)  {
        // Initialize the UIView
        super.init(frame : frame)
        
        self.awakeFromNib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.awakeFromNib()
    }
    
    
    override func awakeFromNib()
    {
        self.drawBadgeLayer()
    }
    
    var badgeLayer :CAShapeLayer!
    func drawBadgeLayer() {
        
        if self.badgeLayer != nil {
            self.badgeLayer.removeFromSuperlayer()
        }
        
        // Omit layer if text is nil
        if self.badgeValue == nil || self.badgeValue.characters.count == 0 {
            return
        }
        
        //! Initial label text layer
        let labelText = CATextLayer()
        labelText.contentsScale = UIScreen.main.scale
        labelText.string = self.badgeValue.uppercased()
        labelText.fontSize = 9.0
        labelText.font = UIFont.systemFont(ofSize: 9)
        labelText.alignmentMode = CATextLayerAlignmentMode.center
        labelText.foregroundColor = UIColor.white.cgColor
        let labelString = self.badgeValue.uppercased() as String!
        let labelFont = UIFont.systemFont(ofSize: 15) as UIFont!
        
        let attributes = [NSAttributedString.Key.font : labelFont]
        let w = self.frame.size.width
        let h = CGFloat(18.0)  // fixed height
        let labelWidth = CGFloat(18.0)    // Starting point
        
        
        let rect = labelString!.boundingRect(with: CGSize(width: labelWidth, height: h), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil)
        let textWidth = round(rect.width * UIScreen.main.scale)
        labelText.frame = CGRect(x: 0, y: 2.3, width: 18, height: h)
        
        //! Initialize outline, set frame and color
        let shapeLayer = CAShapeLayer()
        shapeLayer.contentsScale = UIScreen.main.scale
        let frame : CGRect = CGRect(x: 0, y: 0, width: 18, height: h)
        let cornerRadius = CGFloat(20.0)
        let borderInset = CGFloat(-1.0)
        let aPath = UIBezierPath(roundedRect: frame.insetBy(dx: borderInset, dy: borderInset), cornerRadius: cornerRadius)
        
        shapeLayer.path = aPath.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1
        
        shapeLayer.insertSublayer(labelText, at: 0)
        
        shapeLayer.frame = shapeLayer.frame.offsetBy(dx: w*0.4, dy: 0.5)
        
        
        self.layer.insertSublayer(shapeLayer, at: 999)
        
        self.layer.masksToBounds = false
        self.badgeLayer = shapeLayer
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.drawBadgeLayer()
        self.setNeedsDisplay()
    }
    
}



@IBDesignable
class RightAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        semanticContentAttribute = .forceRightToLeft
        contentHorizontalAlignment = .left
        
        let availableSpace = bounds.inset(by: contentEdgeInsets)
        let availableWidth = availableSpace.width - imageEdgeInsets.left - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: availableWidth / 2)
    }

   
}
