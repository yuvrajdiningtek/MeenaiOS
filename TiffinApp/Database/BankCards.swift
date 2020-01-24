

import Foundation
import RealmSwift

class BankCards : Object{
    
    
    var object = List<ObjectBankCardModel>()
    @objc dynamic var total = 0
    @objc dynamic var request_status = 0
    @objc dynamic var requestId = ""
}
class ObjectBankCardModel : Object{
    @objc dynamic var cardId = ""
    @objc dynamic var creditCardName = ""
    @objc dynamic var creditCardNumber = ""
    @objc dynamic var cardType = ""
}

