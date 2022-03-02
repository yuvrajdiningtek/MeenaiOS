

import UIKit
import SCLAlertView
import NVActivityIndicatorView
import Alamofire

class OrderDetailVC: UIViewController, UITextFieldDelegate , UINavigationControllerDelegate{

    //MARK: - IBOUTLETS
    
    @IBOutlet weak var topSpaceOrderTail: NSLayoutConstraint!
    @IBOutlet weak var item_fees_tv: UITableView!
    
    @IBOutlet weak var taxes_table_v: UITableView!
    
    @IBOutlet weak var orderid_lbl: UILabel!
    
    @IBOutlet weak var content_v_inside_scroll_v: UIView!
    @IBOutlet weak var orderdate_lbl: UILabel!
    @IBOutlet weak var status_lbl: UILabel!
    
    @IBOutlet weak var totalamount_lbl: UILabel!
    
    @IBOutlet weak var table_v: UITableView!
    
    @IBOutlet weak var tip_cuuncysymbol_lbl: UILabel!
   
    
    @IBOutlet weak var tableview_height_constraint: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var item_fee_tv_height_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var taxes_tv_height_constraint: NSLayoutConstraint!
    
    @IBOutlet weak var billing_add_lbl: UILabel!
    @IBOutlet weak var shipping_add_lbl: UILabel!
    
    @IBOutlet weak var edit_shippingBtn: UIButton!
    
    @IBOutlet weak var edit_billing_add: UIButton!
    
    @IBOutlet weak var submit_btn: UIButton!
    @IBOutlet weak var delivery_charges: UILabel!
    
    @IBOutlet weak var shippingLbl: UILabel!
    @IBOutlet weak var coupanLbl: UILabel!
    @IBOutlet weak var noteLbl: UILabel!
    
    @IBOutlet weak var orderTotalLbl: UILabel!
    @IBOutlet weak var coupanLbll: UILabel!
    @IBOutlet weak var coupanAmontLbl: UILabel!
    @IBOutlet weak var coupanView: UIView!
    
    @IBOutlet weak var orderTotalView: UIView!

