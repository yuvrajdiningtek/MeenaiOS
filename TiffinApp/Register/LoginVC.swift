// https://stackoverflow.com/questions/39127470/in-swift-how-to-create-custom-alert-view

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SCLAlertView
import NVActivityIndicatorView
import UserNotifications

class LoginVC: UIViewController {

    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }    
    
     var makeLogin = false
     var accesstoken : String = ""
    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var passwordTxtF: SkyFloatingLabelTextField!
    @IBOutlet weak var email_TxtF: SkyFloatingLabelTextField!
    
    @IBOutlet weak var login_btn: UIButton!
    
    @IBOutlet weak var notRgstr_btn: UIButton!
    
    @IBOutlet weak var google_imgV: UIImageView!
    
    @IBOutlet weak var fb_imgV: UIImageView!
    @IBAction func back_Btn(_ sender: Any) {
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    // MARK: - VARIABLES
    
    
    // MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setAllViews()
//        email_TxtF.text = "coder.app04@gmail.com"
//        passwordTxtF.text = "qwert@1234"
//
        
        if UserDefaults.standard.value(forKey: userdefaultKeys().merchant_access_token) == nil{
            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            RegisterApi.merchant_token(callback: { (success, _) in
                hideactivityIndicator(activityIndicator: activityIndicator)
                if success{
                
                }
                else{
                    SCLAlertView().showError("error")
                }
            })
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func login_Btn(_ sender: Any) {
        self.view.endEditing(true)
        guard let useremail = email_TxtF.text else {return}
        guard let pswrd = passwordTxtF.text else {return}
        NetworkManager.isUnreachable { (_) in
            SCLAlertView().showError("network unreachable")
        }
        NetworkManager.isReachable { (_) in
            self.dologin_user(useremail: useremail, pswrd: pswrd)
             
        }
    }
//    func forgotPassword()
//        
//    {
//        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
//        
//      
//        let headers:HTTPHeaders = [
//            "Content-Type": "application/json"
//        ]
//        let parameters: [String: Any] = [
//            
//            "user_id" : email_TxtF.text!,
//            "form_id": ""
//
//            
//        ]
//        print(parameters)
//        
//        Alamofire.request(ApiKeys.forgotPassword,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
//            
//            let result = respose.result.value as? NSDictionary
//            print(result)
//            let object = result?.value(forKey: "object") as! NSDictionary
//           
//            let message = object.value(forKey: "message") as? String
//            let error = object.value(forKey: "error") as? String
//            
//            activityIndicator.stopAnimating()
//            switch (respose.result) {
//                
//            case .success:
//                if message != nil {
//                
//                 
//                let token = object.value(forKey: "token") as? String
//                UserDefaults.standard.setValue(token, forKey: "resetToken")
//                UserDefaults.standard.setValue(self.email_TxtF.text!, forKey: "emailReset")
//                    let alert = UIAlertController(title: "\(message ?? "")", message: "",         preferredStyle: UIAlertController.Style.alert)
//                
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
//                    let loginvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotResetVC")
//                    self.navigationController?.pushViewController(loginvc, animated: true)
//                }))
//                
//                self.present(alert, animated: true, completion: nil)
//                }
//                    else {
//                    self.showAlert(msg: error!)
//                    }
//                break
//                
//               
//            case .failure:
//               
//                self.showAlert(msg: "Server Error")
//                break
//            }
//            
//            
//        }
//    }
//    
//    
//    
//    func showAlert(msg:String) {
//        let  alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
//        
//        let okAcction = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
//            
//        }
//        alert.addAction(okAcction)
//        alert.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        self.present(alert, animated: true, completion: nil)
//        
//    }
//    
    @IBAction func forgotPassword(_ sender: Any) {
        //ForgotPasswordOtpVC
        let loginvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordOtpVC")
        self.navigationController?.pushViewController(loginvc, animated: true)
    }
    
    
    @IBAction func notRgstr_btn(_ sender: Any) {
        self.navigationController?.pushViewController(mainSBVC("SignUpVC"), animated: true)
    }
    
    
    
    func setAllViews(){
//        login_btn.layer.cornerRadius = login_btn.frame.height/2
    }
    
    // MARK: - GET MERCHANT ID
    
    func get_merchantId(access_token : String,callback:@escaping (( _ url :String)->())) {
        var urlofProdCat:String = ""
        RegisterApi.merchant_id() { (success, result,urlOfprodCAt) in
            
            if let  _ = urlOfprodCAt {
                urlofProdCat = urlOfprodCAt!
            }
            self.accesstoken = access_token
            
            
            SomeInformationApi.getcurrency(callback: { (success, result) in
                
            })
            callback(urlofProdCat);
        }
    }
    
    // MARK: - LOGIN USER
    
    func dologin_user(useremail : String, pswrd:String){
        
       
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let bucket_id:String
        if let a = DBManager.sharedInstance.getBucketId(){
            bucket_id = a
        }
        else{
            bucket_id = ""
        }
        
        let parameters :  [String: Any] = [ "user" :  useremail,
                                            "password" : pswrd,
                                            "bucket_id":bucket_id ]
       
        print(parameters)
        login_btn.isUserInteractionEnabled = false
        RegisterApi.login_user(parameters: parameters) { (success, result,error) in
            self.login_btn.isUserInteractionEnabled = true
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                
                
                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let accessToken = object?.value(forKey: "access_token") as! String
                
                UserDefaults.standard.setValue(accessToken, forKey: "accessT")
                
                 self.Display()
                // store the user email and password
                UserDefaults.standard.set(self.email_TxtF.text!, forKey: usercredential().email)
                UserDefaults.standard.set(self.passwordTxtF.text!, forKey: usercredential().password)
                
                isUserLoggedIn = true
               
                self.intialApiCall {

                    
//                    self.addDeliveryBtn()
                    self.sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)

                }
            }
            else if let _ = result as? NSDictionary{
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
            else{
                let err = error?.localizedDescription ?? "Something went wrong"
                SCLAlertView().showError("error", subTitle: err) // Error

            }

        }
        
    
    }
    func intialApiCall(completion : @escaping ()->()){
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        IntialSetUp().do_intial_api_call(completion: { (succ) in
            ProductsApi.ProductCat(callback: { (succ, _) in
                GetData.getTimingOfRestrauntV2FromApi(callback: { (_) in
                    hideactivityIndicator(activityIndicator: activityIndicator)
                    completion()
                })
            })
        })
    }
    
    
    func addDeliveryBtn(){
        
        let vc = secondSBVC("ExistingAddressVC") as!  ExistingAddressVC
        vc.title = "SELECT DELIVERY ADDRESS"
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func deviceIdGet(_ sender : NotificationCenter){
        self.Display()
    }
}


extension LoginVC{
    
    func validation()->Bool{
        if email_TxtF.text == nil || email_TxtF.text == "" {
            return false
        }
        if passwordTxtF.text == nil || passwordTxtF.text == "" {
            return false
        }
        return true
        
    }
    
//    func openfakeApp(){
//        UserDefaultsDoings.saveStateOfUserLogin(isLogIn: true)
//        self.enablePushNotifications()
//    }
    func openrealApp(){
        // check device token is exist
        self.enablePushNotifications()
    }
    func Display(){
        let accessT = UserDefaults.standard.value(forKey: "accessT") as! String
//        if !self.makeLogin{return}
//        self.makeLogin = false
        let email = self.email_TxtF.text!
       
        
//        self.spinnerV.isHidden = false
        
//        RegisterApi.registerDevice(email: email, accesstoken: accessT, callback: { (succ, rst, err) in
////            self.spinnerV.isHidden = true
//            if succ{
////                UserDefaultsDoings.saveStateOfUserLogin(isLogIn: true)
////                UserDefaultsDoings.saveaccessToken(token: self.accesstoken)
////                UserDefaultsDoings.saveUserID(token: email)
////                if !self.fake{
//////                    self.nvManager.moveToRealApp(viewController: self)
////                }
//            }
//            else {
//                var message = "Something went wrong"
////                if let runtime_err = err as? RuntimeError{
////                    message = runtime_err.localizedDescription
////                }
//                
//                self.showAlert(msg: message, title: "Error")
//            }
//        })
    }
    func enablePushNotifications(){
        
//        if UserDefaultsDoings.deviceToken == nil{
//            self.makeLogin = true
            Display()
//            return
//        }
        
        self.showAlertForEnablePushNotification(actionWork: {
            let center  = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                
                if error == nil{
                    DispatchQueue.main.async(execute: {
//                        self.spinnerV.isHidden = false
                        UIApplication.shared.registerForRemoteNotifications()
                        self.makeLogin = true
                        
                    })
                }
//                if self.fake{
//                    DispatchQueue.main.async(execute: {
//                        self.nvManager.moveToRealApp(viewController: self)
//                    })
//                }
            }
        }) {
//            if self.fake{
//                DispatchQueue.main.async(execute: {
//                    self.nvManager.moveToRealApp(viewController: self)
//                })
//            }
        }
    }
    
//    func checkUserisAppleTester()->Bool{
//
//        if !(userName_TF.text == AppleTesterCredential.email){
//            return false
//
//        }
//        if   !(password_TF.text == AppleTesterCredential.password){
//            self.showAlert(msg: "The password you entered is incorrect", title: "Oops!")
//
//            return true
//        }
//
//
//        //        let isdateLessThan =  Date().compareDateIsInPastOfCurrentDate(date: AppleTesterCredential.validityOfCredentialForDate)
//        //
//        //        if isdateLessThan{
//        //
//        //        }
//
//        if Connectivity.isConnectedToInternet(){
//            self.spinnerV.isHidden = false
//            DispatchQueue.main.asyncAfter(deadline: .now()+5) {
//                self.spinnerV.isHidden = true
//                UserDefaultsDoings.saveFlag(token: true)
//                UserDefaultsDoings.saveUserID(token: self.userName_TF.text!)
//                self.nvManager.moveToRealApp(viewController: self)
//            }
//        }
//        else{
//            self.showAlert(msg: "Network not reachable", title: "Oops!")
//        }
//        return true
//
//    }
}

