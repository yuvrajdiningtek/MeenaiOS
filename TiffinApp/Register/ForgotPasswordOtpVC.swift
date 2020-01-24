//
//  ForgotPasswordOtpVC.swift
//  TiffinApp
//
//  Created by NMX MacBook on 05/12/19.
//  Copyright © 2019 YAY. All rights reserved.
//

import UIKit
import Alamofire
class ForgotPasswordOtpVC: UIViewController {

    @IBOutlet weak var email_Txt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sendOtp(_ sender: Any) {
            if email_Txt.text == ""  {
            let alertController4 = UIAlertController(title: "Please enter email address",message:nil,preferredStyle:.alert)
            alertController4.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            let myString  = "Please enter email address"
            var myMutableString = NSMutableAttributedString()
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 18.0)!])
            myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location:0,length:myString.count))
            alertController4.setValue(myMutableString, forKey: "attributedTitle");
        
            alertController4.addAction(UIAlertAction(title: "OK",
            style: UIAlertAction.Style.default,
            handler: {(_: UIAlertAction!) in
        
            self.dismiss(animated: true)
        
            }))
            alertController4.view.tintColor = .black; self.present(alertController4,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 200000, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        
        
            })})
            }
        
            else {
            forgotPassword()
            }}

    
   
    
    
    
    
    func forgotPassword()
        
    {
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        let headers:HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            
            "user_id" : email_Txt.text!,
            "form_id": ""
            
            
        ]
        print(parameters)
        
        Alamofire.request(ApiKeys.forgotPassword,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            let result = respose.result.value as? NSDictionary
            print(result)
            let object = result?.value(forKey: "object") as! NSDictionary
            
            let message = object.value(forKey: "message") as? String
            let error = object.value(forKey: "error") as? String
            
            activityIndicator.stopAnimating()
            switch (respose.result) {
                
            case .success:
                if message != nil {
                    
                    
                    let token = object.value(forKey: "token") as? String
                    UserDefaults.standard.setValue(token, forKey: "resetToken")
                    UserDefaults.standard.setValue(self.email_Txt.text!, forKey: "emailReset")
                    let alert = UIAlertController(title: "\(message ?? "")", message: "",         preferredStyle: UIAlertController.Style.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                        let loginvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotResetVC")
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