    var namee = String()
    @IBAction func edit_address_btn(_ sender: UIButton) {
        if sender.tag == 1{
            //shipping
            let parameter_remaining = Para_for_Update_shipping_address(bucketId: passedOrderData?.metaInfo?.BUCKET ?? "", shippingId: passedOrderData?.metaInfo?.SHIPPING_METHOD ?? "")
            let vc = secondSBVC("EditCreateAddressVC") as! EditCreateAddressVC
            vc.passedAddress = passedOrderData?.shippingAddress!
            vc.passed_para_for_update_shippingAdd = parameter_remaining
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if sender.tag == 2{
            //billing
        }
    }
    
//    func getState(){
//
//        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//        self.view.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//
//        SomeInformationApi.get_state(countryid: "254") { (success, result) in
//            hideactivityIndicator(activityIndicator: activityIndicator)
//
//            if success{
//                if let data = (result as! NSDictionary).value(forKey: "data") as? [NSDictionary]{
//                    for d in data{
//                        var onedata : (Int,String)
//                        let id = d.value(forKey: "id") as? Int ?? 0
//
//                        let name = d.value(forKey: "name") as? String ?? ""
//                        self.namee = name
//                      //  UserDefaults.standard.setValue(name, forKey: "stateName")
//                        onedata = (id,name)
//
//                    }
////                    self.filtered_data = self.tableData
////                    completion()
//                }
//            }else{
//                if result == nil{
//
//                }else{
//
//                }
//                //completion()
//            }
//        }
//    }
    
    @IBAction func check_payemnt_status(_ sender: Any) {
        
        let frame = check_payemnt_status.frame
        let activityIndicator = NVActivityIndicatorView(frame: frame)
        activityIndicator.type = .ballSpinFadeLoader // add your type
        
        activityIndicator.color = UIColor.MyTheme.marooncolor // add your color
        self.content_v_inside_scroll_v.addSubview(activityIndicator)
        check_payemnt_status.isHidden = true
        
        let orderid = passedOrderData?.orderId ?? ""

        activityIndicator.startAnimating()
        
        SomeInformationApi.check_Payment_Status(orderId: orderid) { (success, status) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            self.check_payemnt_status.isHidden = false
            
            if success, (status as [NSDictionary]! ).count > 0 {
                let status = (status as [NSDictionary]!)[0].value(forKey: "status") as? String ?? ""

                self.status_lbl.text = "Payment : \(status)"
            }else{
                SCLAlertView().showError("error")
            }
            
        }
    }
    @IBOutlet weak var check_payemnt_status: UIButton!
    @IBAction func update_submitBtn(_ sender: Any) {
        edit_billing_add.isHidden = true
        edit_shippingBtn.isHidden = true
        feendtip_txtf.isUserInteractionEnabled = false
        submit_btn.isHidden = true
    }
    @IBAction func backk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var feendtip_txtf: UITextField!
    //MARK: - VARIABLES
    
    var orderId : String!
    var stateNmae : String!
    var notee : String!
    var detailAll = NSDictionary()
    var isOrderHistory = Bool()
    var passedOrderData : DatainOrdersData?
    var items_of_taxes_tablev = [TaxesOrdersData]()
    var additional_fees = [AdditionalFeesOrdersData]()

    //MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTotalView.layer.cornerRadius = 7
        orderTotalView.layer.borderWidth = 0.5
        orderTotalView.layer.borderColor = UIColor.init(named: "MaroonTheme")?.withAlphaComponent(0.4).cgColor
        
//        orderTotalView.addDashedBorder()
        
//        print("pppp",stateNmae)
          title = "ORDER DETAIL"
        // getState()
      print("ooo",notee)
        
        if isOrderHistory == true {
            topSpaceOrderTail.constant = 20

        self.getOrderDetail(completion: {
            
            
            
            if self.notee != ""  {
                self.noteLbl.text = "Note : " + self.notee
            }
            else {
                self.noteLbl.isHidden = true
            }
//            if self.passedOrderData?.taxes == nil{
//                print("nil")
//            }
//            else {
//            if self.passedOrderData?.metaInfo!.COUPON != ""  {
//                self.coupanLbl.text = "Applied Coupan : " + (self.passedOrderData?.metaInfo!.COUPON)! + "   - " + "(" + "$" + (self.passedOrderData?.metaInfo!.COUPON_TIFFIN10_AMOUNT)! + ")"
//            }
//            else {
//                self.coupanLbl.isHidden = true
//            }
            for tax in (self.passedOrderData?.taxes)!{
                self.items_of_taxes_tablev.append(tax)
                }
                self.set_ui_element()
           // }
    
        })
      
       
    }
        else {
            
            topSpaceOrderTail.constant = 50
            
//            if passedOrderData?.metaInfo!.COUPON != ""  {
//                coupanLbl.text = "Applied Coupan : " + (passedOrderData?.metaInfo!.COUPON)! + "   - " + "(" + (passedOrderData?.metaInfo!.COUPON_TIFFIN10_AMOUNT)! + " $" + ")"
//            }
//            else {
//                coupanLbl.isHidden = true
//            }
            
            for tax in (self.passedOrderData?.taxes)!{
                self.items_of_taxes_tablev.append(tax)
            }
            self.set_ui_element()
        }
    }
   

