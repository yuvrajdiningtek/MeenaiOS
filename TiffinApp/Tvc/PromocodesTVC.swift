

import UIKit
import NVActivityIndicatorView
class PromocodesTVC: UITableViewCell {
    enum ButtonType : String{
        case apply = "Apply"
        case remove = "Remove"
    }
    let v = UIViewController()
    @IBOutlet private weak var titleLabel : UILabel!
    @IBOutlet private weak var subtitleLabel : UILabel!
    @IBOutlet private weak var applyBtn : UIButton!
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
            applyBtn.setTitle(btntype.rawValue, for: .normal)
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
        applyBtn.layer.cornerRadius = 5
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
        
        UserDefaults.standard.setValue(true, forKey: "come")
        ProductsApi.add_coupen(rule: dataSet.0) { (succ, rst,err) in
            self.hideLoader()
            if succ{
                NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)
               // DBManager.sharedInstance.database.create(AppliedCoupon.self)
                self.btntype = .remove
                self.coupanLbl.isHidden = false
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.borderWidth = 1
                self.contentView.layer.borderColor = #colorLiteral(red: 0.1084277853, green: 0.5919913054, blue: 0.4029042125, alpha: 1)
                
                 Message.showSuccessmsg(style: .bottom, message: "Coupon Applied Successfully")
                self.v.dismiss(animated: true)
            }
            else{
                Message.showErrorMessage(style: .bottom, message: err , title: "")

                //Message.showErrorOnTopStatusBar(message: err)
            }
        }
    }
    func removeCoupon(){
        self.showLoader()
         UserDefaults.standard.setValue(false, forKey: "come")
        ProductsApi.delete_coupon(rule: dataSet.0) { (succ, rst) in
            self.hideLoader()
            if succ{
                DBManager.sharedInstance.deleteApplyCoupon()
                self.btntype = .apply
                self.coupanLbl.isHidden = true
                self.contentView.layer.cornerRadius = 10
                self.contentView.layer.borderWidth = 1
                self.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

                Message.showErrorOnTopStatusBar(message: "Coupon Removed Successfully")
                self.v.dismiss(animated: true)

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
        
        view.addSubview(activityIndicator!)// or use  webView.addSubview(activityIndicator)
        activityIndicator!.startAnimating()
    }
    func hideLoader(){
        activityIndicator?.removeFromSuperview()
    }
}
