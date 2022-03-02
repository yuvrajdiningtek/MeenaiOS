

import UIKit
import DropDown
import SCLAlertView
import NVActivityIndicatorView

class EditCreateAddressVC: UIViewController, CountryStateDelegate,UITextFieldDelegate {
    var countryId: Int?
    
    func selected_country_state(id country: Int?, name Country: String?, Id State: Int?, Name state: String?) {
        if country != nil{
            countryid = 254
            countryId = 254
            
            self.country_btn.setTitleColor(.black, for: .normal)
            self.state_btn.setTitle("  State", for: .normal)
            self.state_btn.setTitleColor(UIColor(hex: 0xB8B8B8) , for: .normal)
            
            self.country_btn.setTitle("  \(Country ?? "")", for: .normal)
        }
        else if State != nil{
            
            stateName = state
            stateid = State
            self.state_btn.setTitleColor(.black, for: .normal)

            self.state_btn.setTitle("  \(state ?? "")", for: .normal)
        }
        
    }
    
    var comeFrom = Bool()
    @IBOutlet weak var topSpaceOrderTail: NSLayoutConstraint!

   //MARK: - IBOUTLETS
    @IBOutlet weak var firstnameTxtF: UITextField!
    
    @IBOutlet weak var middlename_txtf: UITextField!
    
    @IBOutlet weak var lastname_txtf: UITextField!
    
    @IBOutlet weak var email_txtF: UITextField!
    
    
    @IBOutlet weak var phone_txtF: UITextField!
    
    @IBOutlet weak var address1_txtF: UITextField!
    
    @IBOutlet weak var address2_txtF: UITextField!
    
    @IBOutlet weak var cityTxt_F: UITextField!
    
    @IBOutlet weak var state_btn: UIButton!
    
    
    @IBOutlet weak var postal_txtF: UITextField!
    
    @IBOutlet weak var country_btn: UIButton!
    @IBOutlet weak var add_address_btn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!

    
    @IBAction func country_btnAction(_ sender: Any) {
//        countryDropDown.show()
        let vc = secondSBVC("SelectCountryStateVC") as! SelectCountryStateVC
        countryId = nil
        vc.CS_delegate =  self
        vc.tit = "Countries"
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false

    }
    
    @IBAction func statebtnAction(_ sender: Any) {
//        stateDropDown.show()
        
     //   if countryid == 254{
            let vc = secondSBVC("SelectCountryStateVC") as! SelectCountryStateVC
            countryId = 254
            vc.CS_delegate =  self
        vc.tit = "States"

            self.navigationController?.pushViewController(vc, animated: true)
     //   }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == phone_txtF){
            let characterCountLimit = 10
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
        }
         if(textField == postal_txtF){
            let characterCountLimit = 5
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
        }
        
