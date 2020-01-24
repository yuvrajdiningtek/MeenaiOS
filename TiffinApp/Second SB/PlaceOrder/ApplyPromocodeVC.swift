

import UIKit
import NVActivityIndicatorView

class ApplyPromocodeVC: UIViewController {

    @IBOutlet weak var tableV : UITableView!
    @IBOutlet weak var couponTxtF : UITextField!
    var tvds : [CouponsModel] = [CouponsModel]()
    var appliedCoupon : AppliedCoupon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         getAlOredrs()
        UserDefaults.standard.setValue(true, forKey: "iscomefromApply")
       
        
        let aps = DBManager.sharedInstance.database.objects(AppliedCoupon.self)
        appliedCoupon = aps.first
        self.getCoupons()
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .bordered, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @objc func back(sender: UIBarButtonItem) {
        getAlOredrs()
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        ProductsApi.detail_Cart_Info { (_, _, _) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    func getAlOredrs(){
        
        
        
        ProductsApi.detail_Cart_Info { (success, result,_) in
            
            
            if success{
                
                
                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let applied_couponss = object?.value(forKey: "applied_coupons") as? [String:String]
                let aa = applied_couponss?.first?.value
                UserDefaults.standard.setValue(aa, forKey: "yess")
//                self.applied_coupons = applied_couponss
//
//
//                if self.applied_coupons?.count == 0{
//                    self.coupanLBL.text = "Coupon :"
//                }
//                else {
//
//                    let coupanAmount = self.applied_coupons!.first!.value
//                    print(coupanAmount)
//
//
//
//                    self.coupanLBL.text = "Coupon :\nApplied Coupan\nYou saved $\(String(describing: coupanAmount))"
//                }
                
            }
            
            
        }
        
        
        
    }
    
    
    @IBAction func applyCouponBtn(_ sender : UIButton){
        
        
        if couponTxtF.text == nil || couponTxtF.text == "" {return}
        let rule = couponTxtF.text!
        
        Message.showLoaderOnStatusBar()
        ProductsApi.add_coupen(rule: rule) { (succ, rst,err) in
            Message.hideMsgView()
            if succ{
                
                Message.showSuccessmsg(style: .bottom, message: "Coupon Applied")
            }
            else{
                Message.showErrorOnTopStatusBar(message: err)
            }
        }
        
    }

    func getCoupons(){
        if NetworkManager.isConnectedToInternet(){
            Message.showWarningOnStatusBar(msg: "Fetching your promocodes")
            SomeInformationApi.get_coupons { (succ, modelArr) in
                Message.hideMsgView()
                self.tvds = modelArr
                if !succ{
                    Message.showErrorOnTopStatusBar(message: "Oops! some error occur")
                }
                self.tableV.reloadData()
            }
        }
        else{
            Message.showErrorOnTopStatusBar(message: "Oops! Internat Not Working")
        }
    }
}


extension ApplyPromocodeVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PromocodesTVC
        
        let title = (tvds[indexPath.row].name)
        let subtitle = (tvds[indexPath.row].descriptions)
        cell.dataSet = (title,subtitle)
       
        cell.btntype = checkCouponIsAlreadyApplied(name : title) ? .remove : .apply
        if cell.btntype == .remove {
             getAlOredrs()
            cell.coupanLbl.isHidden = false
        }
        else {
             getAlOredrs()
            cell.coupanLbl.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func checkCouponIsAlreadyApplied(name : String)->Bool{
        guard let apcoupon = appliedCoupon else{return false}
        let data = apcoupon.data
        for i in data{
            if i.key == name{
                
                return true
            }
        }        
        return false
    }
    
}
