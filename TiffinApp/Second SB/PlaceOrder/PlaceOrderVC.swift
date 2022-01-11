

import Foundation
import UIKit
import Stripe
import SCLAlertView
//import SwiftyMenu
//import iOSDropDown
import IQKeyboardManagerSwift
var addressIds = [String]()
class PlaceOrderVC : UIViewController,CustomStepperDelegate{
    var orderData = CartData()

    var rowselcted : (Bool,IndexPath)?
    var already_applied_coupons : [String:String]?

  //  private let items: [SwiftyMenuDisplayable] = ["Option 1"]
    var items = [ItemsObjectOrdersData]()

    var roles = [String]()
    var itemss = [String]()
    
    var selectedTable = String()
    let dine = UserDefaults.standard.value(forKey: "dine") as? String
    
//    @IBOutlet weak var itemsTableV : ProductsTV!
    @IBOutlet weak var itemsTableV : UITableView!

    @IBOutlet weak var itemsTableVHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var taxesTableV : TaxesTV!
    @IBOutlet weak var taxesTableVHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var deliveryMethodTableV : DeliveryMethodTV!
    @IBOutlet weak var deliveryMethodTableVHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UIView!
    @IBOutlet weak var tableTF: UITextField!
    @IBOutlet weak var enterCarDetailTF: UITextField!
    
   // @IBOutlet weak var dropDown: DropDown!
    
    //  @IBOutlet weak var tablesDrop: SwiftyMenu!
    
    @IBOutlet weak var subTotalLbl : UILabel!
    @IBOutlet weak var totalItemsLbl : UILabel!
    @IBOutlet weak var totalAmountLbl : UILabel!
    @IBOutlet weak var coupanLBL: UILabel!
    
    @IBOutlet weak var couponApplyBtn : UIButton!
    @IBOutlet weak var couponBtn : UIButton!
    @IBOutlet weak var placeOrderBtn : UIButton!
    @IBOutlet weak var placeOrderView : UIView!

    @IBOutlet weak var totalPriceLblPlace : UILabel!

    @IBOutlet weak var couponRateLbl : UILabel!
    
    @IBOutlet weak var selectedTableLbl: UILabel!
    
