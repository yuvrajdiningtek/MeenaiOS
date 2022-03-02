
import UIKit
protocol UserDetailUpdated {
    func userDetailUpdated()
}

class SideMenuVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    
    // MARK: - IBOUTLETS
    @IBOutlet weak var table_V: UITableView!
    @IBOutlet weak var user_image: UIImageView!
    
    @IBOutlet weak var phone_lbl: UILabel!
    @IBOutlet weak var version_lbl: UILabel!
    
    @IBOutlet weak var email_lbl: UILabel!
    @IBOutlet weak var username_lbl: UILabel!
    
    @IBOutlet weak var profileBtn: UIButton!
    
    @IBAction func profilebtn(_ sender: Any) {
        if isUserLoggedIn{
            sideMenuController?.performSegue(withIdentifier: "toProfile", sender: nil)
            
        }else{
            // login
            sideMenuController?.performSegue(withIdentifier: "toLogin", sender: nil)
        }
        
    }
    
    // MARK: - VARIABLES
//    var dataInTable : [String:[String]] = ["FirstSec":["Menu","Past Orders","My Addresses"],
//                                           "Others":["Share App",/*"About Us",*/ "Contact Us",/*"Privacy Policy",*/"Logout"]]
//
//
//    let tabldataFor_LoginUser = ["FirstSec":["Menu","Event List","My Addresses","Past Orders "],
//                                 "Others":["Share App","About Us", "Contact Us","Privacy Policy","Logout"]]
//    let tabldataFor_GuestUser = ["FirstSec":["Menu","Event List"],
//                                 "Others":["Share App","About Us", "Contact Us","Privacy Policy","LogIn"]]
//
//
//    let iconNnTable : [String:[String]] = ["FirstSec":["restaurant-menu@x1","oredrHistory_@x1","location@x1","oredrHistory_@x1"],
//                                           "Others":["ShareApp_@x1","aboutsUs@x1","contactUs@x1","PrivacyPolicy@x1","logOut_@x1"]]
//
//    let segues = ["toHome", "toEvents",  "toAddresses","toOrders","toAboutUs"]
    
    var dataInTable : [String:[String]] = ["FirstSec":["Menu","My Addresses"],
                                           "Others":["Share App",/*"About Us",*/ "Contact Us",/*"Privacy Policy",*/"Logout"]]
    
    
    let tabldataFor_LoginUser = ["FirstSec":["Menu","Event List","My Addresses"],
                                 "Others":["Share App","About Us", "Contact Us","Privacy Policy","Logout"]]
    let tabldataFor_GuestUser = ["FirstSec":["Menu","Event List"],
                                 "Others":["Share App","About Us", "Contact Us","Privacy Policy","LogIn"]]
    
    let tabldataFor_LoginUserOrderAhead = ["FirstSec":["Menu","Event List","Order Ahead Days","My Addresses"],
                                 "Others":["Share App","About Us", "Contact Us","Privacy Policy","Logout"]]
    let tabldataFor_GuestUserOrderAhead = ["FirstSec":["Menu","Event List","Order Ahead Days"],
                                 "Others":["Share App","About Us", "Contact Us","Privacy Policy","LogIn"]]
    
    //oredrHistory_@x1
    
    let iconNnTable : [String:[String]] = ["FirstSec":["restaurant-menu@x1","eventy","location@x1"],
                                           "Others":["ShareApp_@x1","aboutsUs@x1","contactUs@x1","PrivacyPolicy@x1","logOut_@x1"]]
    
    let iconNnTableOrderAhead : [String:[String]] = ["FirstSec":["restaurant-menu@x1","eventy","calen","location@x1"],
                                           "Others":["ShareApp_@x1","aboutsUs@x1","contactUs@x1","PrivacyPolicy@x1","logOut_@x1"]]
    
    let segues = ["toHome", "toEvents","toOrderAhead",  "toAddresses","toAboutUs"]
    
    
    
    
    // MARK: - VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        self.view.clipsToBounds = true
        let version : Any! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let vr = version as! String
        version_lbl.text = "Version \(vr)"
        //let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
        if isUserLoggedIn{
            getuserInformation()
//            if ENABLE_ORDER_AHEAD == true{
//                dataInTable = tabldataFor_LoginUserOrderAhead
//
//            }
//            else{
//            dataInTable = tabldataFor_LoginUser
//            }
        }else{
            
            username_lbl.text = "Log In"
            email_lbl.text = ""
//            if ENABLE_ORDER_AHEAD == true{
//                dataInTable = tabldataFor_GuestUserOrderAhead
//
//            }
//            else{
//            dataInTable = tabldataFor_GuestUser
//            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(userLogInStatusChange), name: NSNotification.Name.init(NotificationName.userLoginStatus), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userInfoUpdate), name: NSNotification.Name.init(NotificationName.userInfoUpdate), object: nil)
    }
    @IBAction func showVersionPopup(_ sender: Any) {
       // self.showSimpleAlert()
    }
    func showSimpleAlert() {
        let version : Any! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        let vr = version as! String
       // version_lbl.text = "Version \(vr)"
        let alert = UIAlertController(title: "New features available! ", message: "(Version \(vr))\n\n➤ Order Ahead Days\n➤ Automatic offers\n➤ Free items",         preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
            UserDefaults.standard.setValue(true, forKey: "newFeatures")
               //Cancel Action
            //Userdegfault truethis
           }))
