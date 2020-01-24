
import Foundation
import UIKit
import DropDown
import SCLAlertView
import Stripe

class CheckOutViewModel : NSObject{
    
    var cartData : CartData = CartData()
    var products : [ItemsObjectOrdersData] = [ItemsObjectOrdersData]()
    struct CouponData {
        var name:String = ""
        var description:String = ""
        var expired:Int = 0
        
        init(dict : NSDictionary) {
            self.name = dict.value(forKey: "name") as? String ?? ""
            self.description = dict.value(forKey: "description") as? String ?? ""
            self.expired = dict.value(forKey: "expired") as? Int ?? 0
        }
    }
    override init() {
        super.init()
        _ = getCartDataFromDB()
    }
    
    
    func getCartDataFromDB()->(CartData,[ItemsObjectOrdersData]){
        if DBManager.sharedInstance.get_CartData_DataFromDB().count != 0{
            cartData = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
            let item  = cartData.object?.items
            guard let _ = item else {return (cartData,products)}
            var items  : [ItemsObjectOrdersData] = [ItemsObjectOrdersData]()
            for i in item!{
                items.append(i)
            }
            products = items
        }
        return (cartData,products)
    }
    func calculate_total_items()->Int{
        var totalItems : Double = 0.0
        for item in products{            
            let quantity = item.qty
            totalItems = totalItems + quantity
        }
        return Int(totalItems)
    }
    
    func getSubTotal()->String{
        let subtotal = cartData.object?.sub_total ?? 0
        return cleanDollars(String(describing: subtotal))
    }
    func getTotalPrice()->String{
        let total_amount = cartData.object?.total_amount ?? 0
        return cleanDollars(String(describing: total_amount))
    }
    func getTipAmountAndRate()->(String,String){
        if let tip = cartData.object?.fees , tip.count != 0{
            let tiprate = (String(tip[0].rate) + "%")
            let tipAmount = cleanDollars(String(tip[0].amount))
            return (tiprate,tipAmount)
            
        }
        return ("_","_")
    }
    func setStripePublishKey(){
        if  DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0 {}else {return }
        let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
        let stripePublish_key = MD.object?.STRIPE_PUBLISHABLE_KEY
        print("Stripe_P_KEY",stripePublish_key as Any)
        STPPaymentConfiguration.shared().publishableKey = stripePublish_key ?? ""
        
    }
    func setTipDropDown(btn : UIButton, label : UILabel)->DropDown{
        let feeDropDwn = DropDown()
        if  DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0 {}else {return feeDropDwn}
        let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
        let fees = MD.object?.FEES
        
        guard let fee = fees else {
            return feeDropDwn
        }
        
        var dropdowndatasource = ["0%"]
        
        let f = fee.split(separator: "|").map { (sub) in
            return String(sub)+"%"
        }
        dropdowndatasource += f
        feeDropDwn.anchorView = btn
        feeDropDwn.dataSource = dropdowndatasource
        
        feeDropDwn.selectionAction = { [unowned self] (index: Int, item: String) in
            var rate = item
            rate.removeLast()
            self.update_fee_tip(taxRate: rate, completion: {(succ) in
                if succ{
                    btn.setTitle("\(item)", for: .normal)
                    var amount = self.cartData.object?.sub_total ?? 0.0
                    amount = (amount * (Double(item) ?? 0.0))/100
                    label.text  = cleanDollars("\(amount)")
                }
            })
            
        }
        
        feeDropDwn.direction = .any
        return feeDropDwn
    }
    
    
}



extension CheckOutViewModel {
    private func update_fee_tip(taxRate: String, completion : ((Bool)->())?){
        
        
        var taxID = ""
        if DBManager.sharedInstance.get_CartData_DataFromDB().count != 0 {
            let cartitems = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
            if cartitems.object?.fees.count != 0 {
                taxID = (cartitems.object?.fees[0].fee_id)!
            }
        }
        
        
        
        ProductsApi.update_fee_tip(taxId: taxID, taxRate: taxRate) { (success, result) in
            if !success{
                SCLAlertView().showError("some error occured")
                completion?(false)
            }else{
                completion?(true)
            }
        }
    }
    
}