    override func updateViewConstraints() {
        super.updateViewConstraints()
        tableview_height_constraint.constant = CGFloat(70 * table_v.numberOfRows(inSection: 0))
        item_fee_tv_height_constraint.constant = item_fees_tv.contentSize.height
        taxes_tv_height_constraint.constant = taxes_table_v.contentSize.height
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func willMove(toParent parent: UIViewController?)
    {
        super.willMove(toParent: parent)
        if parent == nil
        {
            
            if self.navigationController?.viewControllers.count == 2{
            }else{
                sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
            }
        }
    }
    
//    func getStateName(){
//
//        var apiurl = URLComponents(string: ApiKeys.getState)
//     //   let stateIDD = UserDefaults.standard.value(forKey: "stateIDD") as! Int
//        if isUserLoggedIn {
//            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
//            let accesstoken = (logindata.object?.access_token)!
//            //let stateIDD = UserDefaults.standard.value(forKey: "stateIDD") as! Int
//          //  let stateIDString = String(stateIDD)
//
//            apiurl?.queryItems = [
//                URLQueryItem(name: "access_token", value: accesstoken),
//
//                URLQueryItem(name: "country_id", value: "254"),
//                URLQueryItem(name: "regionId", value: stateIDString)
//
//            ]
//
//        }else{
//            let stateID = UserDefaults.standard.value(forKey: "stateidd") as! Int
//            let stateIDString = String(stateID)
//            let accesstoken = GuestUserCredential.access_token
//
//            apiurl?.queryItems = [
//                URLQueryItem(name: "access_token", value: accesstoken),
//
//                URLQueryItem(name: "country_id", value: "254"),
//                URLQueryItem(name: "regionId", value: stateIDString)
//
//            ]
//        }
//
//
//        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
//            let rst = respose.result.value as? NSDictionary
//
//            print(rst)
//            let data = rst?.value(forKey: "data") as? [NSDictionary]
//            print(data)
//            let name = data![0].value(forKey: "name") as? String ?? ""
//           // let name = data?.value(forKey: "name")
////            let dd = String(name as! Substring)
//            print(name)
//
//            UserDefaults.standard.setValue(name, forKey: "stateNameee")
//            if let  request_status = rst?.value(forKey: "request_status") as? Int , request_status != 1 {
////                callback(false,respose)
//                return
//            }else{
//               // callback(true, rst)
//            }
//        }
//    }
    
    
    
    //----------
   
    
//-----------
    //MARK: - SET UI ELEMENT
    func set_ui_element(){
        
//        table_v.layer.borderColor = UIColor.MyTheme.graycolor.cgColor
//        table_v.layer.borderWidth = 1
      //  let stateName = UserDefaults.standard.value(forKey: "stateName") as! String
        
        if self.passedOrderData?.note != ""  {
            self.noteLbl.text = "Note : " + (self.passedOrderData?.note)!
        }
        else {
            self.noteLbl.isHidden = true
        }
        
        
        orderid_lbl.text = passedOrderData?.orderId ?? ""
        orderdate_lbl.text =
            "Placed at : " + "\((passedOrderData?.orderedDate) ?? "")"
        
        if (passedOrderData?.orderStatus.count)! > 0{
            status_lbl.text = "Payment : \(passedOrderData?.orderStatus.last?.status ?? "")"
        }
        if self.passedOrderData?.metaInfo != nil  {
                 if self.passedOrderData?.metaInfo?.COUPON != ""{
//        if self.passedOrderData?.metaInfo!.COUPON != ""  {
          //  self.coupanLbl.text = "Applied Coupan : " + (self.passedOrderData?.metaInfo!.COUPON)! + "   - " + "(" + "$" + (self.passedOrderData?.metaInfo!.COUPON_TIFFIN10_AMOUNT)! + ")"
            
            totalamount_lbl.text =  "\(cleanDollars(String(describing: passedOrderData?.orderTotal ?? 0.0)))  "
            coupanAmontLbl.text = "$\(self.passedOrderData!.metaInfo!.COUPON_TIFFIN10_AMOUNT)"
                    if self.passedOrderData!.metaInfo!.COUPON_TIFFIN10_AMOUNT == ""{
                        coupanAmontLbl.text = ""
                    }
            coupanLbll.text = "Applied Coupon : \(self.passedOrderData!.metaInfo!.COUPON)"
            orderTotalLbl.text = "  Order Total"
            }
            else {
                        totalamount_lbl.text =  "\(cleanDollars(String(describing: passedOrderData?.orderTotal ?? 0.0)))  "
                        orderTotalLbl.text = "  Order Total"
                       coupanView.isHidden = true
                   }
        }
        else {
             totalamount_lbl.text =  "\(cleanDollars(String(describing: passedOrderData?.orderTotal ?? 0.0)))  "
             orderTotalLbl.text = "  Order Total"
            coupanView.isHidden = true
        }
        
        
        
        
        
        var add = passedOrderData?.billingAddress
        var fname =  add?.firstName ?? ""
        var lname = add?.lastName ?? ""
        var address1 = (add?.address1) ?? ""
        var address2 = (add?.address2) ?? ""
        var city = (add?.city) ?? ""
        var state = add?.state ?? 0
        var stateName = add?.stateName ?? ""
        var mobileNumber = add?.mobileNumber ?? ""
     //   UserDefaults.standard.setValue(state, forKey: "stateIDD")
        
        var postalcode  = add?.postalCode ?? ""
        var email = (add?.email) ?? ""

        
      //  getStateName()
        
       // let stateNameee = UserDefaults.standard.value(forKey: "stateNameee") ?? ""
        
         if address2 == "" {
            billing_add_lbl.text =  "\(fname) \(lname) \n\(address1) \n\(city), \(String(describing: stateName)), \(postalcode) \n\(mobileNumber) \n\(email)"
            
         }else{
            billing_add_lbl.text =  "\(fname) \(lname) \n\(address1) \n\(address2) \n\(city), \(String(describing: stateName)), \(postalcode) \n\(mobileNumber) \n\(email)"
        }
        
        let iscomefrompast = UserDefaults.standard.value(forKey: "iscomefrompast") as? Bool
        if iscomefrompast == true {
            noteLbl.text = "Note: " + passedOrderData!.note
        if passedOrderData?.pickupAddress == nil {
            
           
            shippingLbl.text = "Delivery Address"
            
            add = passedOrderData?.shippingAddress
            fname = add?.firstName ?? ""
            lname = add?.lastName ?? ""
            address1 = (add?.address1) ?? ""
            address2 = (add?.address2) ?? ""
            city = (add?.city) ?? ""
            postalcode  = add?.postalCode ?? ""
            email = (add?.email) ?? ""
            state = add?.state ?? 0
            stateName = add?.stateName ?? ""
            mobileNumber = add?.mobileNumber ?? ""
          //  UserDefaults.standard.setValue(state, forKey: "stateIDD")

            if address2 == "" {
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1)  \n\(city), \(String(describing: stateName)), \(postalcode) \n\(mobileNumber) \n\(email) "
            }
            else{
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1) \n\(address2) \n\(city), \(String(describing: stateName)), \(postalcode) \n\(mobileNumber) \n\(email) "
            }
            }
        else{
            add = passedOrderData?.pickupAddress
            fname = add?.firstName ?? ""
            lname = add?.lastName ?? ""
            address1 = (add?.address1) ?? ""
            address2 = (add?.address2) ?? ""
            city = (add?.city) ?? ""
            postalcode  = add?.postalCode ?? ""
            email = (add?.email) ?? ""
            state = add?.state ?? 0
            mobileNumber = add?.mobileNumber ?? ""
          //  UserDefaults.standard.setValue(state, forKey: "stateIDD")
           

            if address2 == "" {
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1)  \n\(city),  \(String(describing: "Colorado")), \("80302") \n\(mobileNumber) \n\(email) "
            }
            else{
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1) \n\(address2) \n\(city), \(String(describing: "Colorado")), \("80302")\n\(mobileNumber)  \n\(email) "
            }
            
