
import Foundation
import UIKit
class CoupensListTVC:UITableViewCell{
    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var cross_btn: UIButton!
    
    var yourobj : (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func cross_btn(_ sender: Any) {
        if let btnAction = self.yourobj
        {
            btnAction()
        }
    }
}

class DeliveryMethod_TVC : UITableViewCell{
    @IBOutlet weak var delivery_method_name_lbl: UILabel!
    @IBOutlet weak var radioBtn: RadioButton!
    @IBOutlet weak var delivery_method_price_lbl: UILabel!
    @IBOutlet weak var checkImg: UIImageView!

    var obj : (() -> Void)? = nil
    var shippingId = ""
    var dataSet : (String,String,String) =  ("","",""){
        didSet{
            configure()
        }
    }
    func configure(){
        if delivery_method_name_lbl == nil{return}
        delivery_method_price_lbl.text = "(\(dataSet.1))"
        delivery_method_name_lbl.text = dataSet.0
        shippingId = dataSet.2
    }
    
    
    @IBAction func radio_btn(_ sender: RadioButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
        } else{
            
        }
    }
    override func layoutSubviews() {
          super.layoutSubviews()
        
          //set the values for top,left,bottom,right margins
          let margins = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
          contentView.frame = contentView.frame.inset(by: margins)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

class Taxes_TVC : UITableViewCell{
    @IBOutlet weak var title_lbl: UILabel!
    
    @IBOutlet weak var detail_lbl: UILabel!
    var dataSet : (String,String) =  ("",""){
        didSet{
            configure()
        }
    }
    func configure(){
        if title_lbl == nil{return}
        title_lbl.text = dataSet.0
        detail_lbl.text = dataSet.1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

