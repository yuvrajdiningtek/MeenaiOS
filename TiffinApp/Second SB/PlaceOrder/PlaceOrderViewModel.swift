

import Foundation
class  PlaceOrderViewModel: NSObject {
    var cartData : CartData = CartData()
    var products = [ItemsObjectOrdersData]()
    var appliedCoupons : NSDictionary?
    override init() {
        super.init()
        self.cartData = getCartDataFromDB().0
    }
    func shiPPingIdPickUp()->String?{
        
        return cartData.object?.available_pickup_methods
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
        print("orders item", cartData, products)
        
        return (cartData,products)
    }
    func getSubTotal()->String{
        let subtotal = cartData.object?.sub_total ?? 0
        return cleanDollars(String(describing: subtotal))
    }
    func getTotalPrice()->String{
        let total_amount = cartData.object?.total_amount ?? 0
        return cleanDollars(String(describing: total_amount))
    }
    func get_total_items()->String{
        var totalItems : Int = 0
        for item in products{
            let quantity = item.qty
            totalItems =  (cartData.object?.items.count)!
//            totalItems = totalItems + quantity
        }
        return String(Int(totalItems))
    }
    func getAppliedCoupon()->(String,String){
        let aps = DBManager.sharedInstance.database.objects(AppliedCoupon.self)
//        let key = aps.first?.data.first?.key ?? "Select Coupon / Apply Coupon"
        let key = "Select Coupon / Apply Coupon"
//        let value = aps.first?.data.first?.value ?? ""
        let value = ""
        return (key,cleanDollars(value))
    }
    func getTiprateAndAmount()->(String,String){
        let rate = cartData.object?.fees.first?.rate ?? 0
        let ratestr = String(rate) + "%"
        let amount = cartData.object?.fees.first?.amount ?? 0
        let amountstr =  cleanDollars(String(amount))
       
        return (ratestr,amountstr)
    }
    func getTipAmount(rate : String)->String{
        
        guard let ratedouble = Double(rate) else{return ""}
        let subtotal = cartData.object?.sub_total ?? 0
        let ss = String((subtotal * ratedouble)/100)
        let amount = cleanDollars(ss)
        return amount
    }
    
    func getgateWayId_payemntType()->(String,String){
        
        var gatewayId = ""
        
        var paymentType = ""
        
        if  DBManager.sharedInstance.get_CartData_DataFromDB().count != 0 {}else {return (gatewayId,paymentType)}
        let MD  = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
        
        if let available_checkout_methods = MD.object?.available_checkout_methods, available_checkout_methods.count != 0{
            gatewayId = available_checkout_methods[0].id
            paymentType = available_checkout_methods[0].nameKey
            
        }
        return (gatewayId,paymentType)
    }
    
}
