
import Foundation

class PlaceOrderCredentials {
    static let shared = PlaceOrderCredentials()
    
    var address_id = ""
    var firstName = ""
    var middleName = ""
    var lastName = ""
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = 0
    var country = 0
    var postalCode = ""
    var mobileNumber = ""
    var email = ""
    
    func mapdata(add : DataAdressModel){
        address_id = add.address_id
        firstName = add.firstName
        middleName = add.middleName
        lastName = add.lastName
        address1 = add.address1
        address2 = add.address2
        city = add.city
        state = add.state
        country = add.country
        postalCode = add.postalCode
        mobileNumber = add.mobileNumber
        email = add.email
    }
}


class PlaceOrder {
    
    
    var ds = PlaceOrderCredentials()
    
    
    
    
}
struct PlaceOrderModel{
    
    var addressId : String?
    var notes : String?
    var orderDate : String?
    var orderTime : String?
    var paymentType : String?
    var gatewayId : String?
    var cardToken : String?
    
    init() {
        
    }
    
}
struct GuestPlaceOrderModel{
    
    var firstName : String?
    var lastName : String?
    var mobileNumber : String?
    var email : String?
    var address1 : String?
    var city : String?
    var state : Int?
    var postalCode : String?
    var country : Int?
    var notes : String?
    init() {
        
    }
    
}










