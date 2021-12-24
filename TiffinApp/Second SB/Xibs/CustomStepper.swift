
import Foundation
import UIKit


 class CustomStepper: UIView{
    
    @IBOutlet var contentV: UIView!

    @IBOutlet weak var currentValue_lbl: UILabel!
    @IBOutlet weak var minus_btn: UIButton!
    @IBOutlet weak var plus_btn: UIButton!
    
    
    @IBInspectable
    public var minValue: CGFloat = 1.0 {
        didSet {
            
        }
    }
    @IBInspectable
    public var maxValue: CGFloat = 100.0 {
        didSet {
            
        }
    }
    @IBInspectable
    public var step: CGFloat = 1.0 {
        didSet {
            
        }
    }
    @IBInspectable
    public var value: CGFloat = 1.0 {
        didSet {
            currentValue = value
            
        }
    }
    
    
    @IBAction func minus_btn(_ sender: Any) {
        if currentValue == minValue{}
        else {
            currentValue = currentValue - step
            delegate!.valueDidChange(current: currentValue, sender: self, increment: false, decrement: true)
            
        }
    }
    
    @IBAction func plus_btn(_ sender: Any) {
        if currentValue == maxValue{}
        else {
            currentValue = currentValue + step
            delegate!.valueDidChange(current: currentValue, sender: self, increment: true, decrement: false)
            
        }
    }
    
    // MARK: - VARIABLES
    var currentValue : CGFloat = 0.0 {
        didSet{
            currentValue_lbl.text = String(describing: Int(currentValue))
        }
    }
    var delegate : CustomStepperDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(){
        Bundle.main.loadNibNamed("CustomStepper", owner: self, options: nil)
        addSubview(contentV)
        contentV.frame = self.bounds
        contentV.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        contentV.layer.borderWidth = 1
        contentV.layer.borderColor = UIColor(named: "MaroonTheme")?.cgColor
        contentV.layer.cornerRadius = 5

    }
}

protocol CustomStepperDelegate{
    func valueDidChange(current value : CGFloat, sender : CustomStepper, increment:Bool,decrement:Bool)
    
}
