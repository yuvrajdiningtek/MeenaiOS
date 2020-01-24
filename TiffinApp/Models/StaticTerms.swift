
import Foundation

class Register_user_Data:NSObject{
    var user_id : String?
    var state : String?
    var password : String?
    
    init(userid: String, state:String, password:String) {
        self.user_id = userid
        self.state = state
        self.password = password
    }
    override init() {
        user_id = ""
        state = ""
        password = ""
    }
}


class Para_for_Update_shipping_address:NSObject{
    var bucketId : String?
    var shippingId : String?
    init(bucketId: String, shippingId:String) {
        self.bucketId = bucketId
        self.shippingId = shippingId
    }
    override init() {
        bucketId = ""
        shippingId = ""
    }
}

