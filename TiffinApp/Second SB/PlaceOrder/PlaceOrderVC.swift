

import Foundation
import UIKit
import Stripe

class PlaceOrderVC : UIViewController{
    
    
    @IBOutlet weak var itemsTableV : ProductsTV!
    @IBOutlet weak var itemsTableVHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var taxesTableV : TaxesTV!
    @IBOutlet weak var taxesTableVHeightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var deliveryMethodTableV : DeliveryMethodTV!
    @IBOutlet weak var deliveryMethodTableVHeightConstraint : NSLayoutConstraint!
    
    
    @IBOutlet weak var subTotalLbl : UILabel!
    @IBOutlet weak var totalItemsLbl : UILabel!
    @IBOutlet weak var totalAmountLbl : UILabel!
    @IBOutlet weak var coupanLBL: UILabel!
    
    @IBOutlet weak var couponApplyBtn : UIButton!
    @IBOutlet weak var couponBtn : UIButton!
 
    @IBOutlet weak var couponRateLbl : UILabel!
    @IBAction func coupon(_ sender : UIButton){
//        if couponHandle != nil{
//            couponHandle.showDropDown()
//        }
        let vc = secondSBVC("ApplyPromocodeVC") as! ApplyPromocodeVC
        
        navigationController?.pushViewController(vc, animated: true)
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
            self.tipBtn.setTitle(rate + "%", for: UIControl.State.normal)
            self.tipPriceLbl.text = self.viewModel.getTipAmount(rate: rate)
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
            let vc = secondSBVC("BillSummaryVC") as! BillSummaryVC
            vc.placeOrderModel = placeOrderModel
            self.navigationController?.pushViewController(vc, animated: true)
        }

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
                let halfadd = addressModel!.address1 + "\n" + addressModel!.address2
                self.deliveryAddLbl.last?.text = halfadd + "\n" + addressModel!.city + "," + addressModel!.stateName + "," + addressModel!.postalCode + "\n" + addressModel!.mobileNumber + "\n" + addressModel!.email
                placeOrderModel.addressId = addressModel!.address_id
            }
        }
    }
    
    var placeOrderModel = PlaceOrderModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        visibleAddress(visibility: false)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
//
        initialSetUp()
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
    
    func initialSetUp(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        setTableViewData()
        // after setting tableview data refrsh address
        visibleAddress(visibility: false)
        self.setUI()
        
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
            deliveryAddLbl.first?.text = "Delivery Address"
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
            deliveryAddLbl.first?.text = "Delivery Address"
            UserDefaults.standard.setValue(deliveryAddLbl.first?.text, forKey: "AddressKind")
            for i in deliveryAddLbl{
                i.isHidden = true
            }
        }
        noteLblTopConstraint.constant = show ? 0 : -170
    }
    }
  
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
    }
    override func updateViewConstraints() {
        itemsTableVHeightConstraint.constant = itemsTableV.contentSize.height

        super.updateViewConstraints()
    }
    
}
extension PlaceOrderVC{
    
    func setTableViewData(){
        itemsTableV.tvdataSource = viewModel.getCartDataFromDB().1
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
    }
    func setUI(){
        subTotalLbl.text = viewModel.getSubTotal()
        totalItemsLbl.text = viewModel.get_total_items()
        totalAmountLbl.text = viewModel.getTotalPrice()
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
                
                if applied_coupons?.count == 0{
                      coupanLBL.text = "Coupon :\nApplied Coupan\nYou saved $\(savedCouponValue)"
                }
                else {
                
                let coupanAmount = applied_coupons!.first!.value
                print(coupanAmount)
                
                
                
                coupanLBL.text = "Coupon :\nApplied Coupan\nYou saved $\(String(describing: coupanAmount))"
                }
                
            }
            else {
                coupanLBL.text = "Coupon :"
            }
        }
        else {
        
        if applied_coupons?.count == 0{
            coupanLBL.text = "Coupon :"
        }
        else {

        let coupanAmount = applied_coupons!.first!.value
        print(coupanAmount)
       


            coupanLBL.text = "Coupon :\nApplied Coupan\nYou saved $\(String(describing: coupanAmount))"
        }
        }
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
                Message.showWarningOnStatusBar(msg: "Please select delivery method")
                return false
            }
            if addressModel == nil {
                self.showAlertForAddress()
                
                return false
            }
            placeOrderModel.addressId = addressModel?.address_id
        }
            
        else if !isUserLoggedIn   {
            if (deliveryMethodTableV.userselected_shippingMethod == ""){
                
                Message.showWarningOnStatusBar(msg: "Please select delivery method")
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
        
        let deliveryAddString = deliveryAddLbl?.first?.text ?? "Delivery"
        
        let alertController4 = UIAlertController(title: "Please fill \(deliveryAddString) details",message:nil,preferredStyle:.alert)
        alertController4.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor =  UIColor.MyTheme.marooncolor
        
        let myString  = "Please fill \(deliveryAddString) details"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 16.0)!])
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
extension PlaceOrderVC : STPAddCardViewControllerDelegate{
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.view.endEditing(true)
       
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        print("stripe token \(token)")
        self.navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_ID)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_cost)
        placeOrderModel.cardToken = token.tokenId
        self.goToNextScreen()
    }
    
    func goToNextScreen(){
        if isUserLoggedIn{
            
            let vc = secondSBVC("ProcessingPaymentScreen") as! ProcessingPaymentScreen
            vc.placeOrderModel = placeOrderModel
            self.navigationController?.pushViewController(vc, animated: true)

        }
        else{
            let vc = secondSBVC("GuestUserDetailForm") as!  GuestUserDetailForm
            vc.placeOrderModel = placeOrderModel
            self.navigationController?.pushViewController(vc, animated: true)
            
        }

    }
    
}
