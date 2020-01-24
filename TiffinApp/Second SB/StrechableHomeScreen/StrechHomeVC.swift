
import UIKit
import Crashlytics
import Alamofire

class StrechHomeVC: UIViewController {
    
    var accesstoken = String()
    var accessT = String()
    var emailuser = String()
    var timingArr = NSArray()
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var menubtn : MenuBtn!
    @IBOutlet weak var menuImgv : UIImageView!
    @IBOutlet weak var searchImgv : UIImageView!
    @IBOutlet weak var timingTableView: UITableView!
    @IBOutlet weak var cross: UIButton!
    @IBOutlet weak var timeView: UIView!
    
    var collapseCntrl : CollapseControl!
    var productArr = [String:[Products]]()
    var categories : [String] = [String]()
    
    @IBOutlet weak var floatingBasketView: FloatingBasketView!
    
    @IBOutlet weak var maintainanceModeView: UIView!
    
    var items = [ItemsObjectOrdersData]()
    var orderData = CartData()
    var selecttitleIndex : Int?{
        didSet{
            if selecttitleIndex != nil{
                upperView?.selectionList.selectedButtonIndex = selecttitleIndex!
            }
        }
    }
    var upperView : CollapseViewHeader?
    var restrauntOpen = true
    @IBOutlet weak var phoneTitleBtn: UIButton!
    @IBAction func searchBtnAction(_ sender: Any) {
        let vc = secondSBVC("SearchProductVC")
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func crossBtn(_ sender: Any) {
        timeView.isHidden = true
        
    }
    @IBAction func crossMaintainceMode(_ sender: Any) {
        exit(0)
    }
    @IBAction func phoneCall(_ sender: Any) {
        
        if  DBManager.sharedInstance.get_merchntdetail_DataFromDB().count != 0 {
            let MD  = DBManager.sharedInstance.get_merchntdetail_DataFromDB()[0] as MerchantDetail
            let phoneNumberr = MD.object?.MERCHANT_CONTACT ?? ""
            let ph = phoneNumberr.removingWhitespaces()
            callNumber(phoneNumber: "\(ph)")
        }
        else {}
    }
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            print(phoneCallURL)
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
}

extension StrechHomeVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUserLoggedIn == true {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accessT = (logindata.object?.access_token)!
            
            emailuser = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            //            accessT = UserDefaults.standard.value(forKey: "accessT") as! String
        }
        else {
            emailuser = ""
            accessT = ""
        }
        
        
        //        let emailuser = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
        
        RegisterApi.registerDevice(email: emailuser, accesstoken: accessT, callback: { (succ, rst, err) in
            //            self.spinnerV.isHidden = true
            if succ{
                
            }
            else {
                var message = "Something went wrong"
                print(message)
                //                self.showAlert(msg: message, title: "Error")
            }
        })
        
        
        
        
        if maintainanceModeView.isHidden == false {
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        }
        self.maintainanceModeView.isHidden = true
        self.timeView.isHidden = true
        //        self.timingTableView.delegate = self
        //self.timingTableView.dataSource = self
        
        let top = CollapsablePublicTerms().hederViewHeight-(CollapsablePublicTerms.topSafeAreaMargin ?? 20)
        self.setUpperView()
        collectionView.contentInset = UIEdgeInsets(top: top , left: 0, bottom: 50, right: 0)
        self.setcollectionViewiewDataSet()  // define in extension i.e. file StrechableHome
        collectionView.register(UINib(nibName: "CollectionVXibs", bundle: nil), forCellWithReuseIdentifier: "HomeCVC")
        collectionView.register(UINib(nibName: "CvcForSectionHeader", bundle: nil), forCellWithReuseIdentifier: "sectionCell")
        self.checkRestrauntIsOpen()
        
