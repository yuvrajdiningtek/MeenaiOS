

import UIKit
import NVActivityIndicatorView

class ApplyPromocodeVC: UIViewController {

    @IBOutlet weak var tableV : UITableView!
    @IBOutlet weak var couponTxtF : UITextField!
    @IBOutlet weak var roundView : UIView!
    @IBOutlet weak var roundView2 : UIView!

    @IBOutlet weak var noCouponLbl : UILabel!

    var tvds : [CouponsModel] = [CouponsModel]()
    var appliedCoupon : AppliedCoupon?
    
    override func viewDidLoad() {
        super.viewDidLoad()

         getAlOredrs()
        UserDefaults.standard.setValue(true, forKey: "iscomefromApply")
      //  roundView.roundCorners(corners: [.topLeft,.topRight], radius: 15)
//        roundView.clipsToBounds = true
     //   couponTxtF.layer.borderWidth = 0.5
        let aps = DBManager.sharedInstance.database.objects(AppliedCoupon.self)
        appliedCoupon = aps.first
        self.getCoupons()
        roundView2.layer.cornerRadius = 15
        roundView2.clipsToBounds = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .bordered, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    @IBAction func backk(_ sender : UIButton){
//        NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

        //getAlOredrs()
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
//        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//        ProductsApi.detail_Cart_Info { (_, _, _) in
//            hideactivityIndicator(activityIndicator: activityIndicator)
            self.dismiss(animated: true)
      //  }
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
//        NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

        couponTxtF.resignFirstResponder()
        if couponTxtF.text == nil || couponTxtF.text == "" {return}
        let rule = couponTxtF.text!
        
        Message.showLoaderOnStatusBar()
        ProductsApi.add_coupen(rule: rule) { (succ, rst,err) in
            Message.hideMsgView()
            if succ{
               // NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

                Message.showSuccessmsg(style: .bottom, message: "Coupon Applied")
                self.dismiss(animated: true)
            }
            else{
               // Message.showErrorOnTopStatusBar(message: err)
                
                
                Message.showErrorMessage(style: .bottom, message: err , title: "")

            }
        }
    
    }

    func getCoupons(){

        if NetworkManager.isConnectedToInternet(){
            Message.showWarningOnStatusBar(msg: "Fetching your promocodes")
            SomeInformationApi.get_coupons { (succ, modelArr) in
                Message.hideMsgView()
                self.tvds = modelArr
                if self.tvds.count == 0{
                    self.noCouponLbl.isHidden = false
                }
                else{
                    NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

                    self.noCouponLbl.isHidden = true

                }
                
                if !succ{
//                    Message.showErrorOnTopStatusBar(message: "Oops! some error occur")
                    Message.showErrorMessage(style: .bottom, message: "Oops! some error occur", title: "")

                }
                self.tableV.reloadData()
            }
        }
        else{
//            Message.showErrorOnTopStatusBar(message: "Oops! Internat Not Working")
            Message.showErrorMessage(style: .bottom, message: "Oops! Internat Not Working", title: "")

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
            // getAlOredrs()
            cell.coupanLbl.isHidden = false
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = #colorLiteral(red: 0.1084277853, green: 0.5919913054, blue: 0.4029042125, alpha: 1)
        }
        else {
            // getAlOredrs()
            cell.coupanLbl.isHidden = true
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
