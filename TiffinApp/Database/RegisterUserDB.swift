

import Foundation
import RealmSwift



class LoginUserDAta: Object {
    @objc dynamic var requestId = ""
    @objc dynamic var request_status = 0
    @objc dynamic var object : LoginObject?
    
}
class LoginObject:Object{
    @objc dynamic var access_token = ""
    @objc dynamic var expires_in = 0
    @objc dynamic var status = ""
//    override static func primaryKey() -> String? {
//
//
//        return "access_token"
//
//    }
}




class UserInfo:Object{
    @objc dynamic var requestId = ""
    @objc dynamic var request_status = 0
    @objc dynamic var object : UserInfoObject?
}
class UserInfoObject:Object{
    @objc dynamic var user_id = ""
    @objc dynamic var userName = ""
    @objc dynamic var email = ""
    @objc dynamic var primaryPhone = ""
    @objc dynamic var firstName = ""
    @objc dynamic var middleName = ""
    @objc dynamic var lastName = ""
    
}

class MerchantID:Object{
    @objc dynamic var requestId = ""
    @objc dynamic var request_status = 0
    @objc dynamic var object : MerchantObject?
}
class MerchantObject:Object{
    @objc dynamic var FEES = ""
    @objc dynamic var MERCHANT_ID = ""
    @objc dynamic var STATIC_RESOURCE_CATEGORIES_PREFIX = ""
    @objc dynamic var STATIC_RESOURCE_ENDPOINT = ""
    @objc dynamic var STATIC_RESOURCE_SUFFIX = ""
    @objc dynamic var STRIPE_SECRET_KEY = ""
    @objc dynamic var STRIPE_PUBLISHABLE_KEY = ""
    @objc dynamic var IS_SHOP_OPEN = ""
    @objc dynamic var CUSTOM_TIP =  ""
    @objc dynamic var DINING_RESERVED_TABLES =  ""
    @objc dynamic var PRODUCT_IMAGE_PREVIEW = ""


//    override static func primaryKey() -> String? {
//
//        return "MERCHANT_ID"
//
//    }
    
}



class MerchantDetail:Object{
    @objc dynamic var object : MerchantDetailObject?
    @objc dynamic var request_status = 0
    
}
class MerchantDetailObject:Object{
    @objc dynamic var MERCHANT_EMAIL = ""
      @objc dynamic var rating = 0.0
      @objc dynamic var MERCHANT_ADD_FEAT_COCKTAILS = ""
      @objc dynamic var MERCHANT_ADD_FEAT_DELIVERY_RADIUS_MAX = ""
      @objc dynamic var LOGO = ""
      @objc dynamic var MERCHANT_ADD_FEAT_MINIMUM_ORDER = ""
      @objc dynamic var MERCHANT_ADD_FEAT_DINNER = ""
      @objc dynamic var MERCHANT_ADD_FEAT_VEG = ""
      @objc dynamic var is_pickup = 0
      @objc dynamic var MERCHANT_ADD_FEAT_DELIVERY = ""
      @objc dynamic var MERCHANT_CONTACT = ""
      @objc dynamic var MERCHANT_MANAGER_NAME = ""
      @objc dynamic var MERCHANT_ADD_FEAT_WINE = ""
      @objc dynamic var business_type = ""
      @objc dynamic var location_longitude = 0.0
      @objc dynamic var MERCHANT_ADD_FEAT_FULLBAR = ""
      @objc dynamic var MERCHANT_ADD_FEAT_BREAKFAST = ""
      @objc dynamic var MERCHANT_ADD_FEAT_CAFE = ""
      @objc dynamic var cart_max_item_qty = 0.0
      @objc dynamic var CURRENCY = ""
      @objc dynamic var MERCHANT_ADD_FEAT_PICKUP = ""
      @objc dynamic var MERCHANT_ADD_FEAT_INDOOR = ""
      @objc dynamic var MERCHANT_ADD_FEAT_BEER = ""
      @objc dynamic var location_latitude = 0.0
      @objc dynamic var opening_time = ""
      @objc dynamic var url_point = ""
      @objc dynamic var description_point = ""
      @objc dynamic var address_state = ""
      @objc dynamic var address_postal_code = ""
      @objc dynamic var MERCHANT_ADD_FEAT_COUPONS_ACCEPT = ""
      @objc dynamic var MERCHANT_ADD_FEAT_COD = ""
      @objc dynamic var MERCHANT_OWNER_NAME = ""
      @objc dynamic var is_delivery = 0
      @objc dynamic var name_point = ""
       @objc dynamic var address_city = ""
       @objc dynamic var address_address = ""
      @objc dynamic var MERCHANT_ADD_FEAT_OUTDOOR = ""
      @objc dynamic var FAX_NUMBER = ""
      @objc dynamic var BANNER = ""
      @objc dynamic var is_popular = ""
      @objc dynamic var cart_min_item_qty = 0.0
      @objc dynamic var MERCHANT_ADD_FEAT_ONLINE_PAYMENTS = ""
      @objc dynamic var name = ""
      @objc dynamic var type_point = ""
      @objc dynamic var total_reviews = 0.0
      @objc dynamic var MERCHANT_ADD_FEAT_DELIVERY_CHARGE = ""
      @objc dynamic var MERCHANT_ADD_FEAT_LUNCH = ""
      @objc dynamic var SMS_PHONE = ""
    
}
