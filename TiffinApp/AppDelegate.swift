// https://github.com/kitasuke/PagingMenuController?utm_source=mybridge&utm_medium=blog&utm_campaign=read_more

//app.promo.TiffinApp
// https://www.appcoda.com/ios-stripe-payment-integration/
// https://i.diawi.com/Bw5Eg1
// Tiffin's India Cafe
// caspart.netsoft.stb
//
//com.sliderDemo.techwiz
// abcd2@gmail.com
// aron@gmail.com
//qwert

import UIKit
import IQKeyboardManagerSwift
import Stripe
import AVFoundation
import GooglePlaces
import SideMenuController
import UserNotifications
import Fabric
import Crashlytics
import Alamofire
import Instabug

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var player: AVAudioPlayer?
    var appIsStarting : Bool = false
    var window: UIWindow?
    let Stripe_a_id = UserDefaults.standard.value(forKey: "Stripe_a_id") as? String
    let s_acc_id = UserDefaults.standard.value(forKey: "s_acc_id") as? String
    
    let Stripe_publishkey = UserDefaults.standard.value(forKey: "Stripe_publishkey") as? String
    var stripeAccountID = String()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
//        let instabugId = "9201b648502e44470a13571c8f2a5aea"
//        Instabug.start(withToken: instabugId, invocationEvents: [.shake, .floatingButton])
//        Instabug.tintColor = UIColor.MyTheme.supportcolor
////        BugReporting.floatingButtonEdge = CGRectEdge(rawValue: 200)!
//        BugReporting.floatingButtonTopOffset = CGFloat(350)
    
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3600) {
//            var alertController = UIAlertController(title: "SCREEN TIMEOUT", message: "", preferredStyle: .alert)
//            var okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
//                UIAlertAction in
//                exit(0)
//            }
//
//            alertController.view.tintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
//            alertController.addAction(okAction)
//
//            self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//            print("kkkkkkkkkkkk")
//        }
        getProDev()
        
        //        if Stripe_a_id == nil || Stripe_a_id == ""{
        //            stripeAccountID = s_acc_id ?? ""
        //        }
        //        else{
        //            stripeAccountID = Stripe_a_id ?? ""
        //        }
        //
        
        //        getProDev()
        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! / 1.25
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.interaction.panningEnabled = false
        SideMenuController.preferences.interaction.swipingEnabled = false
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        
        IQKeyboardManager.shared.disabledToolbarClasses = [STPAddCardViewController.self]
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [STPAddCardViewController.self]
        
        
        
        
        // Stripe.setDefaultPublishableKey(Stripe_publishkey ?? "")
        //        STPAPIClient.shared().stripeAccount = stripeAccountID
        //        // For SDK versions < v19.0.0, set this too:
        //        STPPaymentConfiguration.shared().stripeAccount = stripeAccountID
        //
        //        STPPaymentConfiguration.shared().publishableKey = Stripe_publishkey ?? ""
        
        GMSPlacesClient.provideAPIKey("AIzaSyCdMB0DelVf8IzXVYe7ID-AmeiG5vHP2Mc")
        //        AIzaSyDvi1SyCIaNo31VVAL33k_vCVsfz0j5n7A
        //        registerForRichNotifications()
        Fabric.with([Crashlytics.self])
        
        let data = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
        if (data != nil) {
            self.appIsStarting = true;
        }
        
        self.registerForPushNotifications()
        //         getProDev()
        return true
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
                self.merchant_id()
                //self.getStripeAccountID()
            }else {
                //                   print(" : \(ServerNotResponding)")
                DispatchQueue.main.async {
                    print("...")
                }
                
            }
        }
    }
    func merchant_id(){
        
        var apiurl = URLComponents(string: ApiKeys.merchantID)
        
        if isUserLoggedIn {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken)
            ]
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken)
            ]
            
        }
        
        
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            
            if respose.result.value != nil{
                if let a = respose.result.value as? NSDictionary{
                    
                    if let request_status = a.value(forKey: "request_status") as? Int {
                        if request_status == 1{
                            
                            
                            DBManager.sharedInstance.create_merchantIDData_DB(value: a)
                            
                            let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
                            
                            print(MD.object?.STRIPE_PUBLISHABLE_KEY)
                            
                            let isShopOpen = MD.object?.IS_SHOP_OPEN
                            let PRODUCT_IMAGE_PREVIEW = MD.object?.PRODUCT_IMAGE_PREVIEW
                            UserDefaults.standard.setValue(PRODUCT_IMAGE_PREVIEW, forKey: "PRODUCT_IMAGE_PREVIEW")
                            let merchantIDD = MD.object?.MERCHANT_ID
                            UserDefaults.standard.setValue(merchantIDD, forKey: "m_idd")
                            
                            guard let _ = a.value(forKey: "request_status") as? Int else {
                                return
                            }
                            
                            
                            guard let object = a.value(forKey: "object") as? [String:Any] else {return}
                            
                            STPPaymentConfiguration.shared().publishableKey = object["STRIPE_PUBLISHABLE_KEY"] as! String
                            
                            guard let MERCHANT_ID = object["MERCHANT_ID"] as? String else {return}
                            guard let STATIC_RESOURCE_CATEGORIES_PREFIX = object["STATIC_RESOURCE_CATEGORIES_PREFIX"] as? String else {return}
                            guard let STATIC_RESOURCE_ENDPOINT = object["STATIC_RESOURCE_ENDPOINT"] as? String else{return}
                            guard let STATIC_RESOURCE_SUFFIX = object["STATIC_RESOURCE_SUFFIX"] as? String else{return}
                            guard let STRIPE_ACCOUNT_ID = object["STRIPE_ACCOUNT_ID"] as? String else{return}
                            UserDefaults.standard.setValue(STRIPE_ACCOUNT_ID, forKey: "s_acc_id")
                            UserDefaults.standard.setValue(STRIPE_ACCOUNT_ID, forKey: "stripeIDStatus")
                            
                            guard let ORDER_AHEAD_DAYS = object["ORDER_AHEAD_DAYS"] as? [String] else{return}
                            guard let SHOP_TIMING = object["SHOP_TIMING"] as? [[String:Any]] else{return}

                            guard let ENABLE_ORDER_AHEAD = object["ENABLE_ORDER_AHEAD"] as? Bool else{return}
                            UserDefaults.standard.setValue(ENABLE_ORDER_AHEAD, forKey: "ENABLE_ORDER_AHEAD")

                            
                            print(ORDER_AHEAD_DAYS,"----------")
                            UserDefaults.standard.setValue(ORDER_AHEAD_DAYS, forKey: "ORDER_AHEAD_DAYS")
                            UserDefaults.standard.setValue(SHOP_TIMING, forKey: "SHOP_TIMING")
                            
                            self.getStripeAccountID(merchantIDD: MERCHANT_ID)
                            
                            if let requestId = a.value(forKey: "requestId") as? String{
                            }
                            
                            let urlofProdCat = STATIC_RESOURCE_ENDPOINT+STATIC_RESOURCE_CATEGORIES_PREFIX+MERCHANT_ID+STATIC_RESOURCE_SUFFIX
                            print(urlofProdCat)
                            //   callback(true, respose.result.value, urlofProdCat)
                            guard let _ = object["FEES"] as? String else {
                                return
                            }
                            return
                        }else{
                            //callback(false,a,nil)
                            return
                        }
                    }
                }
                //   callback(false,nil,nil)
                
                
            }else{
                // callback(false, nil, nil)
            }
        }
    }
    
    func getStripeAccountID(merchantIDD : String) {
        
        
        // let merchantid = "c0ba1485965e9595c907f18eca5314cb"
        
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
        
        Alamofire.request("\(ApiKeys.domain)service/status/\(merchantIDD)/WEB", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            debugPrint(response.result)
            print("",response.result.value)
            let json = response.result.value as? [String: Any]
            
            if json != nil { // Check json Data Nil or Not
                let dic = json as NSDictionary?
                
                let object = dic?.value(forKey: "object") as! NSDictionary
                let STRIPE_ACCOUNT_ID = object.value(forKey: "STRIPE_ACCOUNT_ID") as? String
                let STRIPE_PUBLISHABLE_KEY = object.value(forKey: "STRIPE_PUBLISHABLE_KEY") as? String
                
                if STRIPE_ACCOUNT_ID == "" || STRIPE_ACCOUNT_ID == nil{
                    self.stripeAccountID = self.s_acc_id ?? ""
                }
                else{
                    self.stripeAccountID = STRIPE_ACCOUNT_ID ?? ""
                }
                
                // Stripe.setDefaultPublishableKey(Stripe_publishkey ?? "")
                STPAPIClient.shared().stripeAccount = self.stripeAccountID
                // For SDK versions < v19.0.0, set this too:
                STPPaymentConfiguration.shared().stripeAccount = self.stripeAccountID
                
                STPPaymentConfiguration.shared().publishableKey = STRIPE_PUBLISHABLE_KEY ?? self.Stripe_publishkey ?? ""
                
                
                
                UserDefaults.standard.setValue(STRIPE_PUBLISHABLE_KEY, forKey: "Stripe_publishkey")
                UserDefaults.standard.setValue(STRIPE_ACCOUNT_ID, forKey: "Stripe_a_id")
                
                print("STRIPE_ACCOUNT_ID",STRIPE_ACCOUNT_ID)
                
                // UserDefaults.standard.setValue(PROD_STATUS, forKey: "PROD_STATUSDev")
                
                
            }else {
                //                   print(" : \(ServerNotResponding)")
                DispatchQueue.main.async {
                    print("...")
                }
                
            }
        }
    }
    
    //
    // This method will be called when app received push notifications in foreground
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("remote notification : \n \n" , userInfo ,"\n\n\n\n")
        
        saveNotifications(userInfo: userInfo)
        let state : UIApplication.State = application.applicationState
        if state == .background || state == .inactive || !self.appIsStarting {
            if let _ = userInfo["aps"] as? NSDictionary{
                
            }
            else if state == .inactive && self.appIsStarting{
                // user tapped notification
                completionHandler(UIBackgroundFetchResult.newData);
            }
            else{
                // app is active
                completionHandler(UIBackgroundFetchResult.noData);
            }
        }
        pushNotificationHandler(userInfo: userInfo)
    }
    
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            self.getNotificationSettings()
        }
        
    }
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func pushNotificationHandler(userInfo: Dictionary<AnyHashable,Any>) {
        // Parse the aps payload
        //        let apsPayload = userInfo["aps"] as! [String: AnyObject]
        //        UserDefaultsDoings.saveRemoteNotificationDate(userInfo: apsPayload)
        
        
        // push format befor 1 feb
        //    {
        //        "order_id": "1",
        //        "message": "You receviced new order please confirm. check email/sms for further detail Order No #1",
        //        "APNS": {
        //            "aps": {
        //                "alert": "You receviced new order please confirm. check email/sms for further detail Order No #1",
        //                "sound": "alarm03.wav",
        //                "custom-payload-id": "custompayloadid"
        //            }
        //        }
        //    }
        
        // push format after 1 feb
        //
        //        {
        //            "APNS": "{default": "",
        //            "aps": {
        //                "alert": "You receviced new order please confirm. check email/sms for further detail Order No #3016",
        //                "sound": "alarm03.wav",
        //                "click_action": "#"
        //            },
        //            "orderid": 3016,
        //            "content-available": 1,
        //            "userid": 3
        //        }
        //         Play custom push notification sound (if exists) by parsing out the "sound" key and playing the audio file specified
        //         For example, if the incoming payload is: { "sound":"tarzanwut.aiff" } the app will look for the tarzanwut.aiff file in the app bundle and play it
        //                if let mySoundFile : String = apsPayload["sound"] as? String {
        //                    playSound(fileName: mySoundFile)
        //                }
        
        //        if isUserLogin{
        //            presentAlertVC()
        //        }
        
        
        
        
    }
    // Play the specified audio file with extension
    func playSound(fileName: String) {
        
        var sound: SystemSoundID = 0
        if let soundURL = Bundle.main.url(forAuxiliaryExecutable: fileName) {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
            AudioServicesPlaySystemSound(sound)
        }
    }
    func saveNotifications(userInfo : Dictionary<AnyHashable,Any>){
        let payload = userInfo as! [String: AnyObject]
        //        UserDefaultsDoings.saveRemoteNotificationDate(userInfo: payload)
        //        _ = DBManager.sharedInstance.createNotificationData(value: (userInfo as NSDictionary))
        
    }
    
    
    
    
    
    
    func registerForRichNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (granted:Bool, error:Error?) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
        }
        
        //actions defination
        let action1 = UNNotificationAction(identifier: "action1", title: "Action First", options: [.foreground])
        let action2 = UNNotificationAction(identifier: "action2", title: "Action Second", options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        print("\n willPresent notification \n")
        print(content)
        completionHandler([.alert, .sound, .badge])
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        //        UserDefaultsDoings.saveDeviceToken(token: token)
        //        UserDefaultsDoings.saveStateIsRegisterForRemoteLOcation(state: true)
        print("Device Token: \(token) \n")
        UserDefaults.standard.setValue(token, forKey: "deviceToken")
        NotificationCenter.default.post(name: NSNotification.Name.init("deviceToken"), object: nil)
    }
    
    
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
}

