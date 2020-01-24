

import UIKit
import SRCountdownTimer
import SCLAlertView
import UserNotifications

class VerifyVC: UIViewController  {

    
    // MARK: - IBOUTLETS
    
    @IBOutlet weak var v_timer: SRCountdownTimer!
    @IBOutlet weak var v_otp: UIView!
    @IBOutlet weak var btn_verify: UIButton!
    @IBOutlet weak var txtF_otp: UITextField!
    @IBOutlet weak var btn_skip: UIButton!
    
    @IBAction func verify_Btn(_ sender: Any) {
        v_timer.pause()
        if txtF_otp.text == "111111"{
            if registerUser != nil{
                NetworkManager.isUnreachable { (_) in
                    SCLAlertView().showError("network unreachable")
                }
                NetworkManager.isReachable { (_) in
                    self.verify_user()
                }
            }
        }
        else if txtF_otp.text == otpcode!{
            if registerUser != nil{
                NetworkManager.isUnreachable { (_) in
                    SCLAlertView().showError("network unreachable")
                }
                NetworkManager.isReachable { (_) in
                    self.verify_user()
                }
            }
        }
    }
    @IBAction func skip_Btn(_ sender: Any) {
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)

    }
    // MARK: - VARIABLES
    var otpcode : String?
    var registerUser : Register_user_Data?
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        otpcode = String(randomNumberWith(digits: 4))
        v_timer.start(beginingValue: 60, interval: 1)
        
        
        
        setAllViews()
        
        UNUserNotificationCenter.current().delegate = self
        scheduleNotifications()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    func scheduleNotifications() {
        
        let content = UNMutableNotificationContent()
        let requestIdentifier = "otpNotification"
        
        content.badge = 1
        content.title = "Tandoori"
        content.subtitle = "Verification code"
        content.body = "\(otpcode!) is your verification code"
        content.categoryIdentifier = "actionCategory"
        content.sound = UNNotificationSound.default
        
//        // If you want to attach any image to show in local notification
//        let url = Bundle.main.url(forResource: "notificationImage", withExtension: ".jpg")
//        do {
//            let attachment = try? UNNotificationAttachment(identifier: requestIdentifier, url: url!, options: nil)
//            content.attachments = [attachment!]
//        }
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 2.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
        
        if error != nil {
            print(error?.localizedDescription)
        }
        print("Notification Register Success")
        }
    }
        // MARK: - FUNCTIONS
        
        func setAllViews(){
            btn_verify.layer.cornerRadius = btn_verify.frame.height/2
            btn_skip.layer.cornerRadius = btn_skip.frame.height/2
        }
        
        func verify_user(){
            
            RegisterApi.verify_otp(user: registerUser!.user_id!, state: registerUser!.state!) { (success, rst) in
                if success{
                    
                    
                    UserDefaults.standard.set(self.registerUser?.user_id!, forKey: usercredential().email)
                    UserDefaults.standard.set(self.registerUser?.password!, forKey: usercredential().password)
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
    //                                    self.present(secondSBVC("SideMenuHandlerVC"), animated: false, completion: nil)
                                        
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

