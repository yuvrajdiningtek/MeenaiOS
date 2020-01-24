

import Foundation
import RealmSwift

class RestrauntTiming : Object{
    
    var data  = List<RestrauntTimingData>()
    @objc dynamic var request_status = 0
    @objc dynamic var requestId : String!
    @objc dynamic var total = 0
    
    
}

class RestrauntTimingData : Object{
    
    @objc dynamic var name : String!
    @objc dynamic var time : String!
    
   
}

