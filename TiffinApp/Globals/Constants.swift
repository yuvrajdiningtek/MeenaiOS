
import Foundation
import UIKit

//var userEmail = ""
//var userpassword = ""
// static let publishableKey = "pk_test_IkvHgAPOhO9A64esd1VtBukj"

struct usercredential {
    var email = "email"
    var password = "password"
}
struct userdefaultKeys{
    let number_of_items_in_Cart = "numberofitemsinCart"
    let merchant_access_token = "merchant_access_token"
    let selected_delivery_method_ID = "selected_delivery_method_ID"
    let selected_delivery_method_cost = "selected_delivery_method_cost"
    let placeOrder = "placeOrder"
    let isuserLogin = "isuserLogin"
}


var cartbadgevalue = UserDefaults.standard.value(forKey: userdefaultKeys().number_of_items_in_Cart) as? String ?? ""{
    didSet{
        UserDefaults.standard.set(cartbadgevalue, forKey: userdefaultKeys().number_of_items_in_Cart)
    }
}

var isUserLoggedIn : Bool = UserDefaults.standard.value(forKey: userdefaultKeys().isuserLogin) as? Bool ?? false {
    didSet{
        UserDefaults.standard.set(isUserLoggedIn, forKey: userdefaultKeys().isuserLogin)
        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationName.userLoginStatus), object: nil)
    }
}
struct NotificationName{
    static let userLoginStatus = "userLoginStatus"
    static let userInfoUpdate = "userInfoUpdate"
}
enum StripConstants {
    static let publishableKey = "pk_test_sn4v71GtpdSuGyF3oVJLSj7I"
    static let baseURLString = "http://work.restaurantbite.com"
    static let defaultCurrency = "usd"
    static let defaultDescription = "ordered food from tiffin iOS"
}

enum GuestUserCredential{
    static var access_token : String {
        return (UserDefaults.standard.value(forKey: userdefaultKeys().merchant_access_token) as? String) ?? ""
    }
    
    static let user_id = "guest@onlinebites.com"
    
    func accessToken (){
//        UserDefaults.standard.set(access_token, forKey: userdefaultKeys().merchant_access_token)
        
    }
}


