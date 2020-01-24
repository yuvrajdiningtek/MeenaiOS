

import Foundation
import RealmSwift
import Realm

class AppliedCoupon : Object{
    
    
    var data  = List<AppliedCouponData>()

    
}

class AppliedCouponData : Object{
    
    @objc dynamic var key = ""
    @objc dynamic var value = ""
    
    init(key : String , value : String){
        self.key = key
        self.value = value
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}
