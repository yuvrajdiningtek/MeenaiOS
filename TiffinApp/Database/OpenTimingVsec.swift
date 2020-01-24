

import Foundation
import RealmSwift



class OpenTimingVsec : Object{
    
     var data  = List<OpenTimingVsecData>()
    @objc dynamic var request_status = 0
    @objc dynamic var requestId : String!
    @objc dynamic var total = 0
    
    
}



class OpenTimingVsecData : Object{
    
    @objc dynamic var closingDay : String!
    @objc dynamic var closingTime : String!
    @objc dynamic var name : String!
    @objc dynamic var openingDay : String!
    @objc dynamic var openingTime : String!
    @objc dynamic var timingType : String!
    
    
    
}
