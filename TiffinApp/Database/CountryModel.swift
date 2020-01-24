

import Foundation
import RealmSwift

class CountryModel : Object{
    var data = List<DatainCountryModel>()
    @objc dynamic var total = 0
    @objc dynamic var request_status = 0
    @objc dynamic var requestId = ""
}

class DatainCountryModel : Object{
    @objc dynamic var name = ""
    @objc dynamic var iso = ""
    @objc dynamic var id = 0
}

