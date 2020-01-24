

import Foundation
import UIKit

class PopBtn : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInt()
    }
    
    @IBInspectable var vcid : String?
     var fromSideMenu : Bool?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInt()
    }
    func commonInt(){
        self.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
    }
    @objc func goback(){
        let nv = self.viewContainingController()?.navigationController
        let parentvc = self.viewContainingController()
        if fromSideMenu ?? false{
            parentvc?.sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
            return
        }
        if vcid != nil{
            let vc = secondSBVC(vcid!)
            nv?.popToViewController(vc, animated: false)
        }
        else if nv != nil{
            nv?.popViewController(animated: true)
        }
        else if parentvc?.isModal ?? false {
            parentvc?.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
class DismissBtn : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInt()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInt()
    }
    func commonInt(){
        self.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
    }
    @objc func goback(){
        let nv = self.viewContainingController()
        nv?.dismiss(animated: true, completion: nil)
        
    }
    
}
class MenuBtn : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInt()
    }
    @IBInspectable var vcid : String?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInt()
    }
    func commonInt(){
        self.addTarget(self, action: #selector(menuOpen), for: UIControl.Event.touchUpInside)
    }
    @objc func menuOpen(){
        let vc = self.viewContainingController()
        vc?.sideMenuController?.toggle()
    }
    
}
class PushBtn : UIButton{
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.commonInt()
    }
    @IBInspectable var vcid : String?
    @IBInspectable var heroEnable : Bool = false
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInt()
    }
    func commonInt(){
        self.addTarget(self, action: #selector(goback), for: UIControl.Event.touchUpInside)
    }
    @objc func goback(){
        if vcid == nil{return}
        let nv = self.viewContainingController()?.navigationController
        let vc = secondSBVC(vcid!)
        nv?.hero.isEnabled = heroEnable
        nv?.pushViewController(vc, animated: true)
    }
    
}
