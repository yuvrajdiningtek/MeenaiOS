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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var player: AVAudioPlayer?
    var appIsStarting : Bool = false
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        getProDev()
        SideMenuController.preferences.drawing.sidePanelWidth = (window?.frame.width)! / 1.25
        SideMenuController.preferences.drawing.sidePanelPosition = .overCenterPanelLeft
        SideMenuController.preferences.interaction.panningEnabled = false
        SideMenuController.preferences.interaction.swipingEnabled = false
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses = [STPAddCardViewController.self]
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [STPAddCardViewController.self]
        
        STPPaymentConfiguration.shared().publishableKey = StripConstants.publishableKey
        
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

