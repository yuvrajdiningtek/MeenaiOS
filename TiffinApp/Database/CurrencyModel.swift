

import Foundation
import RealmSwift

class CurrencyModel:Object{
    var data  = List<DataCurrencyModel>()
    @objc dynamic var requestId = ""
    @objc dynamic var request_status = 0
    @objc dynamic var total = 0
}
class DataCurrencyModel:Object{
    @objc dynamic var fxRateAfterDecimalDigit = 0
    @objc dynamic var moneyFormat = ""
    @objc dynamic var name = ""
    @objc dynamic var symbol = ""
}

