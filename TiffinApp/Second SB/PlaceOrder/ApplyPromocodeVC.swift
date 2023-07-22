

import UIKit
import NVActivityIndicatorView

class ApplyPromocodeVC: UIViewController {

    @IBOutlet weak var tableV : UITableView!
    @IBOutlet weak var couponTxtF : UITextField!
    @IBOutlet weak var roundView : UIView!
    @IBOutlet weak var roundView2 : UIView!
//    @IBOutlet weak var blackViewClearIpad: UIView!

    @IBOutlet weak var noCouponLbl : UILabel!

    var tvds : [CouponsModel] = [CouponsModel]()
    var tvdsFor : [CouponsModel] = [CouponsModel]()

   // var appliedCoupon : AppliedCoupon?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if UIDevice.current.userInterfaceIdiom == .pad{
//            blackViewClearIpad.backgroundColor = .clear
//        }
//        self.view.isUserInteractionEnabled = false

         getAlOredrs()
        UserDefaults.standard.setValue(true, forKey: "iscomefromApply")
      //  roundView.roundCorners(corners: [.topLeft,.topRight], radius: 15)
//        roundView.clipsToBounds = true
     //   couponTxtF.layer.borderWidth = 0.5
//        let aps = DBManager.sharedInstance.database.objects(AppliedCoupon.self)
//        appliedCoupon = aps.first
//        self.getCoupons()
//        roundView2.layer.cornerRadius = 15
//        roundView2.clipsToBounds = true
      //  let newBackButton = UIBarButtonItem(image: UIImage(named: "left-arrow"), style: .bordered, target: self, action: #selector(back(sender:)))
       // self.navigationItem.leftBarButtonItem = newBackButton
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
            self.navigationController?.popViewController(animated: true)
          //  self.dismiss(animated: true)
       // }
    }
    
//    @objc func back(sender: UIBarButtonItem) {
//        getAlOredrs()
//        // Perform your custom actions
//        // ...
//        // Go back to the previous ViewController
//        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//        ProductsApi.detail_Cart_Info { (_, _, _) in
//            hideactivityIndicator(activityIndicator: activityIndicator)
//            self.navigationController?.popViewController(animated: true)
//        }
//    }
    
    func getAlOredrs(){
        
        self.view.isUserInteractionEnabled = false
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        ProductsApi.detail_Cart_Info { (success, result,_) in
            
            activityIndicator.stopAnimating()

//            self.view.isUserInteractionEnabled = true

            if success{
                
                
                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let applied_couponss = object?.value(forKey: "applied_coupons") as? [String:String]
                let aa = applied_couponss?.first?.value
                UserDefaults.standard.setValue(aa, forKey: "yess")
                
                let aaKey = applied_couponss?.first?.key
                UserDefaults.standard.setValue(aaKey, forKey: "yessKey")
                
                print("aaaaaaaaa",aaKey)
                
                self.getCoupons()
//                self.tableV.reloadData()
                
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
//        NotificationCenter.default.post(Aname: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

        couponTxtF.resignFirstResponder()
        if couponTxtF.text == nil || couponTxtF.text == "" {return}
        let rule = couponTxtF.text!
        
        Message.showLoaderOnStatusBar()
        ProductsApi.add_coupen(rule: rule) { (succ, rst,err) in
            Message.hideMsgView()
            if succ{

//                if self.appliedCoupon != nil{
//                DBManager.sharedInstance.database.add(self.appliedCoupon!)
//                }
               // NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)
                UserDefaults.standard.setValue(rule, forKey: "yessKey")
                Message.showSuccessmsg(style: .bottom, message: "Coupon Applied Successfully")
                self.dismiss(animated: true)
            }
            else{
               // Message.showErrorOnTopStatusBar(message: err)
                
               // UserDefaults.standard.setValue("", forKey: "yessKey")

                Message.showErrorMessage(style: .bottom, message: err , title: "")

            }
        }
    }

    func getCoupons(){
        let offerNames = UserDefaults.standard.value(forKey: "offerNames") as? [String]
//        self.view.isUserInteractionEnabled = false

//        NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)
        if NetworkManager.isConnectedToInternet(){
            Message.showWarningOnStatusBar(msg: "Fetching your promocodes")
            SomeInformationApi.get_coupons { (succ, modelArr) in
                Message.hideMsgView()
                self.tvds = modelArr
//                print("counttttt",self.tvds.count,offerNames?.count)

                //self.tvdsFor = modelArr
//                if offerNames?.count == self.tvds.count {
//                    self.noCouponLbl.isHidden = false
//                    self.tableV.isHidden = true
//                    self.view.isUserInteractionEnabled = true
//
//                    return
//                }
//
//               else if offerNames?.count == 0 {
//
//                }
//
//                else{
//
//                if self.tvds.count != 0{
//                if offerNames?.count != 0{
//                    for j in 0...self.tvds.count - 1{
//                for i in 0...offerNames!.count - 1{
//                    print("j           ",j,self.tvds.count)
//                    if self.tvds.count != 0{
//
////                    if self.tvds.count - 1 > j {
//                    if self.tvds[j].name == offerNames?[i]{
//                    self.tvds.remove(at: j)
//                    }
//
////                    }
//                    }
//                }
//                }
//                   //self.tvds = self.tvdsFor
//                }
//                }
//                }
                self.view.isUserInteractionEnabled = true

                if self.tvds.count == 0{
                    
                    self.noCouponLbl.isHidden = false
                }
                else{
                   //NotificationCenter.default.post(name: Notification.Name("MoveToCoupon"), object: true, userInfo: nil)

                    self.noCouponLbl.isHidden = true

                }
                                                                                            
                if !succ{
                    self.view.isUserInteractionEnabled = true

//                    Message.showErrorOnTopStatusBar(message: "Oops! some error occur")
                    Message.showErrorMessage(style: .bottom, message: "Oops! some error occur", title: "")

                }
                self.tableV.reloadData()
            }
        }
        else{
            self.view.isUserInteractionEnabled = true

//            Message.showErrorOnTopStatusBar(message: "Oops! Internat Not Working")
            Message.showErrorMessage(style: .bottom, message: "Oops! Internet Not Working", title: "")

        }
    }
    
    @objc func detailAtion(sender: UIButton){
//        getCoupons()
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let index = sender.tag
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hideactivityIndicator(activityIndicator: activityIndicator)

            self.navigationController?.popViewController(animated: true)
       // self.dismiss(animated: true)
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
          //   getAlOredrs2()
            cell.coupanLbl.isHidden = false
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = #colorLiteral(red: 0.1084277853, green: 0.5919913054, blue: 0.4029042125, alpha: 1)
        }
        else {
            // getAlOredrs2()
            cell.coupanLbl.isHidden = true
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        
        cell.applyBtnn.addTarget(self, action: #selector(detailAtion(sender:)), for: .touchUpInside)
        cell.applyBtnn.tag = indexPath.row
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func checkCouponIsAlreadyApplied(name : String)->Bool{
        let appliedCoupon = UserDefaults.standard.value(forKey: "appliedCoupons") as? AppliedCoupon

//        guard let apcoupon = appliedCoupon else{return false}
//        let data = apcoupon.data
        let yessKey = UserDefaults.standard.value(forKey: "yessKey") as? String ?? ""
        print("ddddddd",appliedCoupon)

       // for i in data{
            print("iiiiiii",yessKey,name)
//            if i.key == name{
            if yessKey == name{
                
                
                return true
            }
      //  }
        return false
    }
    
}