        self.getAlOredrs(completion: {
            
            (succ,error) in
            
            
            if !succ{
                
                print(error)
                if (error?.contains("Invalid") ?? false) {
                    
                    return
                    
                }
                
                
            }
            else{
            }
            
        })
        
    }
    
    @objc func appMovedToBackground() {
        
        let MM = UserDefaults.standard.value(forKey: "MM") as? Bool
        if MM == true {
            exit(0)
        }
        else {
            print("yo")
        }
    }
    
    func getTiming() {
        
        
        var header : [String:String] = ["authorization":""]
        
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            header["authorization"] = "Bearer " + accesstoken
            print(accesstoken)
        }
        else{
            let accesstoken = GuestUserCredential.access_token
            header["authorization"] = "Bearer " + accesstoken
            print(accesstoken)
        }
        
        let parameters: [String: Any] = [
            
            
            :]
        print("parameters==========\(parameters)")
        
        Alamofire.request(ApiKeys.restaurantTiming_v2, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { response in
            debugPrint(response.result)
            print("",response.result.value)
            let json = response.result.value as? [String: Any]
            
            if json != nil { // Check json Data Nil or Not
                let dic = json as NSDictionary?
                
                let data = dic?.value(forKey: "data") as! NSArray
                
                print("time",data)
                
                self.timingArr = data
                self.timingTableView.reloadData()
                self.checkRestrauntIsOpen()
                
            }
                
            else {
                print("fail")
                DispatchQueue.main.async {
                    
                }
                
            }
        }
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collapseCntrl.setUp(frame: self.view.frame)
        collapseCntrl.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
        
        
        //
        //        RegisterApi.merchant_detail { (true, success) in
        //             let merchantidOBJ = DBManager.sharedInstance.get_merchntId_DataFromDB() [0] as MerchantID
        //            let isshopOpen = merchantidOBJ.object?.IS_SHOP_OPEN
        //            if isshopOpen == "false" {
        //
        //                self.timingTableView.delegate = self
        //                self.timingTableView.dataSource = self
        //
        //                self.timeView.isHidden = false
        //                self.getTiming()
        //
        //
        //
        //                print("show timing")
        //            }
        //            else {
        //                self.timeView.isHidden = true
        //                print("opennnnn")
        //            }
        //
        //        }
        // self.checkRestrauntIsOpen()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let urlOfprodCAt = String()
        RegisterApi.merchant_id() { (success, result,urlOfprodCAt) in
            if let a = result as? NSDictionary{
                
                
                
                
                guard let object = a.value(forKey: "object") as? [String:Any] else {return}
                
                
                guard let IS_SHOP_OPEN = object["IS_SHOP_OPEN"] as? String else {return}
                
                guard let MAINTENANCE_MODE = object["MAINTENANCE_MODE"] as? String else {return}
                let checkMaintainence = "True"
                if MAINTENANCE_MODE == checkMaintainence.uppercased() || MAINTENANCE_MODE == checkMaintainence.lowercased() || MAINTENANCE_MODE == "True"{
                    if  DBManager.sharedInstance.get_merchntdetail_DataFromDB().count != 0 {
                        let MD  = DBManager.sharedInstance.get_merchntdetail_DataFromDB()[0] as MerchantDetail
                        let phoneNumber = MD.object?.MERCHANT_CONTACT ?? ""
                        //
                        
                        //show maintance screen
                        self.phoneTitleBtn.setTitle("Ph:  \(phoneNumber)", for: .normal)
                        self.maintainanceModeView.isHidden = false
                        UserDefaults.standard.setValue(true, forKey: "MM")
                    }
                    else{}
                }
                else {
                    UserDefaults.standard.setValue(false, forKey: "MM")
                    self.maintainanceModeView.isHidden = true
                    let checkIS_SHOP_OPEN = "False"
                    if IS_SHOP_OPEN == checkIS_SHOP_OPEN.uppercased() || IS_SHOP_OPEN == checkIS_SHOP_OPEN.lowercased() || IS_SHOP_OPEN == "False"{
                        //
                        self.timingTableView.delegate = self
                        self.timingTableView.dataSource = self
                        
                        self.timeView.isHidden = false
                        self.getTiming()
                        
                        
                        
                        print("show timing")
                    }
                    else {
                        self.timeView.isHidden = true
                        print("opennnnn")
                    }
                    
                }
                
            }
            
            
        }
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    func setUpperView(){
        let top = (CollapsablePublicTerms.topSafeAreaMargin) ?? 0
        let frame = CGRect(x: 0, y: -top, width: UIScreen.main.bounds.size.width, height: CollapsablePublicTerms().hederViewHeight)
        upperView = CollapseViewHeader(frame: frame)
        self.view.insertSubview(upperView!, belowSubview: menubtn)
        collapseCntrl = CollapseControl(collapseV: upperView!)
        
        upperView!.selectCategory = {
            (title,index) in
            let indexpath  = IndexPath(row: 0, section: index)
            let att = self.collectionView.layoutAttributesForItem(at: indexpath )!.frame
            //            let offset_y = CollapsablePublicTerms().hederViewHeight - (CollapsablePublicTerms().hederViewHeight/2.5)
            let offset_y =  (CollapsablePublicTerms().hederViewHeight/2.5)
            let origin = CGPoint(x: att.origin.x, y: att.origin.y-offset_y)
            self.collectionView.setContentOffset(origin, animated: true)
        }
    }
    
    func checkRestrauntIsOpen(){
        SomeInformationApi.checkrestrauntIsOpen { (open, err) in
            if err != nil{
                return
            }
            self.restrauntOpen = open
            self.collectionView.reloadData()
        }
        
    }
    
    func getAlOredrs(completion: @escaping (Bool,String?)->()){
        
        
        
        ProductsApi.detail_Cart_Info { (success, result,_) in
            
            
            
            if success{
                print("----",self.self.items.count)
                
                
            }
            
            
            
            if DBManager.sharedInstance.get_CartData_DataFromDB().count > 0 {
                
                self.orderData = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
                
                if self.orderData.object?.items.count != 0 {
                    self.floatingBasketView.isHidden = false
                    
                }
                else {
                    self.floatingBasketView.isHidden = true
                }
                
            }
            else{
                if result == nil{
                    completion(false, nil)
                }else{
                    if let object = (result as? NSDictionary)?.value(forKey: "object") as? NSDictionary{
                        if let error = object.value(forKey: "error") as? String{
                            completion(false, error)
                        }
                    }
                    self.items.removeAll()
                }
                
            }
            
        }
        
        
        
    }
    
    func getPostion_wrt_superview(position : CGFloat)->CGFloat{
        
        let contentSize = self.collectionView.contentSize
        let myvcHeight = UIScreen.main.bounds.height
        let positionwrt = (myvcHeight*position)/contentSize.height
        return positionwrt
    }
    func toAddmore(offset : CGFloat)->CGFloat{
        let myvcHeight = UIScreen.main.bounds.height
        let toAdd = myvcHeight-offset
        return toAdd
    }
}