    @IBAction func coupon(_ sender : UIButton){
        //        if couponHandle != nil{
        //            couponHandle.showDropDown()
        //        }
        let vc = secondSBVC("ApplyPromocodeVC") as! ApplyPromocodeVC
      //  vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)

//        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func backbtn(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteAllCart(_ sender : UIButton){
        let alert = UIAlertController(title: "Delete Cart", message: "Are you sure you want to delete cart?",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { _ in
            self.deleteWholeCart()

        }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                      self.dismiss(animated: true)
        }))

        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func applycoupon(_ sender : UIButton){
        if couponHandle != nil{
            couponHandle.applyCoupon()
        }
        
    }
    
    @IBOutlet weak var tipPriceLbl : UILabel!
    @IBOutlet weak var tipBtn : UIButton!
    @IBAction func tipBtn(_ sender : UIButton){
        
      
           
            Message.addTipView { (rate) in
                
                if rate == "Custom Fees"{
                    let customTip = UserDefaults.standard.value(forKey: "customTip") as? String
                    
                    self.tipBtn.setTitle((customTip ?? "0") + "%", for: UIControl.State.normal)
                    self.tipPriceLbl.text = self.viewModel.getTipAmount(rate: customTip ?? "0")
                }
                else{
                
                     self.tipBtn.setTitle(rate + "%", for: UIControl.State.normal)
                     self.tipPriceLbl.text = self.viewModel.getTipAmount(rate: rate)
                 }
        }
     
        //        if tipHandle != nil{
        //            tipHandle.showDropDown()
        //        }
    }
    
    
    @IBOutlet  var deliveryAddBtns: [UIButton]!
    @IBOutlet  var deliveryAddLbl: [UILabel]!
    
    
    
    @IBAction func addnewDeliveryAdd_btn(_ sender: Any) {
        
        let vc = secondSBVC("EditCreateAddressVC") as! EditCreateAddressVC
        vc.update = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func deliveryTo_existingAddBtnAction(_ sender: Any) {
        
        let vc = secondSBVC("ExistingAddressVC") as! ExistingAddressVC
        vc.addressSelect = {
            add in
            let halfadd = add.address1 + add.address2 + ","
            
            self.deliveryAddLbl.last?.text = halfadd + add.city
            self.addressModel = add
            self.placeOrderModel.addressId = add.address_id
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBOutlet weak var noteTxtF : UITextField!
    @IBOutlet weak var noteLblTopConstraint : NSLayoutConstraint!
    @IBAction func placeOrder(_ sender : UIButton){
        if self.setPlaceOrderCredential(){
            //--------
//            let vc = secondSBVC("BillSummaryVC") as! BillSummaryVC
//
//            let showCar = UserDefaults.standard.value(forKey: "showCar") as? Bool
//            let pickup = UserDefaults.standard.value(forKey: "pickup") as? Bool
//             let local = UserDefaults.standard.value(forKey: "local") as? Bool
//            let showTables = UserDefaults.standard.value(forKey: "showTables") as? Bool
//
//            if showCar == true{
//
//                if enterCarDetailTF.text == ""{
//                    showAlert(msg: "Vehicle Details Required!", title: "")
//                }
//                else{
//
//
//                if noteTxtF.text != ""{
//                    noteTxtF.text = "\(noteTxtF.text ?? "") \(enterCarDetailTF.text ?? "")"
//
//                    placeOrderModel.notes = noteTxtF.text ?? ""
//
//                    vc.placeOrderModel = placeOrderModel
//                               self.navigationController?.pushViewController(vc, animated: true)
//                }
//                else{
//                     noteTxtF.text =  "\(enterCarDetailTF.text ?? "")"
//
//                    placeOrderModel.notes = noteTxtF.text ?? ""
//
//                                vc.placeOrderModel = placeOrderModel
//                               self.navigationController?.pushViewController(vc, animated: true)
//                }
//                }
//
//            }
//
//            if showTables == true{
//
//
//
//
//            if selectedTable != ""{
//                                       noteTxtF.text = "\(noteTxtF.text ?? "")\(selectedTable)"
//
//                placeOrderModel.notes = noteTxtF.text ?? ""
//
//
//                                vc.placeOrderModel = placeOrderModel
//                           self.navigationController?.pushViewController(vc, animated: true)
//
//                                 }
//            else{
//                  showAlert(msg: "Table Number is Required!", title: "")
//                }
//
//
//
//            }
//            if pickup == true{
//                 vc.placeOrderModel = placeOrderModel
//                 self.navigationController?.pushViewController(vc, animated: true)
//            }
//            if local == true{
//                vc.placeOrderModel = placeOrderModel
//                               self.navigationController?.pushViewController(vc, animated: true)
//            }
//

            //NEWWWW
            
            self.goToNextScreen()
            
            //NEWWWWW
            
            
            
        }
        //--------
    }
    
  
    
    //        if deliveryAddLbl.last?.text == "" {
    //
    //            let deliveryAddString = deliveryAddLbl!.first?.text!
    //            print(deliveryAddString!)
    //
    //            let alertController4 = UIAlertController(title: "Please fill \(deliveryAddString!) details",message:nil,preferredStyle:.alert)
    //            alertController4.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 0.7137254902, green: 0.3294117647, blue: 0.3254901961, alpha: 1)
    //
    //            let myString  = "Please fill \(deliveryAddString!) details"
    //            var myMutableString = NSMutableAttributedString()
    //            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
    //            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:myString.count))
    //            alertController4.setValue(myMutableString, forKey: "attributedTitle"); self.present(alertController4,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
    //                self.dismiss(animated: true, completion: nil)
    //            })})
    //        }
    //        else {
    //
    //            if self.setPlaceOrderCredential(){
    //                let vc = secondSBVC("BillSummaryVC") as! BillSummaryVC
    //                vc.placeOrderModel = placeOrderModel
    //                self.navigationController?.pushViewController(vc, animated: true)
    //            }
    //        }
    //    }
    var applied_coupons : [String:String]?
    
    let viewModel = PlaceOrderViewModel()
    var couponHandle : CouponsHandle!
    var tipHandle : TipHandle!
    var addressModel : DataAdressModel?{
        didSet{
            if addressModel != nil{
                
                if addressModel!.stateName == "" {
                    let halfadd = addressModel!.address1 + "\n" + addressModel!.address2
                    self.deliveryAddLbl.last?.text = halfadd + "\n" + addressModel!.city + "" + addressModel!.stateName + "," + addressModel!.postalCode + "\n" + addressModel!.mobileNumber + "\n" + addressModel!.email
                    placeOrderModel.addressId = addressModel!.address_id
                }
                else{
                
                let halfadd = addressModel!.address1 + "\n" + addressModel!.address2
                self.deliveryAddLbl.last?.text = halfadd + "\n" + addressModel!.city + "," + addressModel!.stateName + "," + addressModel!.postalCode + "\n" + addressModel!.mobileNumber + "\n" + addressModel!.email
                placeOrderModel.addressId = addressModel!.address_id
            }
            }}
    }
    
    var placeOrderModel = PlaceOrderModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        placeOrderBtn.layer.cornerRadius = 15
        placeOrderView.layer.cornerRadius = 15
        NotificationCenter.default.addObserver(self, selector: #selector(afterCoupon), name: Notification.Name("MoveToCoupon"), object: nil)
        UserDefaults.standard.setValue(false, forKey: "iscomefromApply")

        self.itemsTableV.dataSource = self
        self.itemsTableV.delegate = self
//        self.tableView.isHidden = true
//        //self.enterCarDetailTF.isHidden = true
//
//
////        self.tableTF.endEditing(true)
////
////        tableTF.resignFirstResponder()
//
//        let showCar = UserDefaults.standard.value(forKey: "showCar") as? Bool
//
//         let showTables = UserDefaults.standard.value(forKey: "showTables") as? Bool
//        if showTables == true{
//                                       self.tableView.isHidden = false
//             self.selectedTableLbl.isHidden = false
//                                        }
//                                        else{
//                                       self.tableView.isHidden = true
//                                         self.selectedTableLbl.isHidden = true
//
//
//
//                                        }
//
//        if showCar == true{
//            self.tableView.isHidden = false
//            self.tableTF.isHidden = true
//            self.selectedTableLbl.isHidden = true
//            self.enterCarDetailTF.isHidden = false
//        }
//        else if showTables == true{
//            self.tableView.isHidden = false
//            self.selectedTableLbl.isHidden = false
//
//
//             self.tableTF.isHidden = false
//
//        }
//                    else{
//                    self.tableView.isHidden = true
//                    self.selectedTableLbl.isHidden = true
//
//                                                                  }
//        //roles = ["1","2","3","4"]
//
//
//
//
//        print(dine)
////
//        if dine != nil{
//
//        let f = dine!.split(separator: "|").map { (sub) in
//                return String(sub)
//            }
//            itemss += f
//        }
//        else{
//            itemss = [""]
//        }
////        self.dropDown.optionArray = self.itemss
////
//////        self.dropDown.endEditing(true)
//////        self.dropDown.resignFirstResponder()
////                   self.dropDown.selectedRowColor = #colorLiteral(red: 0.0002273604021, green: 0.7907080605, blue: 0.8936147837, alpha: 1)
////                   self.dropDown.isSearchEnable = true
////                   self.dropDown.rowHeight = 40
////                   self.dropDown.listHeight = 400
////                   self.dropDown.hideOptionsWhenSelect = true
////                   self.dropDown.arrowColor = #colorLiteral(red: 0.0001785887117, green: 0.6210911513, blue: 0.7019230769, alpha: 1)
////      //  self.dropDown.handleKeyboard = false
////
////                   self.dropDown.didSelect{(selectedText , index ,id) in
////
////
////
////
////                    self.selectedTableLbl.text = " #\(self.itemss[index])"
////
////                    self.selectedTable = " #\(self.itemss[index])"
////
////
////                  //  self.tableTF.text = "Selected Table : #\(self.itemss[index])"
////
//////                    if self.noteTxtF.text != ""{
//////                        self.noteTxtF.text = "\(self.noteTxtF.text ?? "") #\(self.itemss[index])"
//////                    }
////
////
//////                    if self.noteTxtF.text?.contains("#") == true{
//////
//////                        if self.noteTxtF.text?.first == "#"{
//////                           self.noteTxtF.text = " #\(self.itemss[index])"
//////                        }
//////                        else{
//////                       let s1 = self.noteTxtF.text?.split(separator: "#")
//////
//////                        let s = s1?[0] ?? ""
//////
//////                        self.noteTxtF.text = ""
//////                        self.noteTxtF.text = (s) + " #\(self.itemss[index])"
//////                    }
//////                    }
//////
//////
//////                    else{
//////
//////                    self.noteTxtF.text = " #\(self.itemss[index])"
//////                    }
////
////
//////                                     if self.noteTxtF.text?.contains("#") == false{
//////
//////                                         self.noteTxtF.text = "\(self.noteTxtF.text ?? "") #\(self.itemss[index])"
//////                                     }
//////
////
////        }
//
//
//
//        // Give array of items to SwiftyMenu
////        tablesDrop.items = items
////         tablesDrop.delegate = self
//        itemsTableV.isScrollEnabled = true
     
//        itemsTableV.frame.size = itemsTableV.contentSize
        //        visibleAddress(visibility: false)
    }
   
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        tableView.endEditing(true)
//        super.touchesBegan(touches, with: event)
//    }
   
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewDidLayoutSubviews()
//        updateViewConstraints()
//        itemsTableV.reloadData()
        IQKeyboardManager.shared.enableAutoToolbar = true
        tableTF.inputView = UIView()
        
        noteTxtF.text = ""
        //
        initialSetUp()
    }
    override func viewDidDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    //    func getAlOredrs(){
    //
    //
    //
    //        ProductsApi.detail_Cart_Info { (success, result,_) in
    //
    //
    //            if success{
    //
    //
    //                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
    //                let applied_couponss = object?.value(forKey: "applied_coupons") as? [String:String]
    //
    //                UserDefaults.standard.setValue(applied_couponss, forKey: "yess")
    //                //                self.applied_coupons = applied_couponss
    //                //
    //                //
    //                //                if self.applied_coupons?.count == 0{
    //                //                    self.coupanLBL.text = "Coupon :"
    //                //                }
    //                //                else {
    //                //
    //                //                    let coupanAmount = self.applied_coupons!.first!.value
    //                //                    print(coupanAmount)
    //                //
    //                //
    //                //
    //                //                    self.coupanLBL.text = "Coupon :\nApplied Coupan\nYou saved $\(String(describing: coupanAmount))"
    //                //                }
    //
    //            }
    //
    //
    //        }
    //
    //
    //
    //    }
    
    
  @objc func afterCoupon(){
    deliveryMethodTableV.isScrollEnabled = false
        self.getAlOredrsAFTERCOUPON(completion: {
            
            (succ,error) in
            
            if !succ{
                print("eeeeeeeeeeeee",error)

                print(error)
                if (error?.contains("INVALID") ?? false) || (error?.contains("Invalid") ?? false) {
                    self.deleteInvAlidBucket()
                    return
                    
                }
                
                SCLAlertView().showError("error", subTitle: error ?? "Some error occur") // Error
            }
            else{
                
            }
            
        })
    }
    
    func initialSetUp(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
      //  setTableViewData()
        // after setting tableview data refrsh address
       // visibleAddress(visibility: false)
        
        NetworkManager.isUnreachable { (_) in
            SCLAlertView().showError("network unreachable")
        }
        NetworkManager.isReachable { (_) in
            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
            self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
//            self.itemsTableV.isHidden = false
            self.getAlOredrs(completion: {
                
                (succ,error) in
                
                //self.setUI()
                hideactivityIndicator(activityIndicator: activityIndicator)
                
                if !succ{
                    print("eeeeeeeeeeeee",error)

                    print(error)
                    if (error?.contains("INVALID") ?? false) || (error?.contains("Invalid") ?? false) {
                        self.deleteInvAlidBucket()
                        return
                        
                    }
                    
                    SCLAlertView().showError("error", subTitle: error ?? "Some error occur") // Error
                }
                else{
                }
                
            })
        }
        
        
//        self.setUI()
        
    }
    
    func setUpAccordingToUser(){
        if !isUserLoggedIn {
            visibleAddress(visibility: false)
        }
    }
    func visibleAddress(visibility : Bool){
        var show = visibility
        if !isUserLoggedIn{
            show = false
        }
        else{
            show = true
        }
        
        for i in deliveryAddBtns{
            
            
            i.isHidden = !show
        }
        
      
        
        if isUserLoggedIn && (deliveryMethodTableV.pickUpid == (deliveryMethodTableV.selectedid ?? "")){
            deliveryAddLbl.first?.text = "Billing Address"
            
            UserDefaults.standard.setValue(deliveryAddLbl.first?.text, forKey: "AddressKind")
        }

        else{
            deliveryAddLbl.first?.text = "Billing Address"//"Restaurant Address"
            UserDefaults.standard.setValue(deliveryAddLbl.first?.text, forKey: "AddressKind")
        }
        if !isUserLoggedIn {
            if !isUserLoggedIn && (deliveryMethodTableV.pickUpid == (deliveryMethodTableV.selectedid ?? "")){
                deliveryAddLbl.first?.text = "Billing Address"
                UserDefaults.standard.setValue(deliveryAddLbl.first?.text, forKey: "AddressKind")
                for i in deliveryAddLbl{
                    i.isHidden = true
                }
            }
            else {
                deliveryAddLbl.first?.text = "Billing Address"//"Restaurant Address"
                UserDefaults.standard.setValue(deliveryAddLbl.first?.text, forKey: "AddressKind")
                for i in deliveryAddLbl{
                    i.isHidden = true
                }
            }
            noteLblTopConstraint.constant = show ? 0 : -170
        }
        let showTables = UserDefaults.standard.value(forKey: "showTables") as? Bool
          let showCar = UserDefaults.standard.value(forKey: "showCar") as? Bool
        
        if showTables == true{
                                self.tableView.isHidden = false
            self.selectedTableLbl.isHidden = false

                                 }
                                 else{
                                self.tableView.isHidden = true
            self.selectedTableLbl.isHidden = true

                                 }
        
        if showCar == true{
                  self.tableView.isHidden = false
                  //self.tableTF.isHidden = true
            self.selectedTableLbl.isHidden = true

            
              }
                           else if showTables == true{
                                                           self.tableView.isHidden = false
            
                          //  self.tableTF.isHidden = false
                        self.selectedTableLbl.isHidden = false

            
            
                                                            }
                                                            else{
                                                           self.tableView.isHidden = true
            
            
                                                            }
              
    }
    
    
        override func viewDidLayoutSubviews() {
           // Dynamically resize the table to fit the number of cells
           // Scrolling is turned off on the table in InterfaceBuilder
               itemsTableV.frame.size = itemsTableV.contentSize
               itemsTableVHeightConstraint.constant = itemsTableV.frame.height
//           }
     //   super.viewDidLayoutSubviews()
        
    }
    override func updateViewConstraints() {
        itemsTableVHeightConstraint.constant = itemsTableV.contentSize.height

        super.updateViewConstraints()
    }
    
}
extension PlaceOrderVC{
    
    
    func setTableViewDataAfterCoupon(){
        let v = viewModel.getCartDataFromDB().1
   //     itemsTableV.reloadData()
        self.viewDidLayoutSubviews()
        setUI()
    }
    func setTableViewData(){
        let v = viewModel.getCartDataFromDB().1
//        itemsTableV.reloadData()
        self.viewDidLayoutSubviews()
        
        if let obj = viewModel.cartData.object{
            taxesTableV.dataset = obj
            taxesTableVHeightConstraint.constant = CGFloat(taxesTableV.numberOfRows * 44)
            
            deliveryMethodTableV.dataset = obj
            deliveryMethodTableVHeightConstraint.constant = CGFloat(deliveryMethodTableV.numberOfRows * 44)
            deliveryMethodTableV.didChangeValueOfSelecteId = {
                (ispickup) in
                
                
              
                self.visibleAddress(visibility: !ispickup)
                self.placeOrderModel.addressId = ispickup ? self.viewModel.shiPPingIdPickUp() : nil
            }
            
            var vis = false
            if deliveryMethodTableV.userselected_shippingMethod == ""{
                vis = true
                
                
            }
                
                
            else{
                vis =  (deliveryMethodTableV.userselected_shippingMethod == deliveryMethodTableV.pickUpid)
            }
            
            self.placeOrderModel.addressId = vis ? deliveryMethodTableV.pickUpid : self.placeOrderModel.addressId
            // self.visibleAddress(visibility: !vis)
            
            //            self.tipHandle = TipHandle(dropdownanchorBtn: tipBtn, priceLbl: tipPriceLbl, cartdata: obj)
        }
        setUI()
    }
    func setUI(){
        subTotalLbl.text = viewModel.getSubTotal()
        totalItemsLbl.text = viewModel.get_total_items()
        totalAmountLbl.text = viewModel.getTotalPrice()
        totalPriceLblPlace.text = "\(viewModel.getTotalPrice())"
//        placeOrderBtn.setTitle("PLACE ORDER :  \(viewModel.getTotalPrice())", for: .normal)
        couponBtn.setTitle(viewModel.getAppliedCoupon().0, for: .normal)
        couponApplyBtn.setTitle(viewModel.getAppliedCoupon().1, for: .normal)
        
        let (tiprate,tipamount) = viewModel.getTiprateAndAmount()
        tipBtn.setTitle(tiprate, for: .normal)
        tipPriceLbl.text = tipamount
        
        
        let iscomefromApply = UserDefaults.standard.value(forKey: "iscomefromApply") as? Bool
        let come = UserDefaults.standard.value(forKey: "come") as? Bool
        let savedCouponValue = UserDefaults.standard.value(forKey: "yess") as? String ?? "0.0"
        if iscomefromApply == true {
            if come == true {
                
                if already_applied_coupons?.count == 0{
                    coupanLBL.text = "Coupon :\nApplied Coupon\nYou saved $\(savedCouponValue)"
                }
                else {
                    if already_applied_coupons != nil{
                    let coupanAmount = already_applied_coupons!.first!.value
                    print(coupanAmount)
                    
                    
                    
                    coupanLBL.text = "Coupon :\nApplied Coupon\nYou saved $\(String(describing: coupanAmount))"
                }
                }
            }
            else {
                coupanLBL.text = "Coupon :"
            }
        }
        else {
            
            if already_applied_coupons?.count == 0{
                coupanLBL.text = "Coupon :"
            }
            else {
                
                if already_applied_coupons != nil{
                let coupanAmount = already_applied_coupons!.first!.value
                print(coupanAmount)
                
                coupanLBL.text = "Coupon :\nApplied Coupon\nYou saved $\(String(describing: coupanAmount))"
                }
                else{
                    coupanLBL.text = "Coupon :\nApplied Coupon\nYou saved $\(String(describing: "0"))"

                }
            }
        }
       // setTableViewData()
        
        //        couponHandle = CouponsHandle(applybtn: couponApplyBtn,dropdownanchorBtn : couponBtn, couponrateLbl: couponRateLbl, appliedCoupon: applied_coupons)
    }
    //======
    func attributesHeadingg()->[NSAttributedString.Key: Any]{
        let font = UIFont(name: "GlacialIndifference-Bold", size: 14)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.black,
        ]
        return attributes
    }
    func attributesSubHeadingg()->[NSAttributedString.Key: Any]{
        let font = UIFont(name: "GlacialIndifference-Regular", size: 12)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.green,
        ]
        return attributes
    }
    //========
    func setPlaceOrderCredential()->Bool{
        
        if (isUserLoggedIn  ){
            if (deliveryMethodTableV.userselected_shippingMethod == ""){
                Message.showWarningOnStatusBar(msg: "Please select Service Category")
                return false
            }
            if addressModel == nil {
                self.showAlertForAddress()
                
                return false
            }
            print(addressModel?.description,"----------000")
            if addressModel?.description.contains("invalid object") == false{
                print("yo yo")
                
                let addressID = UserDefaults.standard.value(forKey: "add_id") as? String
                if addressID == addressModel?.address_id {
                    let alertController4 = UIAlertController(title: "Selected address is deleted. Please select another address",message:nil,preferredStyle:.alert)
                    alertController4.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor =  UIColor.red
                    
                    let myString  = "Selected address is deleted or removed. Please select another one"
                    var myMutableString = NSMutableAttributedString()
                    myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
                    myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:myString.count))
                    alertController4.setValue(myMutableString, forKey: "attributedTitle"); self.present(alertController4,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                        self.dismiss(animated: true, completion: nil)
                    })})

                }
                else{
                    placeOrderModel.addressId = addressModel?.address_id

                }
                
            }
            else{
                
                let alertController4 = UIAlertController(title: "Selected address is deleted. Please select another address",message:nil,preferredStyle:.alert)
                alertController4.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor =  UIColor.red
                
                let myString  = "Selected address is deleted or removed. Please select another one"
                var myMutableString = NSMutableAttributedString()
                myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
                myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:myString.count))
                alertController4.setValue(myMutableString, forKey: "attributedTitle"); self.present(alertController4,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
                    self.dismiss(animated: true, completion: nil)
                })})

                print("yo NO")
            }