            shippingLbl.text = "Pickup Address"
            }
        }
        else{
        
         let AddressKind = UserDefaults.standard.value(forKey: "AddressKind") as? String
        if AddressKind == "Billing Address" {
        
       // if
            add = passedOrderData?.pickupAddress
            fname = add?.firstName ?? ""
            lname = add?.lastName ?? ""
            address1 = (add?.address1) ?? ""
            address2 = (add?.address2) ?? ""
            city = (add?.city) ?? ""
            postalcode  = add?.postalCode ?? ""
            email = (add?.email) ?? ""
            state = add?.state ?? 0
            stateName = add?.stateName ?? ""
            mobileNumber = add?.mobileNumber ?? ""
           // UserDefaults.standard.setValue(state, forKey: "stateIDD")

            
            if address2 == "" {
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1)  \n\(city), \("Colorado"), \("80302") \n\(mobileNumber) \n\(email) "
            }
            else{
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1) \n\(address2) \n\(city), \("Colorado"), \("80302")\n\(mobileNumber)  \n\(email) "
            }
          //  let pickUpaddress =  passedOrderData?.pickupAddress //{
           // shipping_add_lbl.text = " \n\n\n\n\n\n " //\(String(describing: pickUpaddress))"
            shippingLbl.text = "Pickup Address"
        }
        else{
            shippingLbl.text = "Delivery Address"
            add = passedOrderData?.shippingAddress
            fname = add?.firstName ?? ""
            lname = add?.lastName ?? ""
            address1 = (add?.address1) ?? ""
            address2 = (add?.address2) ?? ""
            city = (add?.city) ?? ""
            postalcode  = add?.postalCode ?? ""
            email = (add?.email) ?? ""
            state = add?.state ?? 0
            stateName = add?.stateName ?? ""
            mobileNumber = add?.mobileNumber ?? ""
           // UserDefaults.standard.setValue(state, forKey: "stateIDD")
            
            if address2 == "" {
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1)  \n\(city), \(stateName), \(postalcode) \n\(mobileNumber)\n\(email) "
            }
            else{
                shipping_add_lbl.text =  "\(fname) \(lname) \n\(address1) \n\(address2) \n\(city), \(stateName), \(postalcode) \n\(mobileNumber) \n\(email) "
            }
        }
       
        }
        let padding = UIEdgeInsets(top: 0, left: tip_cuuncysymbol_lbl.frame.width + 5, bottom: 0, right: 5);
        let frame = feendtip_txtf.frame.inset(by: padding)
        
        feendtip_txtf.rightView = UIView(frame: frame)
        feendtip_txtf.rightViewMode = .always
        feendtip_txtf.delegate = self
        
        let itemsFees = passedOrderData?.itemsFees
        if itemsFees?.count != 0{
            let tip = itemsFees?.filter {$0.name == "Tip"}
            if tip?.count != 0{
                feendtip_txtf.text = cleanDollars(String(tip![0].amount))
                
                 var a =  Array(itemsFees!)
                
               
                if let index = a.enumerated().filter( { $0.element.name == "Tip" }).map({ $0.offset }).first {
                    a.remove(at: index)
                }
                
                
                if a.count != 0{
                    
                    delivery_charges.text = cleanDollars(String(a[0].amount))
                }
            }
            
            
        }
        self.item_fees_tv.reloadData()
        self.table_v.reloadData()
        self.taxes_table_v.reloadData()
        
        updateViewConstraints()
    }
    
    @objc func editDetail(_ sender : UIBarButtonItem){
        edit_billing_add.isHidden = false
        edit_shippingBtn.isHidden = false
        feendtip_txtf.isUserInteractionEnabled = true
        submit_btn.isHidden = false
    }
    
}