        return true
    }
    
    
    @IBAction func submitBtnAction(_ sender: Any) {
//        print(self.navigationController?.viewControllers.isk(of: secondSBVC("CheckOutVC")))
        
       countryid = 254
       
        
        if firstnameTxtF.text?.count == 0{SCLAlertView().showNotice("fill all the fields")}
        else if phone_txtF.text?.count == 0{SCLAlertView().showNotice("fill all the fields")}
//        else if address2_txtF.text?.count == 0{SCLAlertView().showNotice("fill all the fields")}
//        else if countryid ==  nil{SCLAlertView().showNotice("fill all the fields")}
        else if stateid == nil{SCLAlertView().showNotice("fill all the fields")}
        else if cityTxt_F.text == ""{SCLAlertView().showNotice("fill all the fields")}
        else if postal_txtF.text == ""{SCLAlertView().showNotice("fill all the fields")}
        else if email_txtF.text != nil , !isValidEmail(testStr: email_txtF.text!){SCLAlertView().showNotice("Email is not valid")}
        
        else if phone_txtF.text?.isValidPhone == false {
            SCLAlertView().showNotice("Phone number should be 10 digit number.")
        }
        else if postal_txtF.text?.isValidZip == false {
            SCLAlertView().showNotice("Please enter a valid Zip Code.")
        }
            
        else{
            
            if passedAddress == nil, passed_para_for_update_shippingAdd == nil {submitAllData(address_id: "")}
            else if  passed_para_for_update_shippingAdd == nil{
                let address_id = (passedAddress?.address_id)!
                    submitAllData(address_id: address_id)
            }else if passedAddress != nil , passed_para_for_update_shippingAdd != nil{
                update_shipping_method()
            }
        }
        
    }
    //MARK: - VARIABLES
    var countries = [(Int,String,String)]() // id,iso,name
    let countryDropDown = DropDown()
    
    var states = [(Int,String)]() // id,name
    let stateDropDown = DropDown()
    
    var stateid : Int?
    var stateName : String?
    var countryid : Int?
    var update:Bool = false
    
    
    var passedAddress : DataAdressModel?
    var statenameForAdddrss = String()
    var passed_para_for_update_shippingAdd :Para_for_Update_shipping_address?
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if comeFrom == true {
            topSpaceOrderTail.constant = 30
        }
        else{
            topSpaceOrderTail.constant = 10

        }
        
        add_address_btn.layer.cornerRadius = 15
        textFields()
        
        countryId = 254
        phone_txtF.delegate = self
        postal_txtF.delegate = self
        
        if passedAddress != nil{
            set_textfield_element()
            self.title = "UPDATE ADDRESS"
            self.titleLbl.text = "Update Address"

        self.state_btn.setTitle("  \(statenameForAdddrss)", for: .normal)
            getstates(countryid: String(describing: (passedAddress?.country)!), completion: {

            })
        }
        else if update , passedAddress == nil{
            self.title = "NEW ADDRESS"
        }else{
            self.title = "ADDRESS"
            self.titleLbl.text = "Address"
        }
        
        getcontries()
        setuielement()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

