

import Foundation
import UIKit
import Stripe
import SCLAlertView
import Alamofire
//import SwiftyMenu
//import iOSDropDown
import IQKeyboardManagerSwift
var addressIds = [String]()
class PlaceOrderVC : UIViewController,CustomStepperDelegate{
    
    var offerNames = [String]()
    var orderData = CartData()
    var rowselcted : (Bool,IndexPath)?
    var already_applied_coupons : [String:String]?
    
    //  private let items: [SwiftyMenuDisplayable] = ["Option 1"]
    var items = [ItemsObjectOrdersData]()
    var freeArr = NSArray()
    var freeArrArr = [[String:Any]]()
    var couponName = [String]()
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
    @IBOutlet weak var offersCollectionView: UICollectionView!
    // @IBOutlet weak var dropDown: DropDown!
    //  @IBOutlet weak var tablesDrop: SwiftyMenu!
    
    @IBOutlet weak var subTotalLbl : UILabel!
    @IBOutlet weak var totalItemsLbl : UILabel!
    @IBOutlet weak var totalAmountLbl : UILabel!
    @IBOutlet weak var coupanLBL: UILabel!
    @IBOutlet weak var couponApplyBtn : UIButton!
    @IBOutlet weak var couponBtn : UIButton!
    @IBOutlet weak var couponBtnImg : UIImageView!
    @IBOutlet weak var placeOrderBtn : UIButton!
    @IBOutlet weak var placeOrderView : UIView!
    @IBOutlet weak var totalPriceLblPlace : UILabel!
    @IBOutlet weak var couponRateLbl : UILabel!
    @IBOutlet weak var selectedTableLbl: UILabel!
    
    //Free items
    @IBOutlet weak var freeItemsCollView: UICollectionView!
    @IBOutlet weak var freeItemView: UIView!
    @IBOutlet weak var freeItemMainView: UIView!
    @IBOutlet weak var couponBtnAfter: UIButton!
    
    //    @IBOutlet weak var eligibleView: UIView!
    //    @IBOutlet weak var eligibleLbl: UILabel!
    
    @IBAction func freeItemsCross(_ sender : UIButton){
        freeItemView.isHidden = true
        // viewWillAppear(true)
    }
    @IBAction func eligibleBtn(_ sender : UIButton){
        freeItemView.isHidden = false
    }
    
    func getFreeItemsAvaiblae(selectedText : String){
        
        let access_token = UserDefaults.standard.value(forKey: userdefaultKeys().merchant_access_token) as? String ?? ""
        
        let email = UserDefaults.standard.value(forKey: usercredential().email) ?? ""
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let headers:HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer " + access_token
        ]
        
  
        let coupon = UserDefaults.standard.value(forKey: "yessKey") as? String ?? ""
        let bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
        
        // let apiStr = ApiKeys.apibase + ApiKeys.getFreeDCI + "\(bucket_id)/offer/compliments/\(offerNames.joined(separator: ","))"
        let apiStr = ApiKeys.apibase + ApiKeys.getFreeDCI + "\(bucket_id)/offer/compliment/\(selectedText)"
        
        var apiUrl = URLComponents(string: apiStr)
        
