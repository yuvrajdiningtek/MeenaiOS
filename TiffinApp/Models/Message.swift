

import Foundation
import UIKit
import SwiftMessages


class Message : NSObject{
    
    class func showErrorMessage(style : SwiftMessages.PresentationStyle, message : String,title  : String){
        let success = MessageView.viewFromNib(layout: .messageView)
        success.configureTheme(.error)
        success.configureDropShadow()
        success.configureContent(title: title, body: message)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = style
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        successConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: successConfig, view: success)
        
    }
    class func showErrorOnTopStatusBar(message : String,style : SwiftMessages.PresentationStyle = .top,bgColor : UIColor = UIColor.red){
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.backgroundView.backgroundColor = bgColor
        status.bodyLabel?.textColor = UIColor.white
        status.configureContent(body: message)
        status.configureTheme(.error)
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        statusConfig.presentationStyle = style
        statusConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: statusConfig, view: status)
    }
    
    class func present_TheNetworkUnreachableWarning(){
        let error = MessageView.viewFromNib(layout: .cardView)
        error.configureTheme(.error)
        error.configureContent(title: "Error", body: "Network not Reachable!")
        
        var Config = SwiftMessages.defaultConfig
        Config.presentationStyle = .bottom
        Config.duration = .seconds(seconds: 2)
        
        
        
        SwiftMessages.show(config: Config, view: error)
        
    }
    
    class func showSuccessmsg(style : SwiftMessages.PresentationStyle, message : String,title  : String = "Success", btnAction : (()->())? = nil){
        let success = MessageView.viewFromNib(layout: .centeredView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: title, body: message)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        if btnAction != nil{
            success.button?.setTitle("OK", for: .normal)
            success.buttonTapHandler = {
                (_) in
                btnAction?()
            }
        }
        
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: successConfig, view: success)
    }
    
    class func showLoaderOnStatusBar(style : SwiftMessages.PresentationStyle = .top){
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.configureTheme(.warning)
        status.configureContent(body: "Processing...")
        
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        statusConfig.presentationStyle = style
        statusConfig.duration = .forever
        SwiftMessages.show(config: statusConfig, view: status)
    }
    class func showWarningOnStatusBar(style : SwiftMessages.PresentationStyle = .top, msg : String){
        let status = MessageView.viewFromNib(layout: .statusLine)
        status.configureTheme(.warning)
        status.configureContent(body: msg)
        
        var statusConfig = SwiftMessages.defaultConfig
        statusConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        statusConfig.presentationStyle = style
        statusConfig.duration = .seconds(seconds: 2)
        SwiftMessages.show(config: statusConfig, view: status)
    }
    class func hideMsgView(){
        SwiftMessages.hideAll()
    }
    class func addTipView(tipchnage : ((String)->())?) {
        let view: AddTipView = try! SwiftMessages.viewFromNib()
        view.tipChange = tipchnage
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    class func updatteQtyOfProductView() {
        let view: UpdateQtyView = try! SwiftMessages.viewFromNib()
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
    }
    
    
    
}