//        }
          //  placeOrderModel.addressId = addressModel?.address_id
        }
            
        else if !isUserLoggedIn   {
            if (deliveryMethodTableV.userselected_shippingMethod == ""){
                
                Message.showWarningOnStatusBar(msg: "Please select Service Category")
                return false
            }
            else if (deliveryMethodTableV.pickUpid == (deliveryMethodTableV.userselected_shippingMethod )){
                placeOrderModel.addressId = ""
            }
            else  {
                placeOrderModel.addressId = ""
            }
            
        }
        
        
        placeOrderModel.notes = noteTxtF.text ?? ""
        placeOrderModel.orderDate = Date.getCurrentDate()
        placeOrderModel.orderTime = Date.getCurrentTime()
        let (gateway,paymnttype) = viewModel.getgateWayId_payemntType()
        placeOrderModel.gatewayId = gateway
        placeOrderModel.paymentType = paymnttype
        return true
        //        self.goToCardScreen()
    }
    func showAlertForAddress(){
        
        let deliveryAddString = deliveryAddLbl?.first?.text ?? "Restaurant"
        
        let alertController4 = UIAlertController(title: "Please fill \(deliveryAddString) details",message:nil,preferredStyle:.alert)
        alertController4.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor =  UIColor.red
        
        let myString  = "Please fill \(deliveryAddString) details"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "GlacialIndifference-Regular", size: 16.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:myString.count))
        alertController4.setValue(myMutableString, forKey: "attributedTitle"); self.present(alertController4,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 1, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })})
    }
    
    
    func goToCardScreen(){
        let addCardViewController = STPAddCardViewController()
        self.navigationController?.navigationBar.barTintColor = UIColor.MyTheme.marooncolor
        addCardViewController.title = "Pay "
        
        addCardViewController.delegate = self
        addCardViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        addCardViewController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        addCardViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        
        
        //        Stripe.setDefaultPublishableKey("pk_test_IkvHgAPOhO9A64esd1re")
        
        self.navigationController?.pushViewController(addCardViewController, animated: true)
        
    }
    
}
//extension PlaceOrderVC : STPAddCardViewControllerDelegate{
//
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//        self.view.endEditing(true)
//
//        navigationController?.popViewController(animated: true)
//    }
//
//    func addCardViewController(_ addCardViewController: STPAddCardViewController,
//                               didCreateToken token: STPToken,
//                               completion: @escaping STPErrorBlock) {
//        print("stripe token \(token)")
//        self.navigationController?.popViewController(animated: true)
//        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_ID)
//        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_cost)
//        placeOrderModel.cardToken = token.tokenId
//        self.goToNextScreen()
//    }
//
//    func goToNextScreen(){
//        if isUserLoggedIn{
//
//            let vc = secondSBVC("ProcessingPaymentScreen") as! ProcessingPaymentScreen
//            vc.placeOrderModel = placeOrderModel
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//        else{
//            let vc = secondSBVC("GuestUserDetailForm") as!  GuestUserDetailForm
//            vc.placeOrderModel = placeOrderModel
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//
//    }
//
//