extension OrderDetailVC {
    func getOrderDetail(completion : @escaping ()->()){
        
        if let data = getDatafrmDatabase(){
            self.passedOrderData = data
            completion()
        }else{
            self.getdataFromApi(orderid: orderId) { (d) in
                self.passedOrderData = d
                print(self.passedOrderData)
                if d == nil{
                    Message.showErrorOnTopStatusBar(message: "Fail to get order detail")
                    self.nvmanager.makeHomeVCAsRootVC()
                }
                completion()
            }
        }
    }
    func getdataFromApi(orderid : String,completion : @escaping (DatainOrdersData?)->()){
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        ProductsApi.get_Orders(id: orderid, pageNumber: "0", pageSize: "1") { (succ, rst) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            let d = self.getDatafrmDatabase()
            completion(d)
            
        }
    }
    func getDatafrmDatabase()->DatainOrdersData?{
        let predicate = NSPredicate(format: "orderId == %@", orderId)
        guard let orderDetail = DBManager.sharedInstance.database.objects(DatainOrdersData.self).filter(predicate).first else{
            
            return nil
        }
        return orderDetail
    }
}

extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == table_v{
//            return passedOrderData?.items.count ?? 0
//        }else if tableView == item_fees_tv{
//            return passedOrderData?.itemsFees.count ?? 0
//        }else{
//            return items_of_taxes_tablev.count
//        }
//    }
        if tableView == table_v{
            return passedOrderData?.items.count ?? 0
        }else if tableView == item_fees_tv{
            return passedOrderData?.itemsFees.count ?? 0
        }else{
            
            if additional_fees.count == 0{
                
                return items_of_taxes_tablev.count
            }
            else{
                return 2
            }
        }}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == table_v {
            return 70
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == table_v{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllProductOrderDetailTVC
            if passedOrderData?.items[indexPath.row].variations_attributes != nil{
                
//                if passedOrderData?.items[indexPath.row].variations_attrubutes.Spicy.count != 0{
//                    cell.product_variation_lbl?.text = "(Spicy: \(String(describing: passedOrderData?.items[indexPath.row].variations_attrubutes.Spicy[0] ?? "")))"
//                }
//                else{
//                    cell.product_variation_lbl.isHidden = true
//                }
                if passedOrderData?.items[indexPath.row].variations_attributes.count != 0{
                    for i in 0...(passedOrderData?.items[indexPath.row].variations_attributes.count)!-1 {
                        let key = passedOrderData?.items[indexPath.row].variations_attributes[i].category_key ?? ""
                        let value = passedOrderData?.items[indexPath.row].variations_attributes[i].value.first  ?? ""
                    
                        cell.product_variation_lbl.text?.append( key + " : " + value + "\n")
                        
//                        cell.Spicy_heading_lbl.text?.append(key+"\n")
//                        cell.variation_lbl.text?.append(values[0]+"\n")
                    
                }
                }
//                if passedOrderData?.items[indexPath.row].variations_attrubutes.count != 0{
//                    let head = passedOrderData?.items[indexPath.row].variations_attrubutes[0].category_key ?? ""
//                    let value = passedOrderData?.items[indexPath.row].variations_attrubutes[0].value.first ?? ""
//                    cell.product_variation_lbl?.text = head + " : " + value
//                }
                else{
                    cell.product_variation_lbl.isHidden = true
                }
                
            }else{
                cell.product_variation_lbl.isHidden = true
            }
            cell.product_name_lbl.text = passedOrderData?.items[indexPath.row].itemName ?? ""
            
            let up = cleanDollars(String(passedOrderData?.items[indexPath.row].unit_price ?? 0.0))
            
            cell.productQty_Prize_lbl.text = String(describing: Int(passedOrderData?.items[indexPath.row].qty ?? 0.0)) + " x " +  up
            
            if let qty = passedOrderData?.items[indexPath.row].qty{
                if let up = (passedOrderData?.items[indexPath.row].unit_price){
                    let totalp = qty * up
                    cell.product_total_prize.text = cleanDollars(String(totalp))
                }
            }
            if passedOrderData?.items[indexPath.row].addons.count == 0 {
                print("empty")
            }
            
            if passedOrderData?.items[indexPath.row].addons.count == 2 {
                cell.product_adon_lbl.text = (passedOrderData?.items[indexPath.row].addons[0].addon_full_name)!
                
                cell.product_adOnLbl2.text =  (passedOrderData?.items[indexPath.row].addons[1].addon_full_name)!
            }
            
            if passedOrderData?.items[indexPath.row].addons.count == 3 {
                cell.product_adon_lbl.text = (passedOrderData?.items[indexPath.row].addons[0].addon_full_name)!
                
                cell.product_adOnLbl2.text =  "\((passedOrderData?.items[indexPath.row].addons[1].addon_full_name)!)\n\((passedOrderData?.items[indexPath.row].addons[2].addon_full_name)!) "
            }
            if passedOrderData?.items[indexPath.row].addons.count == 1 {
                
                
                cell.product_adon_lbl.text = (passedOrderData?.items[indexPath.row].addons[0].addon_full_name)!
            }
            
            
            
            
            return cell
        }else if tableView == item_fees_tv{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellof_item_fee", for: indexPath) as! Taxes_TVC
            
//            cell.title_lbl.text = passedOrderData?.itemsFees[indexPath.row].name
//            if indexPath.row == 1 {
//                if passedOrderData?.itemsFees[1].name == "LOCAL_PICKUP" {
//                    cell.title_lbl.text = "Pickup at the Restaurant - Free"
//                }
//            }
//            if indexPath.row == 1 {
//                if passedOrderData?.itemsFees[1].name == "LOCAL_DELIVERY" {
//                    cell.title_lbl.text = "Local Delivery"
//                }
//            }
//
//
////            if passedOrderData?.itemsFees[0].name == "Tip" {
////                cell.title_lbl.text = "Tip"
////            }
//            //sabmai..hojjata hai index  1 krwana h bs..
//            cell.detail_lbl.text = cleanDollars(String(passedOrderData?.itemsFees[indexPath.row].amount ?? 0.0))
//            return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cellof_tax", for: indexPath) as! Taxes_TVC
//
//
//
//            cell.title_lbl.text = items_of_taxes_tablev[indexPath.row].name
//
//            cell.detail_lbl.text = cleanDollars(String(items_of_taxes_tablev[indexPath.row].amount))
//
//
//            return cell
//        }
//
//    }
//}
            cell.title_lbl.text = passedOrderData?.itemsFees[indexPath.row].name
            if indexPath.row == 1 {
                if passedOrderData?.itemsFees[1].name == "LOCAL_PICKUP" {
                    cell.title_lbl.text = "Curbside Pickup"
                }
            }
            if indexPath.row == 1 {
                if passedOrderData?.itemsFees[1].name == "LOCAL_DELIVERY" {
                    cell.title_lbl.text = "Local Delivery"
                }
            }
            
            if indexPath.row == 2 {
                if passedOrderData?.itemsFees[2].name == "LOCAL_PICKUP" {
                    cell.title_lbl.text = "Curbside Pickup"
                }
            }
            if indexPath.row == 2 {
                if passedOrderData?.itemsFees[2].name == "LOCAL_DELIVERY" {
                    cell.title_lbl.text = "Local Delivery"
                }
            }
            
            
            //            if passedOrderData?.itemsFees[0].name == "Tip" {
            //                cell.title_lbl.text = "Tip"
            //            }
            //sabmai..hojjata hai index  1 krwana h bs..
            cell.detail_lbl.text = cleanDollars(String(passedOrderData?.itemsFees[indexPath.row].amount ?? 0.0))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellof_tax", for: indexPath) as! Taxes_TVC
            
            if additional_fees.count == 0{
                
                cell.title_lbl.text = items_of_taxes_tablev[indexPath.row].name
                
                cell.detail_lbl.text = cleanDollars(String(items_of_taxes_tablev[indexPath.row].amount))
                
                
                return cell
            }
            else{
                
                if indexPath.row == 0{
                    cell.title_lbl.text = items_of_taxes_tablev[0].name
                    
                    cell.detail_lbl.text = cleanDollars(String(items_of_taxes_tablev[0].amount))
                }
                if indexPath.row == 1{
                    cell.title_lbl.text = additional_fees[0].name
                    
                    cell.detail_lbl.text = cleanDollars(String(additional_fees[0].amount))
                    
                    
                }
                
                return cell
            }
        }
    }
}
class AllProductOrderDetailTVC:UITableViewCell{
    
