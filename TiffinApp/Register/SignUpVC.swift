// tiffin app ===   AIzaSyCdMB0DelVf8IzXVYe7ID-AmeiG5vHP2Mc
// https://developers.google.com/places/ios-sdk/start
// mega casino  AIzaSyBjxJJRC4oTPUfT9cHUhnYO9C9qxW6AIUc 
//app.promo.TiffinApp
//com.mega.casinoworld

import UIKit
import SkyFloatingLabelTextField
import GooglePlaces
import SCLAlertView
import CountryPicker

class SignUpVC: UIViewController , UITextFieldDelegate, CLLocationManagerDelegate, CountryPickerDelegate{
    
    

    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    
    
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var imgV_fblogni: UIImageView!
    @IBOutlet weak var imgV_google: UIImageView!
    @IBOutlet weak var txtF_firstname: SkyFloatingLabelTextField!
    @IBOutlet weak var txtF_lastname: SkyFloatingLabelTextField!
//    @IBOutlet weak var txtF_mobileno: SkyFloatingLabelTextField!
    @IBOutlet weak var txtF_email: SkyFloatingLabelTextField!
//    @IBOutlet weak var txtF_city: SkyFloatingLabelTextField!
    @IBOutlet weak var txtF_password: SkyFloatingLabelTextField!
    @IBOutlet weak var txtF_cnfrm_password: SkyFloatingLabelTextField!
    
    
    
    @IBOutlet weak var btn_registr: UIButton!
    @IBOutlet weak var btn_Already_registr: UIButton!
    @IBOutlet weak var btn_terms_cndtn: UIButton!
    @IBOutlet weak var country_picker: CountryPicker!
    
    
    @IBAction func alreadyRegiter_Btn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func termCndtn_Btn(_ sender: Any) {
        
    }
    @IBAction func back_Btn(_ sender: Any) {
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func register_btn(_ sender: Any) {

        self.view.endEditing(true)

        if check_DataEntered_valid(){
            
            NetworkManager.isUnreachable { (_) in
                SCLAlertView().showError("network unreachable")
            }
            NetworkManager.isReachable { (_) in
                
                self.register_user()
            }


        }else{

        }
    }
    @IBOutlet weak var country_code_btn: UIButton!
    @IBAction func country_code_btn(_ sender: UIButton) {
        country_picker.isHidden = false
    }
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        country_code_btn.setTitle(phoneCode, for: .normal)
        country_picker.isHidden = true
    }
    
