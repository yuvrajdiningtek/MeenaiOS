//

import Foundation
import RealmSwift
import Realm
class CartData: Object {
    @objc dynamic var object : ObjectCartData?
    @objc dynamic var request_status = 0
    @objc dynamic var requestId = ""
}

class ObjectCartData:Object{
    var items = List<ItemsObjectOrdersData>()
    var fees = List<FeesObjectOrdersData>()
    var taxes = List<TaxesObjectOrdersData>()
    @objc dynamic var shippment_price = 0.0
    @objc dynamic var shippment_tax = 0.0
    @objc dynamic var shippment_method = ""
    @objc dynamic var sub_total = 0.0
    @objc dynamic var applied_coupons : Applied_couponsObjectOrdersData?
    @objc dynamic var total_amount = 0.0
    @objc dynamic var curreny = ""
    @objc dynamic var is_delivery_required = 0
    @objc dynamic var is_delivery = 0
    @objc dynamic var is_pickup = 0
    @objc dynamic var is_shop_open = 0
    var available_delivery_methods = List<Available_delivery_methods>()
    @objc dynamic var available_pickup_methods = ""
    var available_checkout_methods = List<Available_checkout_methods>()
}

class ItemsObjectOrdersData:Object{
    @objc dynamic var product_id = ""
    @objc dynamic var itemName = ""
    @objc dynamic var item_id = ""
    @objc dynamic var qty = 0.0
    @objc dynamic var unit_price = 0.0
    @objc dynamic var shipment_price = 0.0
    var taxes = List<TaxesObjectOrdersData>()
    var addons = List<AdOnObjectModel>()
    var variations_attrubutes = List<CategoryVarianceAttribute>()
    override init(value: Any) {
        super.init(value: value)
        self.mapItems(value: value as! NSDictionary)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
        self.mapItems(value: value as! NSDictionary)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    func mapItems(value : NSDictionary){
        
        if let variations_attrubutes = value.value(forKey: "variations_attributes") as? NSDictionary {
            let items = MapOrderData().mapVariationAttribute(cat: variations_attrubutes)
            for i in items{
                self.variations_attrubutes.append(i)
            }
        }
    }
}

class FeesObjectOrdersData:Object{
    @objc dynamic var fee_id = ""
    @objc dynamic var name = ""
    @objc dynamic var amount = 0.0
    @objc dynamic var rate = 0.0
}
class TaxesObjectOrdersData:Object{
    @objc dynamic var tax_id = ""
    @objc dynamic var name = ""
    @objc dynamic var amount = 0.0
    @objc dynamic var rate = 0.0
    
}
class Applied_couponsObjectOrdersData:Object{
    @objc dynamic var SUPPER10 = ""
}
class Available_delivery_methods:Object{
    @objc dynamic var cost = 0.0
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    @objc dynamic var key = ""
}
class Available_checkout_methods:Object{
    @objc dynamic var name = ""
    @objc dynamic var id = ""
    @objc dynamic var nameKey = ""
}

class AdOnObjectModel : Object{
    @objc dynamic var addon_full_name = ""
    @objc dynamic var total_price = 0.0
    @objc dynamic var unit_price = 0.0
    @objc dynamic var qty = 0.0
    
}
