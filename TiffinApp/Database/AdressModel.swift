
import Foundation
import RealmSwift

class AdressModel: Object {
    @objc dynamic  var total = 0
    var data = List<DataAdressModel>()
    @objc dynamic var request_status = 0
    @objc dynamic var requestId = ""
}

class DataAdressModel:Object{
    @objc dynamic var address_id = ""
    @objc dynamic var firstName = ""
    @objc dynamic var middleName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var address1 = ""
    @objc dynamic var address2 = ""
    @objc dynamic var city = ""
    @objc dynamic var state = 0
    @objc dynamic var country = 0
    @objc dynamic var postalCode = ""
    @objc dynamic var mobileNumber = ""
    @objc dynamic var email = ""
    @objc dynamic var stateName = ""
   
}


