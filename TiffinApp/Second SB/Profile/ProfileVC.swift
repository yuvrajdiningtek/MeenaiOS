

import UIKit
import NVActivityIndicatorView
import SCLAlertView

class ProfileVC: UIViewController {

    
    //MARK: - IBOUTLETS
    @IBAction func menubtnAction(_ sender: Any) {
//        self.sideMenuController?.toggle()
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
    }
    @IBAction func backk(_ sender: Any) {
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)

    }
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var email_lbl: UILabel!
    
    
    @IBOutlet weak var first_name_txtF: UITextField!
    @IBOutlet weak var middle_name_txtF: UITextField!
    @IBOutlet weak var last_name_txtF: UITextField!
    @IBOutlet weak var email_txtF: UITextField!
    @IBOutlet weak var phone_txtF: UITextField!
    @IBOutlet weak var submit_btn: UIButton!
    @IBAction func submit_btn(_ sender: Any) {
        if first_name_txtF.text == "",middle_name_txtF.text == "",last_name_txtF.text == "",email_lbl.text == "",phone_txtF.text == ""{
            
            SCLAlertView().showNotice("All the fields are mandatory")
        }else if !isValidEmail(testStr: email_txtF.text!){
            SCLAlertView().showNotice("enter valid email")
        }else{
            update_profile()
        }
    }
    
    //MARK: - VARIABLES
    
    
    //MARK: - VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit_btn.layer.cornerRadius = 15
//        NetworkManager.isUnreachable { (_) in
//            SCLAlertView().showError("network unreachable")
//        }
//        NetworkManager.isReachable { (_) in
//            self.getuserInformation()
//        }
        
        if DBManager.sharedInstance.get_userInfo_DataFromDB().count != 0{
            let userInfo = DBManager.sharedInstance.get_userInfo_DataFromDB()[0] as UserInfo
            first_name_txtF.text = userInfo.object?.firstName
            middle_name_txtF.text = userInfo.object?.middleName
            last_name_txtF.text = userInfo.object?.lastName
            
            email_txtF.text = userInfo.object?.email
            phone_txtF.text = userInfo.object?.primaryPhone
            
        }
        
    }
    //MARK: - API CALL
    
    func getuserInformation(){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        SomeInformationApi.get_user_info { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            
            if success{
                guard let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary else{return}
                self.username_lbl.text = (object.value(forKey: "firstName") as? String ?? "") + (object.value(forKey: "lastName") as? String ?? "")
                self.email_lbl.text = (object.value(forKey: "email") as? String ?? "")
                
            }else{
                SCLAlertView().showError("some error occur")
            }
        }
    }
    
    func update_profile(){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        RegisterApi.update_user_profile(email: email_txtF.text!, primaryPhone: phone_txtF.text!, firstName: first_name_txtF.text!, middleName: middle_name_txtF.text!, lastName: last_name_txtF.text!) { (success, result) in
            
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            
            if success{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.userInfoUpdate), object: nil, userInfo: nil)
                
                SCLAlertView().showSuccess("updated successfully")
            }else{
                SCLAlertView().showSuccess("error")
            }
        }
    }
}


