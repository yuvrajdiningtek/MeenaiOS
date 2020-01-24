

import UIKit
import NVActivityIndicatorView
class PromocodesTVC: UITableViewCell {
    enum ButtonType : String{
        case apply = "Apply"
        case remove = "Remove"
    }
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
                
                self.btntype = .remove
                self.coupanLbl.isHidden = false
            
                
                 Message.showSuccessmsg(style: .bottom, message: "Coupon Applied Successfully")
            }
            else{
                Message.showErrorOnTopStatusBar(message: err)
            }
        }
    }
    func removeCoupon(){
        self.showLoader()
         UserDefaults.standard.setValue(false, forKey: "come")
        ProductsApi.delete_coupon(rule: dataSet.0) { (succ, rst) in
            self.hideLoader()
            if succ{
                self.btntype = .apply
                self.coupanLbl.isHidden = true
                Message.showErrorOnTopStatusBar(message: "Coupon Removed Successfully")
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