//}
//extension String: SwiftyMenuDisplayable {
//    public var displayableValue: String {
//        return self
//    }
//
//    public var retrivableValue: Any {
//        return self
//    }
//}
//extension PlaceOrderVC: SwiftyMenuDelegate {
//    // Get selected option from SwiftyMenu
//    func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
//        print("Selected item: \(item), at index: \(index)")
//    }
//
//    // SwiftyMenu drop down menu will expand
//    func swiftyMenu(willExpand swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu willExpand.")
//    }
//
//    // SwiftyMenu drop down menu did expand
//    func swiftyMenu(didExpand swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu didExpand.")
//    }
//
//    // SwiftyMenu drop down menu will collapse
//    func swiftyMenu(willCollapse swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu willCollapse.")
//    }
//
//    // SwiftyMenu drop down menu did collapse
//    func swiftyMenu(didCollapse swiftyMenu: SwiftyMenu) {
//        print("SwiftyMenu didCollapse.")
//    }
//}



extension PlaceOrderVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("HomeTVC", owner: Any?.self, options: nil)?[6] as! CartThirdTVC
        if items.count == 0{
            return cell
        }
        cell.itemName_Lbl.text = items[indexPath.row].itemName
         cell.product_id = items[indexPath.row].product_id
        cell.quantity_lbl.text = "\(Int(items[indexPath.row].qty))"
        
        print("Ccc",items[indexPath.row].customerInstruction.first)
        let customerInstructionn = items[indexPath.row].customerInstruction.first
        
        
        if items[indexPath.row].addons.count == 1{
             cell.adOnLbl.text = items[indexPath.row].addons[0].addon_full_name
        }
        if items[indexPath.row].addons.count == 2{
        
      //  for i in 0...1 {
             cell.adOnLbl.text = items[indexPath.row].addons[0].addon_full_name
            cell.adOnLbl2.text = items[indexPath.row].addons[1].addon_full_name
       // }
        }
        else {
            print("empty")
        }
      
        
        
        
        // cell.adOnLbl.text = "AddOns: \n" + items[indexPath.row].addons[1].addon_full_name
        
        