    var dataSet : ItemsOrdersData?
    {
        didSet{
            configure()
        }
    }
    @IBOutlet weak var product_name_lbl: UILabel!
    @IBOutlet weak var product_variation_lbl: UILabel!
    @IBOutlet weak var product_total_prize: UILabel!
     @IBOutlet weak var product_adon_lbl: UILabel!
    @IBOutlet weak var productQty_Prize_lbl: UILabel!
     @IBOutlet weak var product_adOnLbl2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
//        productQty_Prize_lbl.layer.cornerRadius = 7
//        productQty_Prize_lbl.layer.borderWidth = 0.5
//        productQty_Prize_lbl.backgroundColor = UIColor.init(named: "MaroonTheme")?.withAlphaComponent(0.05)
//        productQty_Prize_lbl.layer.borderColor = UIColor.init(named: "MaroonTheme")?.withAlphaComponent(0.2).cgColor
    }
    private func configure(){
        guard let ds =  dataSet  else {
            return
        }
        product_name_lbl.text = ds.itemName
       
        let up = cleanDollars(String(ds.unit_price ))
        
        productQty_Prize_lbl.text = String(describing: Int(ds.qty )) + " x " +  up
        let qty = ds.qty
        let unitp = ds.unit_price
        let totalp = qty * unitp
        product_total_prize.text = cleanDollars(String(totalp))
        self.setVariation(ds: ds)
        self.setAddonsLbl(ds: ds)
        
    }
    
    private func setVariation(ds: ItemsOrdersData){
        product_variation_lbl.text = ""
        if ds.variations_attributes.count != 0{
            for i in 0...(ds.variations_attributes.count)-1 {
                let key = ds.variations_attributes[i].category_key
                let value = ds.variations_attributes[i].value.first  ?? ""
                product_variation_lbl.text?.append( key + " : " + value + "\n")
                product_variation_lbl.isHidden = false
            }
        }
        else{
            product_variation_lbl.isHidden = true
        }
    }
    
    private func setAddonsLbl(ds: ItemsOrdersData){
        
        product_adon_lbl.attributedText = Global().getAdOnString(adOns: Array(ds.addons))
        
    }
}