//           alert.addAction(UIAlertAction(title: "Sign out",
//                                         style: UIAlertAction.Style.default,
//                                         handler: {(_: UIAlertAction!) in
//                                           //Sign out action
//           }))
        alert.view.tintColor = UIColor.init(named: "MaroonTheme")
           self.present(alert, animated: true, completion: nil)
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
        if isUserLoggedIn {
            if ENABLE_ORDER_AHEAD == true{
                dataInTable = tabldataFor_LoginUserOrderAhead
            }
            else{
            dataInTable = tabldataFor_LoginUser
            }
        }else{
            if ENABLE_ORDER_AHEAD == true{
                dataInTable = tabldataFor_GuestUserOrderAhead
            }
            else{
            dataInTable = tabldataFor_GuestUser
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(userLogInStatusChange), name: NSNotification.Name.init(NotificationName.userLoginStatus), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userInfoUpdate), name: NSNotification.Name.init(NotificationName.userInfoUpdate), object: nil)
    }
    @objc func userInfoUpdate(_ sender: NotificationCenter) {
        if DBManager.sharedInstance.get_userInfo_DataFromDB().count != 0{
            let userInfo = DBManager.sharedInstance.get_userInfo_DataFromDB()[0] as UserInfo
            let fname = userInfo.object?.firstName ?? ""
            let mname = userInfo.object?.middleName ?? ""
            let lname = userInfo.object?.lastName ?? ""
            
            
            self.email_lbl.text = (userInfo.object?.email  ?? "")
            self.phone_lbl.text = (userInfo.object?.primaryPhone  ?? "")
            self.username_lbl.text = fname + " " + mname + " " + lname
        }
    }
    
    @objc func userLogInStatusChange(_ sender : NotificationCenter){
        if isUserLoggedIn{
            getuserInformation()
            let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
            if ENABLE_ORDER_AHEAD == true{
                dataInTable = tabldataFor_LoginUserOrderAhead

            }
            else{
            dataInTable = tabldataFor_LoginUser
            }
            table_V.reloadData()
        }else{
            username_lbl.text = "Log In"
            email_lbl.text = ""
            let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
            if ENABLE_ORDER_AHEAD == true{
                dataInTable = tabldataFor_GuestUserOrderAhead

            }
            else{
            dataInTable = tabldataFor_GuestUser
            }
            table_V.reloadData()
        }
    }
    
    func getuserInformation(){
        SomeInformationApi.get_user_info { (success, result) in
            if success{
                guard let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary else{return}
                let middlename = (object.value(forKey: "middleName") as? String ?? "")
                let lastname = (object.value(forKey: "lastName") as? String ?? "")
                self.username_lbl.text = (object.value(forKey: "firstName") as? String ?? "") + " " + middlename + " " + lastname
                self.email_lbl.text = (object.value(forKey: "email") as? String ?? "")
                self.phone_lbl.text = (object.value(forKey: "primaryPhone") as? String ?? "")
            }
        }
    }
    
    
    // MARK: - TABLE VIEW
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataInTable.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            let dataofFirst = dataInTable["FirstSec"]
            return (dataofFirst?.count)!
        }else if section == 1{
            let dataofFirst = dataInTable["Others"]
            return (dataofFirst?.count)!
        }
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SideMenuTVC
        let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
        var iconofFirst = [String]()
        if indexPath.section == 0{
            let dataofFirst = dataInTable["FirstSec"]
            if ENABLE_ORDER_AHEAD == true{
            iconofFirst = iconNnTableOrderAhead["FirstSec"]!
            }
            else{
                iconofFirst = iconNnTable["FirstSec"]!
            }
            cell.title_lbl.text = dataofFirst?[indexPath.row]
            cell.icon_imgV.image = UIImage(named: (iconofFirst[indexPath.row]))
            
        }
        else if indexPath.section == 1{
            let dataofSec = dataInTable["Others"]
            let iconofSec = iconNnTable["Others"]
            cell.title_lbl.text = dataofSec?[indexPath.row]
            cell.icon_imgV.image = UIImage(named: (iconofSec?[indexPath.row])!)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.0
        }else {return 40}
    }
   
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = tableView.frame.height / 8
        return h
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return ""
        }
        return "Others"
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerTitle = view as? UITableViewHeaderFooterView {
            headerTitle.textLabel?.textColor = UIColor.MyTheme.graycolor
            headerTitle.backgroundColor = UIColor.black

        }

    }
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
        }
        else if indexPath.section == 1{
            if indexPath.row == 0{
                shareButtonClicked()
            }
            if indexPath.row == 1{
                sideMenuController?.performSegue(withIdentifier: "toAboutUs", sender: nil)
            }
            else if indexPath.row == 2{
                let vc = secondSBVC("RestrauntInfoVC") as! RestrauntInfoVC
                vc.fromSideMenu = true
                sideMenuController?.embed(centerViewController: vc)
            }
            else if indexPath.row == 3{
                let vc = secondSBVC("PrivacyPolicyVC")
                sideMenuController?.embed(centerViewController: vc)
            }
                //
            
            else if indexPath.row == 4{
                if isUserLoggedIn{
                    let alert = UIAlertController(title: "Confirm Logout...", message: "Do you want to logout?", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        DBManager.sharedInstance.deleteAllFromDatabase()
                        DBManager.sharedInstance.deleteBucketId()
                        isUserLoggedIn = false
                        
                        self.nvmanager.reStartTheApp()
                        
                    })
                    let cncle = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                    alert.addAction(okAction)
                    alert.addAction(cncle)
                    self.present(alert, animated: true, completion: {
                    })
                }
                else{
                   // DBManager.sharedInstance.deleteBucketId()

                    sideMenuController?.performSegue(withIdentifier: "toLogin", sender: nil)
                }
            }
        }
    }
    
    func shareButtonClicked() {
        let textToShare = "Tandoori!  Check out this app!"
        
        if let myWebsite = NSURL(string: "https://itunes.apple.com/in/app/tandoori/id1476393330?mt=8") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = version_lbl
            //            if let popoverController = actionSheet.popoverPresentationController {
            //                popoverController.sourceView = self.view //to set the source of your alert
            //
            //
            //
            //                //            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            //                popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            //                popoverController.sourceRect = chkOutBtn.frame
            //            }
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
}




class SideMenuTVC: UITableViewCell {
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var icon_imgV: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
