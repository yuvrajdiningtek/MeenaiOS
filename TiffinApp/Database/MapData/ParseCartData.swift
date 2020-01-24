


import Foundation
import RealmSwift


struct ParseCartData{
    func map_CartData( data: NSDictionary)-> CartData{
        let cartData = CartData()
        guard let object = data.value(forKey: "object") as? NSDictionary else {return cartData}
        let allcat = map_object(data: object)
        guard let request_status = data.value(forKey: "request_status") as?  Int else {return cartData}
        guard let requestId = data.value(forKey: "requestId") as?  String else {return cartData}
        
        cartData.object = allcat
        cartData.request_status = request_status
        cartData.requestId = requestId
        return cartData
    }
    private func map_object(data : NSDictionary)->ObjectCartData{
        let OCD = ObjectCartData(value: data)
        
        
        return OCD
    }
    
    private func map_items(data : NSDictionary)->ItemsObjectOrdersData{
        
        let item : ItemsObjectOrdersData = ItemsObjectOrdersData(value: data)
        
        
        if let variations_attrubutes = data.value(forKey: "variations_attributes") as? NSDictionary {
            let items = MapOrderData().mapVariationAttribute(cat: variations_attrubutes)
            
            
            for i in items{
                item.variations_attrubutes.append(i)
            }
            
        }
        
        return item
    }
    private func map_fees(data : NSDictionary)->FeesObjectOrdersData{
        var r : FeesObjectOrdersData = FeesObjectOrdersData()
        try! DBManager.sharedInstance.database.write {
            r = DBManager.sharedInstance.database.create(FeesObjectOrdersData.self, value: data, update: false)
            
        }
        return r
    }
    private func map_taxes(data : NSDictionary)->TaxesObjectOrdersData{
        var r : TaxesObjectOrdersData = TaxesObjectOrdersData()
        try! DBManager.sharedInstance.database.write {
            r = DBManager.sharedInstance.database.create(TaxesObjectOrdersData.self, value: data, update: false)
            
        }
        return r
    }
    private func map_applied_coupons(data : NSDictionary)->Applied_couponsObjectOrdersData{
        var r : Applied_couponsObjectOrdersData = Applied_couponsObjectOrdersData()
        try! DBManager.sharedInstance.database.write {
            r = DBManager.sharedInstance.database.create(Applied_couponsObjectOrdersData.self, value: data, update: false)
            
        }
        return r
    }
    private func map_available_delivery_methods(data : NSDictionary)->Available_delivery_methods{
        var r : Available_delivery_methods = Available_delivery_methods()
        try! DBManager.sharedInstance.database.write {
            r = DBManager.sharedInstance.database.create(Available_delivery_methods.self, value: data, update: false)
            
        }
        return r
    }
    private func map_available_checkout_methods(data : NSDictionary)->Available_checkout_methods{
        var r : Available_checkout_methods = Available_checkout_methods()
        try! DBManager.sharedInstance.database.write {
            r = DBManager.sharedInstance.database.create(Available_checkout_methods.self, value: data, update: false)
            
        }
        return r
    }
    
    
}


