//
//  OTPVC.swift
//  TiffinApp
//
//  Created by yuvraj kakkar on 02/05/18.
//  Copyright © 2018 YAY. All rights reserved.
//

import UIKit
import SRCountdownTimer

class GetOTPVC: UIViewController {

    // MARK: - IBOUTLETS
    
    @IBOutlet weak var txtF_mobileNo: UITextField!
    
    @IBOutlet weak var txtF_cntryCode: UITextField!
    
    @IBOutlet weak var btn_getOtp: UIButton!
    @IBAction func getOtp_btn(_ sender: Any) {
        self.navigationController?.pushViewController(mainSBVC(("VerifyVC")), animated: true)
    }
    
    
    
    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAllViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setAllViews(){
        btn_getOtp.layer.cornerRadius = btn_getOtp.frame.height/2
    }
}
