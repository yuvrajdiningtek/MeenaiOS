
import Foundation
import RealmSwift

class OrdersData: Object {
    var data = List<DatainOrdersData>()
    @objc dynamic var total = 0
    @objc dynamic var request_status = 0
    @objc dynamic var requestId = ""
}
class DatainOrdersData:Object{
    @objc dynamic var orderId = "0"
    var items = List<ItemsOrdersData>()
    var itemsFees = List<ItemsFeesOrdersData>()
    var orderStatus =  List<OrderStatusOrdersData>()
    @objc dynamic var orderTotal = 0.0
    @objc dynamic var note = ""
    @objc dynamic var metaInfo : MetaInfoObjectData?
    var orderRefuneds = List<OrderRefunedsObjectData>()
    var taxes = List<TaxesOrdersData>()
    @objc dynamic var checkoutMethod : CheckoutMethod?
    @objc dynamic var orderedDate = ""
    @objc dynamic var billingAddress : DataAdressModel?
    @objc dynamic var shippingAddress : DataAdressModel?
    @objc dynamic var pickupAddress : DataAdressModel?

}

class ItemsOrdersData:Object{
    @objc dynamic var itemName = ""
    @objc dynamic var qty = 0.0
    @objc dynamic var unit_price = 0.0
//    @objc dynamic var variations_attrubutes  : CategoryVarianceAttribute?
    var variations_attributes  = List<CategoryVarianceAttribute>()
    var addons = List<AdOnObjectModel>()
}

class ItemsFeesOrdersData : Object{
    @objc dynamic var name = ""
    @objc dynamic var amount = 0.0
}

class OrderStatusOrdersData:Object{
    @objc dynamic var status = ""
}
class MetaInfoObjectData:Object{
    @objc dynamic var SHIPPING_METHOD = ""
    @objc dynamic var BUCKET = ""
    @objc dynamic var COUPON = ""
    @objc dynamic var COUPON_TIFFIN10_AMOUNT = ""
}
class OrderRefunedsObjectData:Object{
    
}

class  TaxesOrdersData: Object{
    @objc dynamic var name = ""
    @objc dynamic var amount = 0.0
}
class CheckoutMethod:Object{
    @objc dynamic var name = ""
}




// delete it also remove from databse array
//class GroupVarianceAttributeOrders:Object{
//    @objc dynamic var Category : CategoryVarianceAttributeOrders?
//}
//class CategoryVarianceAttributeOrders:Object{
//    var Spicy = List<String>()
//}