//        func getAdOnString(adOns : [AdOnObjectModel])->NSMutableAttributedString?{
//            if adOns.count == 0{return nil}
//            let heading = NSMutableAttributedString(string: "AddOns: \n", attributes: attributesHeading())
//            for i in adOns{
//                let subH = NSAttributedString(string: i.addon_full_name, attributes: attributesSubHeading())
//               // let qty = NSAttributedString(string: "   x \(i.qty)", attributes: attributesSubHeading())
//               // let unitPrice = NSAttributedString(string: "  :  USD \(i.unit_price) $\n", attributes: attributesSubHeading())
//                cell.adOnLbl.text = i.addon_full_name
//                heading.append(subH)
////                heading.append(qty)
////                heading.append(unitPrice)
//            }
//            return heading
//        }
//        func attributesHeading()->[NSAttributedString.Key: Any]{
//            let font = UIFont(name: "GlacialIndifference-Bold", size: 14)
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: font,
//                .foregroundColor: UIColor.black,
//            ]
//            return attributes
//        }
//        func attributesSubHeading()->[NSAttributedString.Key: Any]{
//            let font = UIFont(name: "GlacialIndifference-Regular", size: 12)
//
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: font,
//                .foregroundColor: UIColor.darkGray,
//            ]
//            return attributes
//        }
        
