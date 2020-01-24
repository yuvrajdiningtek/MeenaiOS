// in distribution    http://rules.restaurantbite.com/
// in dev  & adhoc      http://rules.restaurantbite.com/

import Foundation
class ApiKeys {
    
//  New Order History Url https://rules.diningtek.com/api/v1/users/business/order/history/merchandise

    
    static var domain = "https://rules.diningtek.com/"
     var domain = "https://prod.diningtek.com/"
    static let merchantapibaseevents = domain + "api/v1/merchants/events"
    static let merchantapibaseEventDelete = domain + "api/v1/merchants/event"
    static let apibase = domain + "api/v1/users/"
    static let merchantApiBaase = domain + "security/session/"
    static let registerDeviceUser = ApiKeys.apibase + "register_device"
    static let getAddresses = "addresses"
    static let pastOrders = "business/order/history/merchandise"
    static let getDCI = "business/bucket/dci"
    static let addToCart = "business/bucket/item"
    static let deleteCart = ApiKeys.apibase + "business/bucket"
    static let updateFeeTip = ApiKeys.apibase + "business/bucket/custom_taxrate"
    static let addcoupon = ApiKeys.apibase + "business/bucket/apply_coupon"
    static let removeCoupon = ApiKeys.apibase + "business/bucket/remove_coupon"

    // register api
    static let registerUser = ApiKeys.apibase + "register"
    
    static let merchantToken = ApiKeys.merchantApiBaase + "merchants"
    static let verifyOtp = ApiKeys.merchantApiBaase + "users/verify/otp"
    static let loginUser = ApiKeys.merchantApiBaase + "users/login"
    static let updateUserProfile = ApiKeys.apibase + "profile"
     static let forgotPassword = ApiKeys.merchantApiBaase + "users/password/rescue_app"
     static let resetPassword = ApiKeys.merchantApiBaase + "users/password/rescue/verify_app"
    static let merchantID = ApiKeys.base + "merchants/config"
    static let updateAddress = ApiKeys.apibase + "address"
    static let updateShippingMethod = ApiKeys.apibase + "business/bucket/update_shipping_method"

    // some info api
    static let base = domain + "api/v1/"
    static let getCurrency = ApiKeys.base + "enterprised/currencies"
    static let getCountries = ApiKeys.base + "enterprised/countries"
    static let getState = ApiKeys.base + "enterprised/countries/states"
    static let getBucketID = ApiKeys.apibase + "business/bucket"
    static let getuserInfo = ApiKeys.apibase + "profile"
    static let checkPaymentStatus = ApiKeys.apibase + "business/order/payment/status"
    static let getCoupons = ApiKeys.base + "merchants/coupon/describe/public"
    
    
    // submission api
    static let checkout = ApiKeys.apibase + "business/order/payment/checkout"
    static let updateQTYofProduct = ApiKeys.apibase + "business/bucket/update/item/qty"
   
    // CARDS
    static let addcard = ApiKeys.apibase + "BankCard"
    static let getAllcard = ApiKeys.apibase + "BankCards"
    static let deletecard = ApiKeys.apibase + "BankCard"
    
    
    static let galleryImages = base + "merchants/" + "galleries"
    static let restaurantTiming = base + "merchants/" + "timing"
    static let restaurantTiming_v2 = base + "merchants/" + "timing_v2"
    static let restaurantOpenOrClose = base + "merchants/" + "running_state"
    
    // nearby restaurants
    static let nearbyRestaurants = base + "merchants/" + "shop/search"

}

