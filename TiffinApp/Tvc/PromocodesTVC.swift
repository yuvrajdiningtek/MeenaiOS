

import UIKit
import NVActivityIndicatorView
class PromocodesTVC: UITableViewCell {
    enum ButtonType : String{
        case apply = "Apply"
        case remove = "Remove"
    }
    
    let v = ApplyPromocodeVC()
    @IBOutlet private weak var titleLabel : UILabel!
    @IBOutlet private weak var subtitleLabel : UILabel!
    @IBOutlet weak var applyBtnn : UIButton!
    @IBOutlet weak var coupanLbl: UILabel!
    
    @IBAction func applyBtn(_ sender : UIButton){
        switch btntype {
        case .apply:
            appCoupon()
        case .remove:
            removeCoupon()
        }
    }
    var tableV : UITableView?
    var btntype : ButtonType = .apply{
        didSet{
            applyBtnn.setTitle(btntype.rawValue, for: .normal)
        }
    }
    var dataSet : (String,String) = ("",""){
        didSet{
            titleLabel.text = dataSet.0
            subtitleLabel.text = dataSet.1
            
        }
    }
    var activityIndicator  : NVActivityIndicatorView?
    override func awakeFromNib() {
        super.awakeFromNib()
        coupanLbl.layer.cornerRadius = 5
        coupanLbl.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        coupanLbl.layer.borderWidth = 0.5
        applyBtnn.layer.cornerRadius = 5
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableV = self.lookForSuperviewOfType(type: UITableView.self)
        
    }
    func appCoupon(){
        self.showLoader()
        self.contentView.isUserInteractionEnabled = false
        UserDefaults.standard.setValue(true, forKey: "come")
        ProductsApi.add_coupen(rule: dataSet.0) { (succ, rst,err) in
            self.hideLoader()
            self.contentView.isUserInteractionEnabled = true

            if succ{
//                NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)
//                var appliedCoupons : AppliedCoupon? = nil
//
//                print("n\nn\\n\nn\\n\n\n\n\n\nn\\nn\n\n\n\n\n\n\\n\n\n-----------",rst,"n\nn\\n\nn\\n\n\n\n\n\nn\\nn\n\n\n\n\n\n\\n\n\n-----------")
//                if let rstt  = rst as? NSDictionary{
//
//                if let appliedcoupons = rstt.value(forKey: "object") as? NSDictionary{
//                    appliedCoupons = AppliedCoupon()
//
//                    for (key,value) in appliedcoupons{
//                        let data = AppliedCouponData(key : (key as? String ?? "" ),value : (value as? String ?? "" ))
//                        appliedCoupons!.data.append(data)
//                    }
//                   // if appliedCoupons != nil{
//                    try! DBManager.sharedInstance.database.write {
//                        DBManager.sharedInstance.database.add(appliedCoupons!)
//                    }
//                   // }
//                }
//                }
//                try! DBManager.sharedInstance.database.write {
//                    DBManager.sharedInstance.database.add(appliedCoupons!)
//                }
                
//                DBManager.sharedInstance.database.add(AppliedCoupon.self)
//                DBManager.sharedInstance.database.create(AppliedCoupon.self)
                self.btntype = .remove
                self.coupanLbl.isHidden = false
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.borderWidth = 1
                self.contentView.layer.borderColor = #colorLiteral(red: 0.1084277853, green: 0.5919913054, blue: 0.4029042125, alpha: 1)
                UserDefaults.standard.setValue(self.dataSet.0, forKey: "yessKey")

                 Message.showSuccessmsg(style: .bottom, message: "Coupon Applied Successfully")
                //self.v.navigationController?.popViewController(animated: true)
            }
            else{
//                UserDefaults.standard.setValue("", forKey: "yessKey")

                Message.showErrorMessage(style: .bottom, message: err , title: "")

                //Message.showErrorOnTopStatusBar(message: err)
            }
        }
    }
    func removeCoupon(){
        let yessKey = UserDefaults.standard.value(forKey: "yessKey") as? String
        self.showLoader()
        self.contentView.isUserInteractionEnabled = false

         UserDefaults.standard.setValue(false, forKey: "come")
        ProductsApi.delete_coupon(rule: yessKey ?? dataSet.0) { (succ, rst) in
            self.hideLoader()
            self.contentView.isUserInteractionEnabled = true

            if succ{
                UserDefaults.standard.setValue("", forKey: "yessKey")

              //  DBManager.sharedInstance.deleteApplyCoupon()
                self.btntype = .apply
                self.coupanLbl.isHidden = true
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.borderWidth = 1
                self.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//                NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

                Message.showErrorOnTopStatusBar(message: "Coupon Removed Successfully")
              //  self.v.dismiss(animated: true)

            }else{
                Message.showErrorOnTopStatusBar(message: "Failed to remove coupon")
            }
        }
    }
   
    
    func showLoader(){
        guard let tv = tableV else{return}
        let vc = tv.viewContainingController()!
        let view = vc.view!
        activityIndicator = loader(at: view, active: .circleStrokeSpin)
        view.isUserInteractionEnabled = false
        view.addSubview(activityIndicator!)// or use  webView.addSubview(activityIndicator)
        activityIndicator!.startAnimating()
    }
    func hideLoader(){
        activityIndicator?.removeFromSuperview()
        guard let tv = tableV else{return}
        let vc = tv.viewContainingController()!
        let view = vc.view!
        view.isUserInteractionEnabled = true

    }
}
