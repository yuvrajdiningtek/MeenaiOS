// https://github.com/bignerdranch/Freddy/issues/133

import Foundation
import RealmSwift
class ProductCatData:Object{
    var data : List<AllCategory> =  List<AllCategory>()
    @objc dynamic var request_status = 0
}
class AllCategory:Object{
    @objc dynamic var category : ProdCategory?
    var products = List<Products>()
}
class RawValue:Object{
    
}
class ProdCategory:Object{
    @objc dynamic var categoryId = ""
    @objc dynamic var categoryName = ""
    @objc dynamic var bundleId = ""
    @objc dynamic var slug = ""
    @objc dynamic var longDescription = ""
    
    //    override static func primaryKey() -> String? {
    //
    //        return "dataId"
    //
    //    }
}
class Products:Object{
    @objc dynamic var productId = ""
    @objc dynamic var name = ""
    @objc dynamic var slug = ""
    @objc dynamic var shortDescription = ""
    @objc dynamic var descriptions = ""
    @objc dynamic var enabledUserInstructions = true

    var image = List<String>()
    @objc dynamic var attributes : Attributes?
    @objc dynamic var varianceAttribute : VarianceAttribute?
    var variations = List<Variations>()
    @objc dynamic var price = Double()
     var addonsGroups =  List<AddOnsGroup>()
    
}
class Attributes:Object{
    
}
class VarianceAttribute:Object{
    @objc dynamic var Group : GroupVarianceAttribute?
    
}
class GroupVarianceAttribute:Object{
    var Category = List<CategoryVarianceAttribute>()
}
class CategoryVarianceAttribute:Object{
    @objc dynamic var category_key = ""
    var value = List<String>()
}

class Variations:Object{
    @objc dynamic var productVariationId = ""
    @objc dynamic var name = ""
    @objc dynamic var slug = ""
    @objc dynamic var shortDescription = ""
    @objc dynamic var descriptions = ""
    var image = List<String>()
    @objc dynamic var varianceAttribute : VarianceAttribute?
    @objc dynamic var price = Double()
}


class AddOnsGroup : Object{
    @objc dynamic var addOnGroupId : String = ""
    @objc dynamic var  name : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var nameKey: String = ""
    var addons : List<AddOns> = List<AddOns>()
    @objc dynamic var isRequired = 0
    @objc dynamic var isGlobal = 0
    @objc dynamic var isSystem = 0
}
class AddOns: Object{
    @objc dynamic var addOnId: String = ""
    @objc dynamic var unitPrice = 0.0
    @objc dynamic var name = ""
    @objc dynamic var nameKey = ""
    @objc dynamic var quantitative = 0
    @objc dynamic var taxable = 0
}
