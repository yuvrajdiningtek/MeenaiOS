

import Foundation
class CouponsModel : NSObject{
    
    var name = ""
    var descriptions = ""
    var expired = ""
    
    init(dict : NSDictionary){
        
        self.name = dict.value(forKey: "name") as? String ?? ""
        self.descriptions = dict.value(forKey: "description") as? String ?? ""
        self.expired = dict.value(forKey: "expired") as? String ?? ""
        
        super.init()
    }
    
}
