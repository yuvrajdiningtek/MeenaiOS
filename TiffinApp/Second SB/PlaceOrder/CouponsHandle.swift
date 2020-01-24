
import UIKit
import Foundation
import DropDown
import SCLAlertView
class CouponsHandle: NSObject {
    
    var applybtn : UIButton!
    var dropDownBtn : UIButton!
    var couponRateLbl : UILabel!
    var applied_coupons : [String:String]?
    
    
    private var dataSource : [CouponsModel] = [CouponsModel]()
    private var dropDown : DropDown = DropDown()
    private var dropdowndatasource = [String](){
        didSet{
            self.setDropDown(ds: self.dropdowndatasource)
        }
    
    }
    init(applybtn : UIButton,dropdownanchorBtn : UIButton, couponrateLbl : UILabel, appliedCoupon : [String:String]?) {
        super.init()
        self.applybtn = applybtn
        self.couponRateLbl = couponrateLbl
        self.applied_coupons = appliedCoupon
        self.dropDownBtn = dropdownanchorBtn
        commonInit()
    }
    
    func commonInit(){
        
        if applied_coupons != nil , (applied_coupons?.count ?? 0) > 0{
            for (key,v) in applied_coupons!{
                set_btn_remove()
                dropDownBtn.setTitle(key, for: .normal)
                couponRateLbl.text = v
            }
        }
        self.get_coupons { (_, _) in
            
        }
    }
    
    func showDropDown(){
        
        dropDown.show()
        
    }
    func setDropDown(ds : [String]){
        
        dropDown.direction = .any
        dropDown.dataSource = ds
        dropDown.anchorView = dropDownBtn
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropDownBtn.setTitle(item, for: .normal)
            self.couponRateLbl.text = self.dataSource[index].descriptions
            
            if self.applied_coupons != nil{
                if self.applied_coupons!.contains(where: { (key,v) -> Bool in
                    if key == item{
                        return true
                    }
                    return false
                }){
                    self.set_btn_remove()
                }else{
                    self.set_btn_apply()
                }
                
            }
        }
        
    }
    
    private func set_btn_apply(){
        self.applybtn.tag = 0
        self.applybtn.setTitle("Apply", for: .normal)
    }
    private func set_btn_remove(){
        self.applybtn.tag = 1
        self.applybtn.setTitle("Remove", for: .normal)
    }
    
    func get_coupons(compltion : @escaping (Bool,[CouponsModel])->()){
        SomeInformationApi.get_coupons { (succ, couponsarr) in
            if succ{
                self.dropdowndatasource.removeAll()
                for i in couponsarr{
                    self.dropdowndatasource.append(i.name)
                }
                self.dataSource = couponsarr
                compltion(true,couponsarr)
            }else{
                Message.showErrorOnTopStatusBar(message: "unknown error while fetching coupons")
                compltion(false,couponsarr)
            }
        }
    }
    
    func applyCoupon(){
        if applybtn.tag == 0{
            
            add_coupon(coupon: dropDownBtn.currentTitle ?? "")
        }
        else if applybtn.tag == 1{
            delete_coupon(coupon: dropDownBtn.currentTitle ?? "")
        }
    }
    
    private func add_coupon(coupon name : String){
//        self.activityIndicator.startAnimating()
        ProductsApi.add_coupen(rule: name) { (success, rst,err) in
//            hideactivityIndicator(activityIndicator: activityIndicator)
//            self.activityIndicator.stopAnimating()
            if success{
                self.set_btn_remove()
                self.applied_coupons = [name:""]
            }else{
                guard let result =  rst as? NSDictionary else{SCLAlertView().showError("unknown error");return}
                guard let object = result.value(forKey: "object") as? NSDictionary else{SCLAlertView().showError("unknown error");return}
                guard let error = object.value(forKey: "error") as? String else{SCLAlertView().showError("unknown error");return}
                SCLAlertView().showError(error)
            }
        }
        
    }
    private func delete_coupon(coupon name : String){
//        self.activityIndicator.startAnimating()
        
        ProductsApi.delete_coupon(rule: name) { (success, rst) in
//            hideactivityIndicator(activityIndicator: activityIndicator)
//            self.activityIndicator.stopAnimating()
            if success {
                self.set_btn_apply()
                self.applied_coupons = nil
                
            }else{
                guard let result =  rst as? NSDictionary else{SCLAlertView().showError("unknown error");return}
                guard let object = result.value(forKey: "object") as? NSDictionary else{SCLAlertView().showError("unknown error");return}
                guard let error = object.value(forKey: "error") as? String else{SCLAlertView().showError("unknown error");return}
                SCLAlertView().showError(error)
            }
        }
    }

}