//        cell.adOnLbl.text = items[indexPath.row].addons(add)
        let a = Double(cell.quantity_lbl.text ?? "0") ?? 0
        let p = items[indexPath.row].unit_price * a
        let pr = cleanDollars(String(p))
        cell.unitPrizeLbl.text = "\(pr)"
        if customerInstructionn == ""{
            cell.single_item_price.text = "\(cleanDollars("\((items[indexPath.row].unit_price))"))  \(customerInstructionn ?? "")"
        }
        else{
            
            cell.single_item_price.text = "\(cleanDollars("\((items[indexPath.row].unit_price))"))  📝 \(customerInstructionn ?? "")"
        }
        
        cell.variation_lbl.numberOfLines = 0
        cell.variation_lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
       
        cell.Spicy_heading_lbl.numberOfLines = 0
        cell.Spicy_heading_lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        cell.variation_lbl.text = ""
        cell.Spicy_heading_lbl.text = ""
//        cell.adOnLbl.text =
        
        if items[indexPath.row].variations_attrubutes.count != 0{
            
            for i in 0...items[indexPath.row].variations_attrubutes.count-1 {
                let key = items[indexPath.row].variations_attrubutes[i].category_key
                let values = items[indexPath.row].variations_attrubutes[i].value
                if values.count != 0{
                    cell.Spicy_heading_lbl.text?.append(key+"\n")
                    cell.variation_lbl.text?.append(values[0]+"\n")
                }
            }
            cell.variation_lbl.sizeToFit()
            cell.Spicy_heading_lbl.sizeToFit()
//            let key = items[indexPath.row].variations_attrubutes[0].category_key
//            let values = items[indexPath.row].variations_attrubutes[0].value
//
//            if values.count != 0{
//                cell.Spicy_heading_lbl.text = key
//                cell.variation_lbl.text = values[0]
//            }
            
        }
        
        
        // delete drop down
        let dropdowndatasource = ["         DELETE          "]
        
        cell.obj = {
            cell.deleteDropDown.show()
        }
        cell.deleteDropDown.anchorView = cell.option_btn
        cell.deleteDropDown.dataSource = dropdowndatasource
        
        cell.deleteDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.deleteitemBtn(at: indexPath.row)
            //            self.tip_amount_lbl.text = ((amount / Double(item)) * 100)
        }
        cell.deleteDropDown.direction = .any
        
        
        // stepper view
        cell.custom_stepperV.value = CGFloat(items[indexPath.row].qty)
        cell.custom_stepperV.delegate = self
        cell.custom_stepperV.tag = indexPath.row
        cell.custom_stepperV.step = 1
        
        let (min,max) = ProductsDetailViewModel(vc: self).get_stepper_min_max_value()
        cell.custom_stepperV.minValue = CGFloat(min)
        cell.custom_stepperV.maxValue = CGFloat(max)
        
        
        return cell
        
    }
    
    
    func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        sender.isUserInteractionEnabled = true