        if isUserLoggedIn {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let bucket_id =  DBManager.sharedInstance.getBucketId()
            
            if bucket_id != nil || bucket_id != ""{
                apiUrl?.queryItems = [URLQueryItem(name: "bucket_id", value: bucket_id),URLQueryItem(name: "rule_name", value: coupon)
                                      
                ]
            }
            else{
                activityIndicator.stopAnimating()
                
                SomeInformationApi.get_bucketid { (succ, bucketid) in
                    apiUrl?.queryItems = [ URLQueryItem(name: "bucket_id", value: bucketid ?? ""),URLQueryItem(name: "rule_name", value: coupon)
                    ]
                }
            }
            
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            let user_id = GuestUserCredential.user_id
            let bucket_id = DBManager.sharedInstance.getBucketId()
            apiUrl?.queryItems = [ URLQueryItem(name: "bucket_id", value: bucket_id ?? ""),URLQueryItem(name: "rule_name", value: coupon)
                                   
            ]
        }
        
        
        print("yesssss",apiUrl)
        Alamofire.request(apiUrl!,method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { [self] (respose) in
            
            let result = respose.result.value as? NSDictionary
            print("ressss",result)
            let object = result?.value(forKey: "object") as? NSDictionary
            let responseCode = result?.value(forKey: "responseCode") as? String
            let message = result?.value(forKey: "message") as? String
            let error = object?.value(forKey: "error") as? String
            
            activityIndicator.stopAnimating()
            
            switch (respose.result) {
                
            case .success:
                if message == nil {
                    if responseCode == "404" {
                        //  self.showAlert(msg: "Items Not found")
                        return
                        
                    }
                    activityIndicator.stopAnimating()
                    if result?.value(forKey: "data") == nil{
                        return
                    }
                    
                    if let data = result?.value(forKey: "data") as? NSArray{
                        
                        self.freeArr = data
                        
                        self.freeItemsCollView.reloadData()
                        
                        if self.freeArr.count == 0{
                            return
                        }
                        for i in self.items{
                            for j in 0...self.freeArr.count - 1{
                                let dic:NSDictionary = self.freeArr[j] as! NSDictionary
                                //let dic:NSDictionary = dicc["products"] as! NSDictionary
                                
                                print("",i.product_id, dic["productId"] as? String,dic)
                                if i.product_id == dic["productId"] as? String{
                                    print("",i.product_id, dic["productId"] as? String,dic)
                                    
                                    self.couponBtnAfter.isHidden = false
                                    return
                                }
                                else{
                                    print("",i.product_id, dic["productId"] as? String,dic)
                                    
                                    self.couponBtnAfter.isHidden = false
                                }
                            }
                        }
                    }
                    //                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.showAlert(msg: message ?? "")
                    
                }
                break
            case .failure:
                activityIndicator.stopAnimating()
                
                self.showAlert(msg: error ?? "Service Unavailable")
                break
            }
        }
    }
    
    func addToCartFreeItemsAvaiblae(bucket_item_id:String){
        let access_token = UserDefaults.standard.value(forKey: userdefaultKeys().merchant_access_token) as? String ?? ""
        
        view.isUserInteractionEnabled = false
        let email = UserDefaults.standard.value(forKey: usercredential().email)
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        let headers:HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization" : "Bearer " + access_token
        ]
        
        //      print("parameters==========\(parameters)")
        
        let coupon = UserDefaults.standard.value(forKey: "yessKey") as? String ?? ""
        let bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
        
        var userid =  ""
        let selectedOffer = UserDefaults.standard.value(forKey: "selectedOffer") as? String
        if isUserLoggedIn{
            userid = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            
        }
        else{
            userid = GuestUserCredential.user_id
        }
        
        var formattedDate = String()
        let selectedDate = UserDefaults.standard.value(forKey: "selectedDate") as? String ?? ""
        let selectedTime = UserDefaults.standard.value(forKey: "selectedTime") as? String ?? ""
        if selectedDate != ""{
            formattedDate = selectedDate.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
        }
        else{
            formattedDate = ""
        }
        
        
        var parametrs = [String:Any]()
        let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
        if ENABLE_ORDER_AHEAD == true{
            parametrs  = [
                
                "form_id" : "",
                "user_id" : userid,
                
                "fields" : [
                    "bucketId" : DBManager.sharedInstance.getBucketId() ?? "",
                    "productId" : bucket_item_id,
                    "productVariationId" : "",
                    "quantity" : "1",
                    "addOns":[],
                    "offer": selectedOffer ?? "",
                    "cookingInstruction":"",
                    "orderDate" : formattedDate,
                    "orderTime" : selectedTime
                    
                ]
            ]}
        else{
            parametrs  = [
                
                "form_id" : "",
                "user_id" : userid,
                
                "fields" : [
                    "bucketId" : DBManager.sharedInstance.getBucketId() ?? "",
                    "productId" : bucket_item_id,
                    "productVariationId" : "",
                    "quantity" : "1",
                    "addOns":[],
                    "offer": selectedOffer ?? "",
                    "cookingInstruction":""//,
                    //                    "orderDate" : formattedDate,
                    //                    "orderTime" : selectedTime
                    
                ]
            ]
        }
        print(parametrs)
        