    // MARK: - VARIABLES
    var placesClient: GMSPlacesClient!

    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        txtF_city.delegate = self
        placesClient = GMSPlacesClient.shared()
        country_picker.countryPickerDelegate = self
        setAllViews()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.btn_registr.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)

    }
    
    
    
    func setAllViews(){
//        btn_registr.layer.cornerRadius = btn_registr.frame.height/2
    }
    // MARK: - register user
    func register_user(){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.btn_registr.isUserInteractionEnabled = false
        RegisterApi.register_user(registrationEmail: txtF_email.text!, registrationPassword: txtF_password.text!, registrationMobile: "txtF_mobileno.text!", registrationFirstName: txtF_firstname.text!, registrationLastName: txtF_lastname.text!, registrationCity: "txtF_city.text!") { (success, result) in
            
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                self.btn_registr.isEnabled = false
                UserDefaults.standard.set(self.txtF_email.text!, forKey: usercredential().email)
                UserDefaults.standard.set(self.txtF_password.text!, forKey: usercredential().password)
                
                
                hideactivityIndicator(activityIndicator: activityIndicator)

                
                if let object = (result as! NSDictionary).value(forKey: "object")  as? NSDictionary {
                     let  state = object.value(forKey: "state") as? String ?? ""
                    print(state)
                    let rgster_user = Register_user_Data(userid: self.txtF_email.text!, state: state,  password: self.txtF_password.text!)
                    self.verify_user(registerUser: rgster_user)
                    
                }else{
                    
                }
            }
            else{
                self.btn_registr.isUserInteractionEnabled = true
                if result == nil{
                    SCLAlertView().showError("server down", subTitle: "failed to login") // Error
                }else{
                    guard let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary else{
                        SCLAlertView().showError("error", subTitle: "failed to login") // Error
                        return
                    }
                    guard let error = object.value(forKey: "error") as? String else{
                        SCLAlertView().showError("error", subTitle: "failed to login") // Error
                        return
                    }
                    SCLAlertView().showError("error", subTitle: error) // Error
                }
            }
        }
    }
    
    //******************************************************************************************************
    
    func check_DataEntered_valid() -> Bool{

        //*************************************************** ***************************************************
        
        var isfirstnamevalid = false,islastnamevalid = false,isemailnamevalid = false,iscitynamevalid = true,ismobile_valid = true,ispassword_valid = false,is_cnfrm_pswrdvalid = false
        if((txtF_firstname.text?.count)! < 1 ) {
            txtF_firstname.errorMessage = "first name"
            isfirstnamevalid = false
        }
        else {
            // The error message will only disappear when we reset it to nil or empty string
            txtF_firstname.errorMessage = ""
            isfirstnamevalid = true
        }
        //*************************************************** ***************************************************
        
        if((txtF_lastname.text?.count)! < 1 ) {
            txtF_lastname.errorMessage = "last name"
            islastnamevalid = false
        }
        else {
            // The error message will only disappear when we reset it to nil or empty string
            txtF_lastname.errorMessage = ""
            islastnamevalid = true
        }
        //*************************************************** ***************************************************
        
        if((txtF_email.text?.count)! < 1 ) {
            
            txtF_email.errorMessage = "email"
            isemailnamevalid = false
        }
        else {
            // The error message will only disappear when we reset it to nil or empty string
            if isValidEmail(testStr:  txtF_email.text!){
                txtF_email.errorMessage = ""
                isemailnamevalid = true
            }else{
                txtF_email.errorMessage = "invalid email"
                isemailnamevalid = false
            }
            
        }
        //*************************************************** ***************************************************
        
//        if((txtF_mobileno.text?.count)! < 1 ) {
//
//            txtF_mobileno.errorMessage = "mobile no"
//            ismobile_valid = false
//        }
//        else {
//            txtF_mobileno.errorMessage = ""
//            ismobile_valid = true
//
//        }
//        //*************************************************** ***************************************************
//
//        if((txtF_city.text?.count)! < 1 ) {
//
//            txtF_city.errorMessage = "city"
//
//            iscitynamevalid = false
//        }
//        else {
//            txtF_city.errorMessage = ""
//            iscitynamevalid = true
//
//        }
        
        //*************************************************** ***************************************************
        
        if((txtF_password.text?.count)! < 1 ) {
            
            txtF_password.errorMessage = "password"
            
            ispassword_valid = false
        }
        else {
            txtF_password.errorMessage = ""
            ispassword_valid = true
            
        }
        
        //*************************************************** ***************************************************
        
        
        if !(txtF_cnfrm_password.text == txtF_password.text) {
            
            txtF_cnfrm_password.errorMessage = "password mismatch"
            
            is_cnfrm_pswrdvalid = false
        }
        else {
            txtF_cnfrm_password.errorMessage = ""
            is_cnfrm_pswrdvalid = true
            
        }
        //*************************************************** ***************************************************
        
        
        if isfirstnamevalid,islastnamevalid, isemailnamevalid, iscitynamevalid, ismobile_valid, ispassword_valid, is_cnfrm_pswrdvalid{
            return true
        }else{
            return false
        }
    }
    
    
    
    func verify_user(registerUser : Register_user_Data  ){
        
        RegisterApi.verify_otp(user: registerUser.user_id!, state: registerUser.state!) { (success, rst) in
            self.btn_registr.isUserInteractionEnabled = true
            if success{
                
                
                UserDefaults.standard.set(registerUser.user_id!, forKey: usercredential().email)
                UserDefaults.standard.set(registerUser.password!, forKey: usercredential().password)
                isUserLoggedIn = true
                
                
                guard let object = (rst as! NSDictionary).value(forKey: "object") as? NSDictionary else{return}
                
                if let access_token = object["access_token"] as? String{
                    self.get_merchantId(access_token: access_token, callback: { (urlofProdCat) in
                        
                        RegisterApi.merchant_detail( callback: { (success, result) in
                            if success{
                                
                                let appearance = SCLAlertView.SCLAppearance(
                                    showCloseButton: false
                                    
                                )
                                let alertView = SCLAlertView(appearance: appearance)
                                alertView.addButton("Ok") {
                                    self.sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
                                    
                                }
                                alertView.showSuccess("login success", subTitle: nil)
                            }
                        })
                    })
                }
            }else{
                if rst == nil{
                    SCLAlertView().showError("server down", subTitle: "failed to login") // Error
                }else{
                    guard let object = (rst as! NSDictionary).value(forKey: "object") as? NSDictionary else{
                        SCLAlertView().showError("error", subTitle: "failed to login") // Error
                        return
                    }
                    guard let error = object.value(forKey: "error") as? String else{
                        SCLAlertView().showError("error", subTitle: "failed to login") // Error
                        return
                    }
                    SCLAlertView().showError("error", subTitle: error) // Error
                }
                
            }
        }
    }
    // MARK: - GET MERCHANT ID
    
    func get_merchantId(access_token : String,callback:@escaping (( _ url :String)->())) {
        var urlofProdCat:String = ""
        RegisterApi.merchant_id() { (success, result,urlOfprodCAt) in
            
            if let  _ = urlOfprodCAt {
                urlofProdCat = urlOfprodCAt!
            }
            
            SomeInformationApi.getcurrency(callback: { (success, result) in
                
            })
            callback(urlofProdCat);
        }
    }
    
}


extension SignUpVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

//        self.txtF_city.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