extension StrechHomeVC : CollapseControlDelegate{
    func collapseFully() {
        UIView.animate(withDuration: 0.2) {
            self.menuImgv.tintColor = UIColor.black
            self.searchImgv.tintColor = UIColor.black
        }
        
    }
    
    func strechProportionally() {
        UIView.animate(withDuration: 0.2) {
            self.menuImgv.tintColor = UIColor.white
            self.searchImgv.tintColor = UIColor.white
        }
        
    }
}
extension StrechHomeVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timingArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("Timing", owner: Any?.self, options: nil)?.first as! Timing
        let dic:NSDictionary = timingArr[indexPath.row] as! NSDictionary
        
        //        if let nameTxt:String = dic.value(forKey: "name") as? String {
        //            cell.nameLbl.text = nameTxt
        //        }
        //
        //        if  let time:String = dic.value(forKey: "time") as? String {
        //            cell.timeLbl.text = "Opening Hours \(time)"
        //        }
        
        cell.nameLbl.text = ((dic.value(forKey: "openingDay") as? String)!) + " - " +  (dic.value(forKey: "closingDay") as! String)
        
        
        cell.timeLbl.text = "Opening Hours " + (dic.value(forKey: "openingTime") as! String) +  " - "  + (dic.value(forKey: "closingTime") as! String)
        
        cell.typeLbl.text = dic.value(forKey: "name") as? String
        
        cell.timingTypeLbl.text = dic.value(forKey: "timingType") as? String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
