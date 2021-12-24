

import Foundation
import UIKit
import UserNotifications
import Stripe
import IQKeyboardManagerSwift
extension UIViewController: UNUserNotificationCenterDelegate{
    
    var nvmanager : NavigationManager{
        return NavigationManager(vc : self)
    }
    var isModal: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
    
    func showAlert(msg : String?, title : String?){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(msg : String?, title : String?,completion : @escaping (()->())){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {
            (_) in
            completion()
        })
        let cancelaction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (_) in
            
        })
        alert.addAction(action)
        alert.addAction(cancelaction)
        self.present(alert, animated: true) {
            
        }
    }
    func showAlertForEnablePushNotification(actionWork : (()->())?, cancelWork : (()->())? ){
        let title = "Allow Push Notifications"
        let message = " Please enable push notifications for this app."
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (_) in
            if let a = cancelWork{
                a()
            }
        }
        alert.addAction(action)
        let action2 = UIAlertAction(title: "Allow", style: .default) { (_) in
            if let a = actionWork{
                a()
            }
        }
        alert.addAction(action2)
        self.present(alert, animated: true) {
            
        }
    }
    
    enum Theme: String {
        static let count = 3
        case Default = "Default"
        case CustomDark = "Custom - Dark"
        case CustomLight = "Custom - Light"
        
        init?(row: Int) {
            switch row {
            case 0: self = .Default
            case 1: self = .CustomDark
            case 2: self = .CustomLight
            default: return nil
            }
        }
        
        var stpTheme: STPTheme {
            switch self {
            case .Default:
                return STPTheme.default()
            case .CustomDark:
                let theme = STPTheme.default()
                theme.primaryBackgroundColor = UIColor.white
                theme.secondaryBackgroundColor = UIColor.MyTheme.marooncolor
                theme.primaryForegroundColor = UIColor.white
                theme.secondaryForegroundColor = UIColor(red:130.0/255.0, green:147.0/255.0, blue:168.0/255.0, alpha:255.0/255.0)
                theme.accentColor = UIColor(hex: 0xFD9927)
                
                theme.errorColor = UIColor(red:237.0/255.0, green:83.0/255.0, blue:69.0/255.0, alpha:255.0/255.0)
                return theme
            case .CustomLight:
                let theme = STPTheme.default()
                theme.primaryBackgroundColor = UIColor(red:230.0/255.0, green:235.0/255.0, blue:241.0/255.0, alpha:255.0/255.0)
                theme.secondaryBackgroundColor = UIColor.white
                theme.primaryForegroundColor = UIColor(red:55.0/255.0, green:53.0/255.0, blue:100.0/255.0, alpha:255.0/255.0)
                theme.secondaryForegroundColor = UIColor(red:148.0/255.0, green:163.0/255.0, blue:179.0/255.0, alpha:255.0/255.0)
                theme.accentColor = UIColor(red:101.0/255.0, green:101.0/255.0, blue:232.0/255.0, alpha:255.0/255.0)
                theme.errorColor = UIColor(red:240.0/255.0, green:2.0/255.0, blue:36.0/255.0, alpha:255.0/255.0)
                return theme
            }
        }
    }
    
    
    //for displaying notification when app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .sound])
    }
    
    // For handling tap and user actions
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    func goToCardScreen(delegate : STPAddCardViewControllerDelegate , amount : String){
        STPTheme.default().accentColor = UIColor.MyTheme.supportcolor

        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem?.tintColor = .white
               navigationItem.rightBarButtonItem?.tintColor = .white
        let addCardViewController = STPAddCardViewController()
       
//        addCardViewController.
        self.navigationController?.navigationBar.barTintColor = UIColor.MyTheme.marooncolor
//        self.navigationController?.navigationBar.stp_theme =  Theme.CustomDark.stpTheme
        addCardViewController.title = "Pay \(amount)"
        addCardViewController.delegate = delegate
        addCardViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
        
        
        Global().setStripePublishKey()
        IQKeyboardManager.shared.enable = false
        self.navigationController?.pushViewController(addCardViewController, animated: true)
        addCardViewController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        addCardViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
            self.navigationItem.backBarButtonItem?.title = "Back"
    }
}


