import Foundation

import UIKit
class FloatingBasketView : UIView{
    
    @IBOutlet weak private var contentView : UIView!
    @IBOutlet weak private var amountLbl : UILabel!
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInit()
    }
    var vc : UIViewController{
        return self.viewContainingController()!
    }
    @IBAction func didtap(_ sender : UIButton){
        
        guard let nc = self.viewContainingController()?.navigationController else{return}
        let vc = secondSBVC("MyCartVC")
        nc.pushViewController(vc, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    override func layoutSubviews() {
        
        let model = UIDevice.current.model
        if model.lowercased() == "iPhone".lowercased(){
            self.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else{
            self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        super.layoutSubviews()
    }
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if cartbadgevalue == "" || cartbadgevalue == "0"{
            self.isHidden = true
        }else{
            self.isHidden = false
        }
        
        
        self.setAmount()
    }
    
    func commonInit(){
        
        Bundle.main.loadNibNamed("FloatingBasketView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
    }
    
    func setAmount(){
        
        let rstCartd = DBManager.sharedInstance.get_CartData_DataFromDB()
        if rstCartd.count>0{
            let amount = rstCartd.first?.object?.sub_total
            let price = cleanDollars(String(amount ?? 0))
            self.amountLbl.text = price
        }
    }
    
}
