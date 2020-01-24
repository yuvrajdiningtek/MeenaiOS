//
//  ForgotResetVC.swift
//  TiffinApp
//
//  Created by NMX MacBook on 05/12/19.
//  Copyright © 2019 YAY. All rights reserved.
//

import UIKit
import Alamofire

class ForgotResetVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var enterOtpTF: UITextField!
    @IBOutlet weak var enterNewPasswordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterOtpTF.delegate = self
      
    }
    
    @IBAction func resetPasswordDone(_ sender: Any) {
        resetPassword()
    }
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == enterOtpTF){
            let characterCountLimit = 6
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
        }
       
        return true
    }
    
    
    
    
    func resetPassword()
    {
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
         let resetToken = UserDefaults.standard.value(forKey: "resetToken") as? String
        let emailReset = UserDefaults.standard.value(forKey: "emailReset") as! String
        let headers:HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            
            "user_id" : emailReset,
            "form_id": "",
            "fields": [
                "token": resetToken,
                "otp": enterOtpTF.text!,
                
                
                "password": enterNewPasswordTF.text!
            
        ]]
        print(parameters)
        
        Alamofire.request(ApiKeys.resetPassword,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            let result = respose.result.value as? NSDictionary
            let object = result?.value(forKey: "object") as! NSDictionary
            let message = object.value(forKey: "message") as? String
            let error = object.value(forKey: "error") as? String
            
            activityIndicator.stopAnimating()
            
            switch (respose.result) {
                
            case .success:
                  if message != nil {
                let token = object.value(forKey: "token") as? String
                UserDefaults.standard.setValue("token", forKey: "resetToken")
                    let alert = UIAlertController(title: "\(message ?? "")", message: "",         preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                    let loginvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
                    self.navigationController?.pushViewController(loginvc, animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
                  }
                  else {
                    self.showAlert(msg: error!)
                  }
                break
            case .failure:
                
                self.showAlert(msg: "Server Error")
                break
            }
            
            
        }
    }
    
    
    
    func showAlert(msg:String) {
        let  alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        let okAcction = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(okAcction)
        alert.view.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
