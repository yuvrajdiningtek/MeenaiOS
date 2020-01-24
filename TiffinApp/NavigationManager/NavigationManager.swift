

import Foundation
import UIKit

class NavigationManager{
    
    var viewcontroller : UIViewController?
    init(vc : UIViewController?) {
        self.viewcontroller = vc
    }
    
    func makeHomeVCAsRootVC(){
        let vc = secondSBVC("SideMenuHandlerVC")
        let application = UIApplication.shared
        if let window = application.keyWindow{
            UIView.transition(with: window, duration: 0.5, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                window.rootViewController = vc
            }, completion: { (_) in
                window.makeKey()
                window.makeKeyAndVisible()
            })
        }
    }
    func reStartTheApp(){
        
        let vc = mainSBVC("SplashVC")
        let application = UIApplication.shared
        if let window = application.keyWindow{
            UIView.transition(with: window, duration: 0.5, options:UIView.AnimationOptions.transitionCrossDissolve, animations: {
                window.rootViewController = vc
            }, completion: { (_) in
                window.makeKey()
                window.makeKeyAndVisible()
            })
        }
    }
    
    
}