extension UIView {
    
    func addDashedBorder() {
        let color = UIColor.init(named: "MaroonTheme")?.cgColor

        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width + 30, height: frameSize.height)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.init(named: "MaroonTheme")?.withAlphaComponent(0.1).cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath

        self.layer.addSublayer(shapeLayer)
    }
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat, color: CGColor) -> CALayer {
          let borderLayer = CAShapeLayer()

          borderLayer.strokeColor = color
          borderLayer.lineDashPattern = pattern
          borderLayer.frame = bounds
          borderLayer.fillColor = nil
          borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

          layer.addSublayer(borderLayer)
          return borderLayer
      }
}
class RectangularDashedView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0

    var dashBorder: CAShapeLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
//    @IBInspectable var perDashLength: CGFloat = 2.0
//       @IBInspectable var spaceBetweenDash: CGFloat = 2.0
//       @IBInspectable var dashColor: UIColor = UIColor.lightGray
//
//
//       override func draw(_ rect: CGRect) {
//           super.draw(rect)
//           let  path = UIBezierPath()
//           if height > width {
//               let  p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
//               path.move(to: p0)
//
//               let  p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
//               path.addLine(to: p1)
//               path.lineWidth = width
//
//           } else {
//               let  p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
//               path.move(to: p0)
//
//               let  p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
//               path.addLine(to: p1)
//               path.lineWidth = height
//           }
//
//           let  dashes: [ CGFloat ] = [ perDashLength, spaceBetweenDash ]
//           path.setLineDash(dashes, count: dashes.count, phase: 0.0)
//
//           path.lineCapStyle = .butt
//           dashColor.set()
//           path.stroke()
//       }
//
//       private var width : CGFloat {
//           return self.bounds.width
//       }
//
//       private var height : CGFloat {
//           return self.bounds.height
//       }
//}
