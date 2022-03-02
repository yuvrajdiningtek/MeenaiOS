

import UIKit
import NVActivityIndicatorView
import Alamofire

class SplashVC: UIViewController {
    
    @IBOutlet weak var  progressBar : UIProgressView!
    @IBOutlet weak var  loader : NVActivityIndicatorView!
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        if self.networkRechablity(){
            self.setProgress(progress: 0.1)
            // 1 check network rechability
            getProDev()
            //             self.callApis()
            loader.startAnimating()
        }
        else {
            Message.showErrorOnTopStatusBar(message: "Your internet connection is not available")
        }
    }
    
    
    func initialapiCall( completion : @escaping (Bool)->() ){
        IntialSetUp().do_intial_api_call(completion: { (succ) in
            completion(succ)
        })
    }
    func getProductCategories( completion : @escaping (Bool)->() ){
        
        ProductsApi.ProductCat { (succ, rst) in
            self.progressBar.setProgress(0.4, animated: true)
            GetData.getTimingOfRestrauntV2FromApi(callback: { (_) in
                self.progressBar.setProgress(0.6, animated: true)
                completion(succ)
            })
        }
        
    }
    func getProDev() {
        
        
        let merchantid = "80ce8de93f71d4b188e62d10fe56eff2"
        
        let version : Any! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
        
        print(version)
        let vr = version as! String
        let headers:HTTPHeaders = [
            "Content-Type": "application/json"
            // "Authorization" : "bearer " + auth_token
        ]
        let parameters: [String: Any] = [
            
            
            :]
        print("parameters==========\(parameters)")
        
        Alamofire.request("https://prod.diningtek.com/service/status/\(merchantid)/TANDOORI-i\(vr)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response.result)
            print("",response.result.value)
            let json = response.result.value as? [String: Any]
            
            if json != nil { // Check json Data Nil or Not
                let dic = json as NSDictionary?
                
                let object = dic?.value(forKey: "object") as! NSDictionary
                let PROD_STATUS = object.value(forKey: "PROD_STATUS") as! String
                
                print("PROD_STATUS",PROD_STATUS)
                
                // UserDefaults.standard.setValue(PROD_STATUS, forKey: "PROD_STATUSDev")
                let checkProdStatus = "false"
                if PROD_STATUS == checkProdStatus.uppercased() || PROD_STATUS == checkProdStatus.lowercased() || PROD_STATUS == "False"{
                    ApiKeys.domain = "https://in-prod.diningtek.com/"
                    
                }
                else {
                    ApiKeys.domain = "https://in-prod.diningtek.com/"
                }
                self.callApis()
                //self.getStripeAccountID()
            }else {
                //                   print(" : \(ServerNotResponding)")
                DispatchQueue.main.async {
                    print("...")
                }
                
            }
        }
    }
    
    
    
    
    func product_present_in_DataBase() -> Bool{
        
        guard let _ = GetData().getAllProductsFromDataBase() else{
            return false
        }
        return true
        
    }
    func networkRechablity()->Bool{
        
        return NetworkManager.isConnectedToInternet()
        
    }
    
    
    func callApis(){
        
        if self.networkRechablity(){
            self.setProgress(progress: 0.1)
            
            self.self.deleteAllFromDataBse()
            self.initialapiCall { (succ) in
                self.setProgress(progress: 0.2)
                
                self.getProductCategories(completion: { (succ) in
                    self.setProgress(progress: 0.8)
                    if succ{
                        self.setProgress(progress: 1)
                        self.navigate()
                        return
                    }else{
                        // 3 if api response is not coming check data present in database
                        if self.product_present_in_DataBase(){
                            self.setProgress(progress: 1)
                            self.navigate()
                            return
                        }
                        Message.showErrorOnTopStatusBar(message: "Something went wrong")
                    }
                })
                
            }
            
            
        }
        else{
            Message.showErrorOnTopStatusBar(message: "Network not reachable")
            
            // 2 if network not reachable check data present in databse
            if product_present_in_DataBase(){
                self.progressBar.setProgress(1, animated: true)
                navigate()
                return
            }
        }
        
    }
    func deleteAllFromDataBse(){
        let bucketid = DBManager.sharedInstance.getBucketId()
        if isUserLoggedIn{
            var allobjs = DBManager.sharedInstance.getallObjectsOfRealm()
            allobjs.removeFirst()
            allobjs.removeFirst()
            for i in allobjs{
                let db = DBManager.sharedInstance.database
                let obj = db.objects(i)
                try! db.write {
                    db.delete(obj)
                }
            }
        }else{
            DBManager.sharedInstance.deleteAllFromDatabase()
        }
        DBManager.sharedInstance.saveBuketId(bucket: bucketid ?? "")
        
    }
    
    
    
    func navigate(){
        //        if DBManager.sharedInstance.get_loginUser_DataFromDB().count != 0{
        //            self.present(secondSBVC("SideMenuHandlerVC"), animated: false, completion: nil)
        //        }else{
        //            self.present(mainSBVC("loginNavC"), animated: false, completion: nil)
        //        }
        self.setProgress(progress: 1)
        self.nvmanager.makeHomeVCAsRootVC()
    }
}
extension SplashVC{
    
    func setProgress(progress : Float){
        DispatchQueue.main.async {
            self.progressBar.setProgress(progress, animated: true)
        }
        
    }
    
    func animateProgressBar(){
        
        UIView.animate(withDuration: 0.4, animations: {
            self.progressBar.setProgress(1.0, animated: true)
        }) { (_) in
            UIView.animate(withDuration: 0.4, animations: {
                self.progressBar.setProgress(0.0, animated: true)
            }) { (_) in
                self.animateProgressBar()
            }
        }
    }
}