        let apiStr = ApiKeys.apibase + ApiKeys.addToCart
        var apiurl = URLComponents(string: apiStr)
        
        
        if isUserLoggedIn{
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "bucket_id", value: bucket_id)
            ]
            
        }else{
            let user_id = GuestUserCredential.user_id
            let accesstoken = GuestUserCredential.access_token
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "bucket_id", value: bucket_id)
                                  
                                  //                                  URLQueryItem(name: "item_id", value: bucket_item_id)
            ]
            
        }
        
        print("",apiurl)
        Alamofire.request(apiurl!,method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            self.view.isUserInteractionEnabled = true
            
            let result = respose.result.value as? NSDictionary
            print("ressss",result)
            let object = result?.value(forKey: "object") as? NSDictionary
            let responseCode = result?.value(forKey: "responseCode") as? String
            let request_status = result?.value(forKey: "request_status") as? Int
            
            let message = result?.value(forKey: "message") as? String
            let error = object?.value(forKey: "error") as? String
            
            activityIndicator.stopAnimating()
            
            switch (respose.result) {
                
            case .success:
                self.view.isUserInteractionEnabled = true
                
                if request_status == 1 {
                    Message.showSuccessmsg(style: .bottom, message: "Added successfully")
                    self.viewWillAppear(true)
                }
                else {
                    self.showAlert(msg: message ?? error ?? "")
                    
                }
                break
            case .failure:
                self.view.isUserInteractionEnabled = true
                print("vvvvvvvvvvvvvvvvvvvv")
                //self.showAlert(msg: error ?? "Soomething went wrong. Please try again.")
                break
            }
        }
    }
    func deleteFreeItem(itemid:String){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("deleteitemBtn press")
        self.view.isUserInteractionEnabled = false
        
        ProductsApi.delete_item_from_cart(item_id: itemid) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            print("deleteitemBtn api response")
            self.view.isUserInteractionEnabled = true
            
            if success{
                
                self.viewWillAppear(true)
                
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
    
    @objc func oneTapped(_ sender: UIButton?) {
        
        // if freeArr.count != 0{
        if let dic:NSDictionary = freeArr[sender?.tag ?? 0] as? NSDictionary{// ?? [:]
            print(dic,"-----")
            //    let dic:NSDictionary = dicc["products"] as! NSDictionary
            let productId = dic.value(forKey: "productId") as? String ?? ""
            addToCartFreeItemsAvaiblae(bucket_item_id: productId)
            print("Tapped")
        }
        // }
        
    }
    func showAlert(msg:String) {
        let  alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        let okAcction = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(okAcction)
        alert.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func couponAfter(_ sender : UIButton){
        UserDefaults.standard.setValue(self.offerNames, forKey: "offerNames")
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        hideactivityIndicator(activityIndicator: activityIndicator)
        self.view.isUserInteractionEnabled = true
        
        let vc = secondSBVC("ApplyPromocodeVC") as! ApplyPromocodeVC
        //        vc.modalPresentationStyle = .overFullScreen
        //        self.present(vc, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func coupon(_ sender : UIButton){
        return
        if offerNames.count == 1{
            UserDefaults.standard.setValue("\(self.offerNames[0])", forKey: "selectedOffer")
            self.freeItemView.isHidden = false
            self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[0])")
        }
        else{
            
            let alert = UIAlertController(title: "OFFERS", message: "(You're eligible to add free items in your cart)\nChoose any one offer", preferredStyle: UIAlertController.Style.alert)
            
            if offerNames.count == 1{
                alert.addAction(UIAlertAction(title: "\(offerNames[0])", style: UIAlertAction.Style.default, handler: { _ in
                    UserDefaults.standard.setValue("\(self.offerNames[0])", forKey: "selectedOffer")
                    
                    self.freeItemView.isHidden = false
                    self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[0])")
                }))
            }
            else if offerNames.count == 2{
                alert.addAction(UIAlertAction(title: "\(offerNames[0])", style: UIAlertAction.Style.default, handler: { _ in
                    UserDefaults.standard.setValue("\(self.offerNames[0])", forKey: "selectedOffer")
                    
                    self.freeItemView.isHidden = false
                    self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[0])")
                }))
                alert.addAction(UIAlertAction(title: "\(offerNames[1])",
                                              style: UIAlertAction.Style.default,
                                              handler: { _ in
                    UserDefaults.standard.setValue("\(self.offerNames[1])", forKey: "selectedOffer")
                    
                    self.freeItemView.isHidden = false
                    self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[1])")
                }))
            }
            else if offerNames.count == 3{
                alert.addAction(UIAlertAction(title: "\(offerNames[0])", style: UIAlertAction.Style.default, handler: { _ in
                    UserDefaults.standard.setValue("\(self.offerNames[0])", forKey: "selectedOffer")
                    
                    self.freeItemView.isHidden = false
                    self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[0])")
                }))
                alert.addAction(UIAlertAction(title: "\(offerNames[1])",
                                              style: UIAlertAction.Style.default,
                                              handler: { _ in
                    UserDefaults.standard.setValue("\(self.offerNames[1])", forKey: "selectedOffer")
                    
                    self.freeItemView.isHidden = false
                    self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[1])")
                }))
                alert.addAction(UIAlertAction(title: "\(offerNames[2])",
                                              style: UIAlertAction.Style.default,
                                              handler: { _ in
                    UserDefaults.standard.setValue("\(self.offerNames[2])", forKey: "selectedOffer")
                    
                    self.freeItemView.isHidden = false
                    self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[2])")
                }))
            }
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: UIAlertAction.Style.destructive,
                                          handler: { _ in
                
            }))
            alert.view.tintColor = UIColor.init(named: "MaroonTheme")
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func backbtn(_ sender : UIButton){
        NotificationCenter.default.post(name: Notification.Name("MoveToHome"), object: true, userInfo: nil)
        
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
        vc.comeFrom = true
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
            self.goToNextScreen()
            
        }
        //--------
    }
    
    
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
        UserDefaults.standard.setValue(false, forKey: "comeFromOrder")
        offersCollectionView.register(UINib(nibName: "Offers", bundle: .main), forCellWithReuseIdentifier: "Offers")
        offersCollectionView.dataSource = self
        offersCollectionView.delegate = self
        couponBtnAfter.isHidden = false
        couponBtnImg.isHidden = true
        //
        //        placeOrderBtn.layer.cornerRadius = 15
        placeOrderView.layer.cornerRadius = 15
        freeItemMainView.layer.cornerRadius = 20
        freeItemMainView.layer.borderColor = UIColor.init(named: "MaroonTheme")?.cgColor
        freeItemMainView.layer.borderWidth = 1
        NotificationCenter.default.addObserver(self, selector: #selector(afterCoupon), name: Notification.Name("MoveToCoupon"), object: nil)
        UserDefaults.standard.setValue(false, forKey: "iscomefromApply")
        freeItemsCollView.register(UINib(nibName: "CollectionVXibs", bundle: nil), forCellWithReuseIdentifier: "HomeCVC")
        
        self.itemsTableV.dataSource = self
        self.itemsTableV.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.viewDidLayoutSubviews()
        //        updateViewConstraints()
        //        itemsTableV.reloadData()
        IQKeyboardManager.shared.enableAutoToolbar = true
        tableTF.inputView = UIView()
        
        noteTxtF.text = ""
        initialSetUp()
    }
    override func viewDidDisappear(_ animated: Bool) {
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @objc func afterCoupon(){
        
        self.getAlOredrs(completion: {
            
            (succ,error) in
            //            self.view.isUserInteractionEnabled = true
            if !succ{
                
                print("",error)
                
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
        //  }
        //
    }
    
    func initialSetUp(){
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        self.view.isUserInteractionEnabled = false
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
                //                self.view.isUserInteractionEnabled = true
                
                //self.setUI()
                hideactivityIndicator(activityIndicator: activityIndicator)
                
                if !succ{
                    print("",error)
                    
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
            // self.tableView.isHidden = false
            self.selectedTableLbl.isHidden = false
            
        }
        else{
            // self.tableView.isHidden = true
            self.selectedTableLbl.isHidden = true
            
        }
        
        if showCar == true{
            //  self.tableView.isHidden = false
            //self.tableTF.isHidden = true
            self.selectedTableLbl.isHidden = true
            
            
        }
        else if showTables == true{
            //  self.tableView.isHidden = false
            
            //  self.tableTF.isHidden = false
            self.selectedTableLbl.isHidden = false
            
            
            
        }
        else{
            // self.tableView.isHidden = true
            
            
        }
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        itemsTableV.frame.size = itemsTableV.contentSize
        itemsTableVHeightConstraint.constant = itemsTableV.frame.height
    }
    override func updateViewConstraints() {
        itemsTableVHeightConstraint.constant = itemsTableV.contentSize.height
        
        super.updateViewConstraints()
    }
    
}
extension PlaceOrderVC{
    
    
    func setTableViewDataAfterCoupon(){
        let v = viewModel.getCartDataFromDB().1
        self.viewDidLayoutSubviews()
        setUI()
        
    }
    func setTableViewData(){
        //print(viewModel.getCartDataFromDB(),"-----------",viewModel)
        let v = viewModel.getCartDataFromDB().1
        
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
        
        let (tiprate,tipamount) = viewModel.getTiprateAndAmount()
        tipBtn.setTitle(tiprate, for: .normal)
        tipPriceLbl.text = tipamount
        
        
        let iscomefromApply = UserDefaults.standard.value(forKey: "iscomefromApply") as? Bool
        let come = UserDefaults.standard.value(forKey: "come") as? Bool
        let savedCouponValue = UserDefaults.standard.value(forKey: "yess") as? String ?? "0.0"
        let yessKey = UserDefaults.standard.value(forKey: "yessKey") as? String ?? ""
        
        if iscomefromApply == true {
            if come == true {
                
                if already_applied_coupons?.count == 0{
                    coupanLBL.text = "Coupon :"
                    //                    coupanLBL.text = "Coupon :\nApplied Coupon: \(yessKey)\nYou saved $\(savedCouponValue)"
                    
                }
                else {
                    if already_applied_coupons != nil && already_applied_coupons?.count != 0{
                        let coupanAmount = already_applied_coupons!.first!.value
                        let coupanKey = already_applied_coupons!.first!.key
                        
                        print(coupanAmount)
                        
                        
                        coupanLBL.text = "Coupon :\nApplied Coupon: \(coupanKey)\nYou saved $\(String(describing: coupanAmount))"
                    }
                }
            }
            else {
                
                if already_applied_coupons != nil && already_applied_coupons?.count != 0{
                    let coupanAmount = already_applied_coupons!.first!.value
                    let coupanKey = already_applied_coupons!.first!.key
                    
                    print(coupanAmount)
                    
                    
                    coupanLBL.text = "Coupon :\nApplied Coupon: \(coupanKey)\nYou saved $\(String(describing: coupanAmount))"
                }
                else{
                    coupanLBL.text = "Coupon :"
                    UserDefaults.standard.setValue("", forKey: "yessKey")
                }
            }
        }
        else {
            
            if already_applied_coupons?.count == 0{
                coupanLBL.text = "Coupon :"
                UserDefaults.standard.setValue("", forKey: "yessKey")
                
            }
            else {
                
                if already_applied_coupons != nil && already_applied_coupons?.count != 0{
                    let coupanAmount = already_applied_coupons!.first!.value
                    let coupankey = already_applied_coupons!.first!.key
                    
                    print(coupanAmount)
                    
                    coupanLBL.text = "Coupon :\nApplied Coupon: \(coupankey)\nYou saved $\(String(describing: coupanAmount))"
                }
                else{
                    //                    coupanLBL.text = "Coupon :\nApplied Coupon: \(coupankey)\nYou saved $\(String(describing: "0"))"
                    coupanLBL.text = "Coupon :"
                    
                    
                }
            }
            
        }
        let yessKeyy = UserDefaults.standard.value(forKey: "yessKey") as? String ?? ""
        
        //        if yessKeyy == "bfg21"{
        //            if yessKeyy != ""{
        if offerNames.count != 0 {
            couponBtn.isUserInteractionEnabled = true
            couponBtnImg.isHidden = true
        }
        else{
            couponBtn.isUserInteractionEnabled = false
            couponBtnImg.isHidden = true
            
        }
        print("offerNamescount",offerNames.count,yessKey)
        self.offersCollectionView.reloadData()
        
        if offerNames.count != 0 {
            couponBtnAfter.isHidden = false
            let off = offerNames.joined(separator: ", ")
            //            if yessKeyy != ""{
            let selectedOffer = UserDefaults.standard.value(forKey: "selectedOffer") as? String
            getFreeItemsAvaiblae(selectedText: selectedOffer ?? "")
            //            }
            couponBtn.setTitle("You're eligible to add free items in your cart :", for: .normal)
            couponBtn.titleLabel?.lineBreakMode = .byWordWrapping
            
        }
        else{
            couponBtn.setTitle("Select Coupon / Apply Coupon", for: .normal)
            couponBtnAfter.isHidden = false
            
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



extension PlaceOrderVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        //        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        if tableView == freeItemsCollView{
        //
        //        }
        //        else{
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
        //  }
    }
    
    
    func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        sender.isUserInteractionEnabled = true
        //        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        //        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        //        activityIndicator.startAnimating()
        print("",self.items[sender.tag].item_id,value,items.count,sender.tag)
        
        //        if sender.tag
        
        if sender.tag < items.count || sender.tag == items.count - 1{
            //  hideactivityIndicator(activityIndicator: activityIndicator)
            print("",self.items[sender.tag].item_id,value,items.count,sender.tag)
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
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    
    
    func present_action_sheet(itemid:String,qty:String,callback:@escaping ((Bool)->())){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        print("YESSSSSSSSSAAAAA")
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
        self.view.isUserInteractionEnabled = false
        
        ProductsApi.delete_item_from_cart(item_id: itemid) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            print("deleteitemBtn api response")
            self.view.isUserInteractionEnabled = true
            
            if success{
                let obj = self.items.remove(at: index)
                if cartproductIDS.count > index{
                    cartproductIDS.remove(at: index)
                }
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
        //        NotificationCenter.default.post(name: Notification.Name("MoveToHome"), object: true, userInfo: nil)
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        ProductsApi.delete_cart { (success, result) in
            self.view.isUserInteractionEnabled = true
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                self.items.removeAll()
                cartproductIDS.removeAll()
                
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
            NotificationCenter.default.post(name: Notification.Name("MoveToHome"), object: true, userInfo: nil)
            
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
        
        print("YESSSSSSSSS")
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
        self.view.isUserInteractionEnabled = false
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        ProductsApi.detail_Cart_Info { (success, result,_) in
            activityIndicator.startAnimating()
            
            self.view.isUserInteractionEnabled = true
            
            if success{
                print("----",self.self.items.count)
                
                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let applied_coupons = object?.value(forKey: "applied_coupons") as? [String:String]
                self.already_applied_coupons = applied_coupons
                self.setTableViewDataAfterCoupon()
            }
        }}
    
    
    func getAlOredrs(completion: @escaping (Bool,String?)->()){
        
        view.isUserInteractionEnabled = false
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        itemsTableV.allowsSelection  = false
        activityIndicator.startAnimating()
        
        // items.removeAll()
        
        ProductsApi.detail_Cart_Info { (success, result,_) in
            self.itemsTableV.allowsSelection  = true
            activityIndicator.stopAnimating()
            if success {
                
                
                print("----",self.self.items.count)
                if result == nil{
                    return
                }
                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let applied_coupons = object?.value(forKey: "applied_coupons") as? [String:String]
                self.already_applied_coupons = applied_coupons
                
                print("",applied_coupons)
                
            }
            
            
            if DBManager.sharedInstance.get_CartData_DataFromDB().count > 0 {
                print("")
                self.orderData = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
                
                print("-------",self.orderData)
                if let items = self.orderData.object?.items{
                    
                    
                    self.items.removeAll()
                    self.rowselcted = nil
                    for item in items{
                        print(item)
                        self.items.append(item)
                    }
                }
                
                print("OFFER_NAME",self.orderData.object?.offer_name.count,self.orderData.object?.offer_name.first)
                self.offerNames.removeAll()
                
                if self.orderData.object?.offer_name.count != 0{
                    for i in 0...self.orderData.object!.offer_name.count - 1{
                        self.offerNames.append(self.orderData.object!.offer_name[i])
                    }
                    UserDefaults.standard.setValue(self.offerNames, forKey: "offerNames")
                    //    self.offersCollectionView.reloadData()
                }
                
                let totalPrice = self.orderData.object?.sub_total ?? 0
                let tp = cleanDollars(String(describing: totalPrice))
                // self.chkOutBtn.setTitle("CHECK OUT \(tp)", for: .normal)
                completion(true, nil)
                
                self.itemsTableV.reloadData()
            }
            else{
                print("")
                
                if result == nil{
                    completion(false, nil)
                }else{
                    if let object = (result as? NSDictionary)?.value(forKey: "object") as? NSDictionary{
                        if let error = object.value(forKey: "error") as? String{
                            completion(false, error)
                        }
                    }
                    //  self.items.removeAll()
                }
                
            }
            // self.setUI()
            self.visibilityThings()
            self.setTableViewData()
            // after setting tableview data refrsh address
            self.visibleAddress(visibility: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view.isUserInteractionEnabled = true
                
                self.viewDidLayoutSubviews()
            }
        }
        
    }
}
extension PlaceOrderVC: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //    func numberOfSections(in collectionView: UICollectionView) -> Int {
    //        return freeArr.count
    //    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == offersCollectionView{
            return offerNames.count
        }
        else{
            return freeArr.count
        }
        //        let freeAr = freeArr[section] as! NSDictionary
        //        let products = freeAr["products"] as! NSArray
        //
        //        guard let count = (products[freeArr[section] as! Int] as AnyObject).count else {
        //            return 0
        //        }
        //        return (count + 1)
        //
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == offersCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Offers", for: indexPath)  as! Offers
            if offerNames.count == 0{
                return cell
            }
            cell.offerNameLbl.text = " \(offerNames[indexPath.row]) "
            
            return cell
        }
        else{
            
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath)  as! HomeCVC
            if freeArr.count == 0{
                return cell
            }
            
            if let dic:NSDictionary = freeArr[indexPath.row] as? NSDictionary{
                cell.custom_stepperV.isHidden = true
                
                //        let dic = dicc.value(forKey: "products") as! NSDictionary
                cell.addBtn.tag = indexPath.row;
                cell.addBtn.addTarget(self, action: #selector(oneTapped(_:)), for: .touchUpInside)
                cell.productName_lbl.text =  dic.value(forKey: "name") as? String
                
                cell.product_Desciption_lbl.text = (dic.value(forKey: "descriptions") as? String)
                cell.productPrice_lbl.text = cleanDollars(String(dic.value(forKey: "price") as? Double ?? 0.0))
                cell.categoryLbl.text = "Available Free items"
                
                for i in items{
                    //            for j in 0...freeArr.count - 1{
                    //                let dic = freeArr[indexpa] as? NSDictionary
                    let freeeitemID = dic["productId"] as? String ?? ""
                    if i.product_id == freeeitemID{
                        UserDefaults.standard.setValue(i.item_id, forKey: "freeItemID")
                        
                        cell.addBtn.setTitle("Delete", for: .normal)
                        cell.addBtn.setTitleColor(UIColor.red, for: .normal)
                        cell.addBtn.layer.borderColor = UIColor.red.cgColor
                        return cell
                    }
                    else{
                        cell.addBtn.setTitle("Add", for: .normal)
                        cell.addBtn.setTitleColor(UIColor.init(named: "MaroonTheme"), for: .normal)
                        cell.addBtn.layer.borderColor = UIColor.init(named: "MaroonTheme")?.cgColor
                    }
                    
                    
                    //            }
                }
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if indexPath.row != 0{
        
        if collectionView == offersCollectionView{
            UserDefaults.standard.setValue("\(self.offerNames[indexPath.row])", forKey: "selectedOffer")
            
            self.freeItemView.isHidden = false
            self.getFreeItemsAvaiblae(selectedText:"\(self.offerNames[indexPath.row])")
        }
        else{
            
            if let dic:NSDictionary = freeArr[indexPath.row] as? NSDictionary{
                //        let dic = dicc.value(forKey: "products") as! NSDictionary
                
                var freeiTemsProductIds = [String]()
                var itemsProductIDS = [String]()
                
                let productId =  dic.value(forKey: "productId") as? String ?? ""
                
                var itemsProductsIDs = [String]()
                for i in self.items {
                    print(i.product_id,productId,"----------",i)
                    itemsProductsIDs.append(i.product_id)
                }
                
                if itemsProductsIDs.contains(productId) == true{
                    // Message.showErrorMessage(style: .bottom, message: "This item already exists in your cart", title: "")
                    let freeItemID = UserDefaults.standard.value(forKey: "freeItemID") as? String ?? ""
                    
                    
                    let alert = UIAlertController(title: "Delete Free item", message: "Are you sure you want to delete?",         preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { _ in
                        self.deleteFreeItem(itemid: freeItemID)
                        
                    }))
                    alert.addAction(UIAlertAction(title: "No",
                                                  style: UIAlertAction.Style.default,
                                                  handler: {(_: UIAlertAction!) in
                        self.dismiss(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                    return
                }
                else{
                    
                    for i in self.items{
                        for j in 0...self.freeArr.count - 1{
                            if let dic:NSDictionary = self.freeArr[j] as? NSDictionary{
                                //                    let dic:NSDictionary = dicc["products"] as! NSDictionary
                                
                                let freeItem = dic["productId"] as? String ?? ""
                                
                                freeiTemsProductIds.append(freeItem)
                                itemsProductIDS.append(i.product_id)
                                
                            }
                        }
                    }
                    var set1:Set<String> = Set(freeiTemsProductIds)
                    var set2:Set<String> = Set(itemsProductIDS)
                    //            if freeiTemsProductIds.contains(itemsProductIDS) == true{
                    if #available(iOS 13, *) {
                        
                        set1.subtract(set2)
                        set2.subtract(set1)
                        let commonElements: Array = Set(freeiTemsProductIds).filter(Set(itemsProductIDS).contains)
                        
                        //                if itemsProductIDS.contains(productId) == false{
                        //
                        //                }
                        //                else{
                        print(set1.count,set1,set2.count,set2,itemsProductIDS,freeiTemsProductIds,commonElements,"booo")
                        if commonElements.count > 1 || commonElements.count == 1{
                            
                            Message.showErrorMessage(style: .bottom, message: "Free item can't be added more than one", title: "")
                            return
                        }
                        else{
                            
                            addToCartFreeItemsAvaiblae(bucket_item_id: productId)
                            return
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    
                }
            }
            //    }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == offersCollectionView{
            let yy = collectionView.bounds.width / 3
            let yh : CGFloat = 30
            
            return CGSize(width: yy, height: yh)
            
        }
        else{
            //        let yy = collectionView.bounds.width / 2.2
            //        let yh = yy * 1.2
            //
            //        return CGSize(width: yy, height: yh)
            let w = collectionView.frame.width/2 - 0
            let h  : CGFloat = 160
            
            return CGSize(width: collectionView.frame.width, height: h)
        }}
    
}