//        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
        if sender.tag < items.count{
          //  hideactivityIndicator(activityIndicator: activityIndicator)

            present_action_sheet(itemid: self.items[sender.tag].item_id, qty: String(describing: value)) { (update) in
                if !update{
                    if increment{
                        sender.value = value - 1
                        
                    }else if decrement{
                        sender.value = value + 1
                    }
                    
                }else{
                    try? DBManager.sharedInstance.database.write {
                        if self.items.count != 0{
                        self.items[sender.tag].qty = Double(value)
                        }
                    }
                    
                    self.itemsTableV.reloadRows(at: [IndexPath(row:sender.tag,section:0)], with: .none)
                    
                }
            }
        }
        else{
            sender.isUserInteractionEnabled = false
//            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//            self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
//            activityIndicator.startAnimating()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                hideactivityIndicator(activityIndicator: activityIndicator)
//            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
////        if items.count == 0 {
////            navigationController?.popViewController(animated: true)
////        }
//
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
//
//            self.deleteitemBtn(at: indexPath.row)
//        }
//        delete.backgroundColor = .red
//
//
//
//        return [delete]
//
//
//    }
    
    
    func present_action_sheet(itemid:String,qty:String,callback:@escaping ((Bool)->())){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let update_action = UIAlertAction(title: "Update item", style: .default) { (_) in
            self.submitThe_qty(bucketItemId: itemid, quantity: qty, completion: {
                (success) in
                if success{
                    callback(true)
                }else{
                    callback(false)
                }
            })
            
        }
        let cancle_action = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            callback(false)
        }
        actionSheet.view.tintColor = UIColor.MyTheme.marooncolor
        actionSheet.addAction(update_action)
        actionSheet.addAction(cancle_action)
        
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            
            
            
            //            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
          //  popoverController.sourceRect = chkOutBtn.frame
        }
        
        self.present(actionSheet, animated: true) {
            
        }
        
    }
    @objc func
        deleteitemBtn(at index:Int){
        
        print("items", items)
        if index >= items.count{
            return
        }
        if items.count == 1{
            deleteWholeCart()
            return
        }
        let itemid = items[index].item_id
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("deleteitemBtn press")
        
        ProductsApi.delete_item_from_cart(item_id: itemid) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            print("deleteitemBtn api response")
            if success{
                
                let obj = self.items.remove(at: index)
                
                self.rowselcted = nil
//                self.setTableViewData()
                self.initialSetUp()
//                self.itemsTableV.reloadData()
              //  self.deleteObject(obj: obj)
                
                print("obj is ", obj)
                
            }
            else{
                if result == nil{
                    SCLAlertView().showError("error", subTitle: "") // Error
                }else{
                    SCLAlertView().showError("error", subTitle: "") // Error
                }
            }
            print("all object", self.items)
           // self.visibilityThings()
        }
    }
    
    
    func deleteWholeCart(){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        ProductsApi.delete_cart { (success, result) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                self.items.removeAll()
                DBManager.sharedInstance.deleteBucketId()
                ProductsApi.detail_Cart_Info(callback: { (_, _,_) in
                    
                })
                self.itemsTableV.reloadData()
            }
            else{
                SCLAlertView().showError("error", subTitle: "") // Error
            }
            self.visibilityThings()
        }
    }
    func visibilityThings(){
        if self.items.count == 0{
            self.itemsTableV.isHidden = true
//            self.removecart.tintColor = .clear
            self.navigationController?.popViewController(animated: true)
        }
        if self.items.count != 0{
            self.itemsTableV.isHidden = false
//            self.removecart.tintColor = .white
//            self.chkOutBtn.isHidden = false
        }
    }
    
    func submitThe_qty(bucketItemId: String , quantity: String, completion: @escaping (Bool)->()){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        SubmissionAPIs.update_quantity_of_product(bucketItemId: bucketItemId, quantity: quantity) { (success, _) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                
                self.getAlOredrs(completion: {(_, _) in
                    completion(true)
                })
                
                
            }else{
                SCLAlertView().showError("some error occured")
                completion(false)
            }
        }
    }
    
    func deleteObject(obj : ItemsObjectOrdersData){
        
        print("delete object")
        
        try! DBManager.sharedInstance.database.write {
            DBManager.sharedInstance.database.delete(obj)
        }
        
    }
    
    func deleteInvAlidBucket(){
        print(isUserLoggedIn)
        if !isUserLoggedIn{
            if let a = DBManager.sharedInstance.getBucketId() , a == ""{return}
            DBManager.sharedInstance.deleteBucketId()
            return}
        else{
            if let a = DBManager.sharedInstance.getBucketId() , a != ""{
                self.deleteWholeCart()
                DBManager.sharedInstance.deleteBucketId()
                return}
            
        }
    }
}
extension PlaceOrderVC : STPAddCardViewControllerDelegate{
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        IQKeyboardManager.shared.enable = true
        navigationController?.popViewController(animated: true)
        print("noooo")
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        print("stripe token \(token)")
        self.navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_ID)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_cost)
        placeOrderModel.cardToken = token.tokenId
        IQKeyboardManager.shared.enable = true
        self.processThePayment()
    }
    
    func goToNextScreen(){
        if isUserLoggedIn{
            
            self.goToCardScreen(delegate: self, amount: totalAmountLbl.text!)
        
        }
        else{
            
            let vc = secondSBVC("GuestUserDetailForm") as!  GuestUserDetailForm
            vc.placeOrderModel = placeOrderModel
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func processThePayment(){
        
        let vc = secondSBVC("ProcessingPaymentScreen") as! ProcessingPaymentScreen
        vc.placeOrderModel = placeOrderModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func getAlOredrsAFTERCOUPON(completion: @escaping (Bool,String?)->()){
        already_applied_coupons = [:]
         let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        ProductsApi.detail_Cart_Info { (success, result,_) in
              activityIndicator.startAnimating()


            if success{
                print("----",self.self.items.count)

                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let applied_coupons = object?.value(forKey: "applied_coupons") as? [String:String]
                self.already_applied_coupons = applied_coupons
                self.setTableViewDataAfterCoupon()
            }
        }}


    func getAlOredrs(completion: @escaping (Bool,String?)->()){

         let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        itemsTableV.allowsSelection  = false

        items.removeAll()

        ProductsApi.detail_Cart_Info { (success, result,_) in
              activityIndicator.startAnimating()
            self.itemsTableV.allowsSelection  = true

            if success{
                print("----",self.self.items.count)

                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let applied_coupons = object?.value(forKey: "applied_coupons") as? [String:String]
                self.already_applied_coupons = applied_coupons
            }



            if DBManager.sharedInstance.get_CartData_DataFromDB().count > 0 {

                self.orderData = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData

                if let items = self.orderData.object?.items{
                    self.items.removeAll()
                    self.rowselcted = nil
                    for item in items{
                        print(item)
                        self.items.append(item)
                    }
                }
                let totalPrice = self.orderData.object?.sub_total ?? 0
                let tp = cleanDollars(String(describing: totalPrice))
               // self.chkOutBtn.setTitle("CHECK OUT \(tp)", for: .normal)
                completion(true, nil)

                self.itemsTableV.reloadData()
            }
            else{
                if result == nil{
                    completion(false, nil)
                }else{
                    if let object = (result as? NSDictionary)?.value(forKey: "object") as? NSDictionary{
                        if let error = object.value(forKey: "error") as? String{
                            completion(false, error)
                        }
                    }
                    self.items.removeAll()
                }

            }
           // self.setUI()
            self.visibilityThings()
            self.setTableViewData()
              // after setting tableview data refrsh address
            self.visibleAddress(visibility: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

            self.viewDidLayoutSubviews()
            }
        }



    }
}