//        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func backk(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFields(){
        
        firstnameTxtF.layer.cornerRadius = 7
        middlename_txtf.layer.cornerRadius = 7
        lastname_txtf.layer.cornerRadius = 7
        email_txtF.layer.cornerRadius = 7
        phone_txtF.layer.cornerRadius = 7
        address1_txtF.layer.cornerRadius = 7
        address2_txtF.layer.cornerRadius = 7
        cityTxt_F.layer.cornerRadius = 7
        postal_txtF.layer.cornerRadius = 7
        country_btn.layer.cornerRadius = 7
        state_btn.layer.cornerRadius = 7

        
        if #available(iOS 13.0, *) {
            firstnameTxtF.layer.borderColor = UIColor.systemGray3.cgColor
            middlename_txtf.layer.borderColor = UIColor.systemGray3.cgColor
            lastname_txtf.layer.borderColor = UIColor.systemGray3.cgColor
            email_txtF.layer.borderColor = UIColor.systemGray3.cgColor
            phone_txtF.layer.borderColor = UIColor.systemGray3.cgColor
            address1_txtF.layer.borderColor = UIColor.systemGray3.cgColor
            address2_txtF.layer.borderColor = UIColor.systemGray3.cgColor
            cityTxt_F.layer.borderColor = UIColor.systemGray3.cgColor
            postal_txtF.layer.borderColor = UIColor.systemGray3.cgColor
            country_btn.layer.borderColor = UIColor.systemGray3.cgColor
            state_btn.layer.borderColor = UIColor.systemGray3.cgColor

        } else {
            // Fallback on earlier versions
        }
        firstnameTxtF.layer.shadowOffset = .zero
        firstnameTxtF.layer.shadowOpacity = 0.7
        firstnameTxtF.layer.shadowRadius = 2.0
        
        middlename_txtf.layer.shadowOffset = .zero
        middlename_txtf.layer.shadowOpacity = 1
        middlename_txtf.layer.shadowRadius = 2.0
        
        lastname_txtf.layer.shadowOffset = .zero
        lastname_txtf.layer.shadowOpacity = 0.7
        lastname_txtf.layer.shadowRadius = 2.0
        
        email_txtF.layer.shadowOffset = .zero
        email_txtF.layer.shadowOpacity = 0.7
        email_txtF.layer.shadowRadius = 2.0
        
        phone_txtF.layer.shadowOffset = .zero
        phone_txtF.layer.shadowOpacity = 0.7
        phone_txtF.layer.shadowRadius = 2.0
        
        address1_txtF.layer.shadowOffset = .zero
        address1_txtF.layer.shadowOpacity = 0.7
        address1_txtF.layer.shadowRadius = 2.0
        
        address2_txtF.layer.shadowOffset = .zero
        address2_txtF.layer.shadowOpacity = 0.7
        address2_txtF.layer.shadowRadius = 2.0
        
        cityTxt_F.layer.shadowOffset = .zero
        cityTxt_F.layer.shadowOpacity = 0.7
        cityTxt_F.layer.shadowRadius = 2.0
        
        postal_txtF.layer.shadowOffset = .zero
        postal_txtF.layer.shadowOpacity = 0.7
        postal_txtF.layer.shadowRadius = 2.0
        
        country_btn.layer.shadowOffset = .zero
        country_btn.layer.shadowOpacity = 0.7
        country_btn.layer.shadowRadius = 2.0
        
        state_btn.layer.shadowOffset = .zero
        state_btn.layer.shadowOpacity = 0.7
        state_btn.layer.shadowRadius = 2.0
        if #available(iOS 13.0, *) {
            firstnameTxtF.layer.shadowColor = UIColor.systemGray4.cgColor
            middlename_txtf.layer.shadowColor = UIColor.systemGray4.cgColor
            lastname_txtf.layer.shadowColor = UIColor.systemGray4.cgColor
            email_txtF.layer.shadowColor = UIColor.systemGray4.cgColor
            phone_txtF.layer.shadowColor = UIColor.systemGray4.cgColor
            address1_txtF.layer.shadowColor = UIColor.systemGray4.cgColor
            address2_txtF.layer.shadowColor = UIColor.systemGray4.cgColor
            cityTxt_F.layer.shadowColor = UIColor.systemGray4.cgColor
            postal_txtF.layer.shadowColor = UIColor.systemGray4.cgColor
            country_btn.layer.shadowColor = UIColor.systemGray4.cgColor
            state_btn.layer.shadowColor = UIColor.systemGray4.cgColor

        } else {
            // Fallback on earlier versions
        }
        firstnameTxtF.setLeftPaddingPoints(7)
        middlename_txtf.setLeftPaddingPoints(7)
        lastname_txtf.setLeftPaddingPoints(7)
        email_txtF.setLeftPaddingPoints(7)
        phone_txtF.setLeftPaddingPoints(7)
        address1_txtF.setLeftPaddingPoints(7)
        address2_txtF.setLeftPaddingPoints(7)
        cityTxt_F.setLeftPaddingPoints(7)
        postal_txtF.setLeftPaddingPoints(7)

    }
    
    //MARK: - submit the data
    func submitAllData(address_id:String){
        
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        
        var lastname = ""
        var middlename = ""
        var address2 = ""
        var email = ""
        if lastname_txtf.text?.count != 0{ lastname = lastname_txtf.text!}
        if middlename_txtf.text?.count != 0{ middlename = middlename_txtf.text!}
        if address2_txtF.text?.count != 0{ address2 = address2_txtF.text!}
        if email_txtF.text?.count != 0{ email = email_txtF.text!}
        
        var user_id = ""
        if isUserLoggedIn{
             user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""

        }else{
             user_id = GuestUserCredential.user_id

        }
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "address_id" : address_id ,
                "firstName": firstnameTxtF.text!,
                "middleName": middlename,
                "lastName": lastname,
                "address1": address1_txtF.text!,
                "address2": address2,
                "city": cityTxt_F.text!,
                "state": String(stateid!),
                "country": String(254),
                "postalCode": postal_txtF.text!,
                "mobileNumber": phone_txtF.text!,
                "email": email
            ]
        ]

       
        RegisterApi.update_address(parameter: parametrs) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
           
            if success{
                
                guard let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary else{return}
                
//                let vc = secondSBVC("CheckOutVC") as! CheckOutVC
                let addrssModel = DataAdressModel()
                addrssModel.address_id = object.value(forKey: "address_id") as? String ?? ""
                addrssModel.firstName = object.value(forKey: "firstName") as? String ?? ""
                addrssModel.middleName = object.value(forKey: "middleName") as? String ?? ""
                addrssModel.lastName = object.value(forKey: "lastName") as? String ?? ""
                addrssModel.address1 = object.value(forKey: "address1") as? String ?? ""
                addrssModel.address2 = object.value(forKey: "address2") as? String ?? ""
                addrssModel.city = object.value(forKey: "city") as? String ?? ""
                addrssModel.state = object.value(forKey: "state") as? Int ?? 0
                addrssModel.country = object.value(forKey: "country") as? Int ?? 0
                addrssModel.postalCode = object.value(forKey: "postalCode") as? String ?? ""
                addrssModel.mobileNumber = object.value(forKey: "mobileNumber") as? String ?? ""
                addrssModel.email = object.value(forKey: "email") as? String ?? ""
                
//                vc.addressModel = addrssModel
                
                let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                    
                )
                let alertView = SCLAlertView(appearance: appearance)
                
                
                alertView.addButton("Ok") {
                    
                    for controller in (self.navigationController?.viewControllers)!{
                        if controller.isKind(of: PlaceOrderVC.self){
                            (controller as! PlaceOrderVC).addressModel = addrssModel
                            self.navigationController?.popToViewController(controller, animated: true)
                            return
                        }
                       
                    }
                    self.navigationController?.popViewController(animated: true)
                    
                    
                }
                alertView.showSuccess("address updated successfully", subTitle: nil)
                
            }else{
                SCLAlertView().showError("some error occured")
            }
        }
    }
    //MARK: - UPDATE SHIPPING ADDRESS
    
    func update_shipping_method(){
        
        RegisterApi.update_shipping_address(bucket_id: "0df3655205c2f5d137c044b7194e1bbe", shippingId: passed_para_for_update_shippingAdd!.shippingId!) { (success, result) in

        }
    }
    
    //MARK: - private functions
     private func set_textfield_element(){
        self.firstnameTxtF.text = passedAddress?.firstName
        self.middlename_txtf.text = passedAddress?.middleName
        self.lastname_txtf.text = passedAddress?.lastName
        self.email_txtF.text = passedAddress?.email
        self.phone_txtF.text = passedAddress?.mobileNumber
        self.address1_txtF.text = passedAddress?.address1
        self.address2_txtF.text = passedAddress?.address2
//        self.country_btn.setTitle(passedAddress?.country, for: .normal)
        self.state_btn.setTitle("  \(statenameForAdddrss)", for: .normal)
        self.cityTxt_F.text = passedAddress?.city
        self.postal_txtF.text = passedAddress?.postalCode
        
        
        self.country_btn.setTitleColor(.black, for: .normal)
        self.state_btn.setTitleColor(.black, for: .normal)
        self.add_address_btn.setTitle("UPDATE ADDRESS", for: .normal)
        
    }
    private func setuielement(){

        
        self.country_btn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.state_btn.titleLabel?.adjustsFontSizeToFitWidth = true
        
      //  self.state_btn.setTitle(statenameForAdddrss, for: .normal)
        
        if update{
            add_address_btn.isHidden = false
            
        }else{
            self.title = "ADDRESS"
            self.titleLbl.text = "Address"

            add_address_btn.isHidden = true
            firstnameTxtF.isUserInteractionEnabled = false
            lastname_txtf.isUserInteractionEnabled = false
            middlename_txtf.isUserInteractionEnabled = false
            phone_txtF.isUserInteractionEnabled = false
            email_txtF.isUserInteractionEnabled = false
            address1_txtF.isUserInteractionEnabled = false
            address2_txtF.isUserInteractionEnabled = false
            country_btn.isUserInteractionEnabled = false
            state_btn.isUserInteractionEnabled = false
            cityTxt_F.isUserInteractionEnabled = false
            postal_txtF.isUserInteractionEnabled = false
            country_btn.setImage(nil, for: .normal)
            state_btn.setImage(nil, for: .normal)
        }
        // drop down menu for country
        var dropdowndatasource = [String]()
        
        for cntry in countries{
            dropdowndatasource.append(cntry.2)
        }
        
        //set intial country when update the adddress
        let passedcountry = self.countries.filter {$0.0 == passedAddress?.country}
        if passedcountry.count != 0, countryid == nil{
            country_btn.setTitle("  \(passedcountry[0].2)", for: .normal)
            countryid = passedcountry[0].0
        }
        
        
        countryDropDown.anchorView = country_btn
        countryDropDown.dataSource = dropdowndatasource
        
        countryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            let selected_country_name = dropdowndatasource[index]
            var selecty_country = self.countries.filter {$0.2 == selected_country_name}
            let done_country = selecty_country[0]
            self.countryid = done_country.0
            self.country_btn.setTitle("  \(selected_country_name)", for: .normal)
            self.country_btn.setTitleColor(.black, for: .normal)
            self.getstates(countryid: String(done_country.0), completion: {
            } )
        }
        countryDropDown.direction = .any
        
        // for state
        // drop down menu
        var dropdowndatasourceforstates = [String]()
        for state in states{
            dropdowndatasourceforstates.append(state.1)
        }
        //set intial state when update address
        let passedstate = self.states.filter {$0.0 == passedAddress?.state}
        
        if passedstate.count != 0, stateid == nil{
            state_btn.setTitle("  \(statenameForAdddrss)", for: .normal)
            // state_btn.setTitle(passedstate[0].1, for: .normal)
            stateid = passedstate[0].0
           // stateName = passedstate
        }
        //***************************
        //***************************
        // delete these lines of code
        if self.states.count != 0{
            state_btn.setTitle("  \(statenameForAdddrss)", for: .normal)
            stateid = self.states[0].0
        }
        //***************************
        //***************************
        
        stateDropDown.anchorView = state_btn
        stateDropDown.dataSource = dropdowndatasourceforstates
        
        stateDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            let selected_state_name = item
            var selecty_state = self.states.filter {$0.1 == selected_state_name}
            let done_state = selecty_state[0]
            self.stateid = done_state.0
            self.state_btn.setTitle("  \(self.statenameForAdddrss)", for: .normal)
            self.state_btn.setTitleColor(.black, for: .normal)
        }
        stateDropDown.direction = .any
    }

    //MARK: - APIS
    private func getcontries(){
        
        if DBManager.sharedInstance.get_countries_DataFromDB().count != 0{
            let CM = DBManager.sharedInstance.get_countries_DataFromDB()[0] as CountryModel
            let data = CM.data
            for d in data{
                var onedata : (Int,String,String)? = nil
                let id = d.id
                let iso = d.iso
                let name = d.name  
                onedata = (id,iso,name)
                self.countries.append(onedata!)
            }
            self.setuielement()
        }
        else{
            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            SomeInformationApi.get_country { (success, result) in
                hideactivityIndicator(activityIndicator: activityIndicator)
                if success{
                    if let data = (result as! NSDictionary).value(forKey: "data") as? [NSDictionary]{
                        for d in data{
                            var onedata : (Int,String,String)? = nil
                            let id = d.value(forKey: "id") as? Int ?? 0
                            let iso = d.value(forKey: "iso") as? String ?? ""
                            let name = d.value(forKey: "name") as? String ?? ""
                            onedata = (id,iso,name)
                            self.countries.append(onedata!)
                        }
                        self.setuielement()
                    }
                }else{
                    if result == nil{
                        
                    }else{
                        
                    }
                }
            }
        }
        
    }
    
    private func getstates(countryid:String, completion : @escaping ()->()){
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        SomeInformationApi.get_state(countryid: countryid) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)

            if success{
                if let data = (result as! NSDictionary).value(forKey: "data") as? [NSDictionary]{
                    for d in data{
                        var onedata : (Int,String)? = nil
                        let id = d.value(forKey: "id") as? Int ?? 0
                        
                        let name = d.value(forKey: "name") as? String ?? ""
                        onedata = (id,name)
                        self.states.append(onedata!)
                    }
                    
                    self.setuielement()
                    completion()
                }
            }else{
                if result == nil{
                    
                }else{
                    
                }
                completion()
            }
        }
    }
    
    
}


extension String {
  
    var isValidPhone: Bool {
        let regularExpressionForPhone = "^\\d{10}$"
        let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
        return testPhone.evaluate(with: self)
    }
    var isValidZip: Bool {
        let regularExpressionForZip = "^\\d{5}$"
        let testZip = NSPredicate(format:"SELF MATCHES %@", regularExpressionForZip)
        return testZip.evaluate(with: self)
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
