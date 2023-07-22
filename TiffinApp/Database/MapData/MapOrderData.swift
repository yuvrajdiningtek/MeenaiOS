

import Foundation

struct MapOrderData {
    func mapPastOrdersData(value : NSDictionary){
        let orderData = OrdersData()
        if let total = value.value(forKey: "total") as? Int {
            orderData.total = total
        }
        if let request_status = value.value(forKey: "request_status") as? Int {
            orderData.request_status = request_status
        }
        if let requestId = value.value(forKey: "requestId") as? String {
            orderData.requestId = requestId
        }
        
        guard let data = value.value(forKey: "data") as? [NSDictionary] else{return}
        for i in mapData(value: data){
            orderData.data.append(i)
        }
        try! DBManager.sharedInstance.database.write {
//            DBManager.sharedInstance.database.add(orderData)
       DBManager.sharedInstance.database.create(OrdersData.self, value: orderData)

            
        }
    }
    
     func mapData(value : [NSDictionary]) -> [DatainOrdersData] {
        var datainOrderData  = [DatainOrdersData]()
        for item in value{
            let data_OrderData = DatainOrdersData()
            if let orderId = item.value(forKey: "orderId") as? String {
                data_OrderData.orderId = orderId
            }
           
            if let note = item.value(forKey: "note") as? String {
                data_OrderData.note = note
            }
            if let items = item.value(forKey: "items") as? [NSDictionary] {
                let items = mapItems(value: items)
                for i in items{
                    data_OrderData.items.append(i)
                }
            }
            
            if let itemsFees = item.value(forKey: "itemsFees") as? [NSDictionary] {
                var arr  = [ItemsFeesOrdersData]()
                for i in itemsFees{
                    
                    try! DBManager.sharedInstance.database.write {
                        let a = DBManager.sharedInstance.database.create(ItemsFeesOrdersData.self, value: i, update: false)
                        arr.append(a)
                    }
                    
                    
                }
                for i in arr{
                    data_OrderData.itemsFees.append(i)
                }
                
            }
            if let additional_fees = item.value(forKey: "additional_fees") as? [NSDictionary] {
                var arr  = [AdditionalFeesOrdersData]()
                for i in additional_fees{
                    
                    try! DBManager.sharedInstance.database.write {
                        let a = DBManager.sharedInstance.database.create(AdditionalFeesOrdersData.self, value: i, update: false)
                        arr.append(a)
                    }
                    
                    
                }
                for i in arr{
                    data_OrderData.additional_fees.append(i)
                }
                
            }
            if let orderStatus = item.value(forKey: "orderStatus") as? [NSDictionary] {
                var arr  = [OrderStatusOrdersData]()
                for i in orderStatus{
                    try! DBManager.sharedInstance.database.write {
                        let a = DBManager.sharedInstance.database.create(OrderStatusOrdersData.self, value: i, update: false)
                        arr.append(a)
                    }
                    
                }
                for i in arr{
                    data_OrderData.orderStatus.append(i)
                }
            }
            if let orderTotal = item.value(forKey: "orderTotal") as? Double {
                data_OrderData.orderTotal = orderTotal
            }
            if let orderCreatedDate = item.value(forKey: "orderCreatedDate") as? String {
                data_OrderData.orderCreatedDate = orderCreatedDate
            }
            
            if let orderId = item.value(forKey: "orderId") as? String {
                data_OrderData.orderId = orderId
            }
            if let metaInfo = item.value(forKey: "metaInfo") as?  NSDictionary{
                try! DBManager.sharedInstance.database.write {
                    let a = DBManager.sharedInstance.database.create(MetaInfoObjectData.self, value: metaInfo, update: false)
                    data_OrderData.metaInfo = a
                }
                
                
            }
            if let orderRefuneds = item.value(forKey: "orderRefuneds") as? [NSDictionary] {
                
                //                data_OrderData.orderRefuneds = OrderRefunedsObjectData()
            }
            if let taxes = item.value(forKey: "taxes") as? [NSDictionary] {
                
                var arr  = [TaxesOrdersData]()
                for i in taxes{
                    try! DBManager.sharedInstance.database.write {
                        let a = DBManager.sharedInstance.database.create(TaxesOrdersData.self, value: i, update: false)
                        arr.append(a)
                    }
                    
                }
                for i in arr{
                    data_OrderData.taxes.append(i)
                }
            }
            
            if let checkoutMethod = item.value(forKey: "checkoutMethod") as? NSDictionary {
                
                
                
                try! DBManager.sharedInstance.database.write {
                    let a = DBManager.sharedInstance.database.create(CheckoutMethod.self, value: checkoutMethod, update: false)
                    data_OrderData.checkoutMethod = a
                }
                
            }
            if let orderedDate = item.value(forKey: "orderedDate") as? String  {
                data_OrderData.orderedDate = orderedDate
            }
            if let billingAddress = item.value(forKey: "billingAddress") as? NSDictionary {
                
                
                
                try! DBManager.sharedInstance.database.write {
                    let a = DBManager.sharedInstance.database.create(DataAdressModel.self, value: billingAddress, update: false)
                    data_OrderData.billingAddress = a
                }
                
            }
            if let pickupAddress = item.value(forKey: "pickupAddress") as? NSDictionary {



                try! DBManager.sharedInstance.database.write {
                    let a = DBManager.sharedInstance.database.create(DataAdressModel.self, value: pickupAddress, update: false)
                    data_OrderData.pickupAddress = a
                }

            }
            if let shippingAddress = item.value(forKey: "shippingAddress") as? NSDictionary {
                
                try! DBManager.sharedInstance.database.write {
                    let a = DBManager.sharedInstance.database.create(DataAdressModel.self, value: shippingAddress, update: false)
                    data_OrderData.shippingAddress = a
                }
                
            }
            
            datainOrderData.append(data_OrderData)
            
        }
        
        return datainOrderData
    }
    
    // *********************************
    // *********************************
    
    private func mapItems(value : [NSDictionary])->[ItemsOrdersData]{
        var items : [ItemsOrdersData] = [ItemsOrdersData]()
        for i in value{
            let item = ItemsOrdersData()
            if let itemName = i.value(forKey: "itemName") as? String {
                item.itemName = itemName
            }
            let customerInstruction = i.value(forKey: "customerInstruction") as? [String] ?? [String]()
            
            for ij in customerInstruction{
                
                item.customerInstruction.append(ij)
                
            }
            if let qty = i.value(forKey: "qty") as? Double {
                item.qty = qty
            }
            if let unit_price = i.value(forKey: "unit_price") as? Double {
                item.unit_price = unit_price
            }
            if let variations_attrubutes = i.value(forKey: "variations_attributes") as? NSDictionary {
                let items = mapVariationAttribute(cat: variations_attrubutes)
                for i in items{
                    item.variations_attributes.append(i)
                }
            }
            if let addons = i.value(forKey: "addons") as? [NSDictionary] {
                
                for i in addons{
                    let item1 = AdOnObjectModel(value: i)
                    item.addons.append(item1)
                }
            }
            items.append(item)
        }
        return items
        
    }
    
    func mapVariationAttribute(cat : NSDictionary )-> [CategoryVarianceAttribute]{
        var catAtt_Arr = [CategoryVarianceAttribute]()
        for (key,value) in cat{
            let catAtt = CategoryVarianceAttribute()
            catAtt.category_key = key as? String ?? ""
            if value is [String]{
                for i in (value as! [String]){
                    catAtt.value.append(i)
                }
            }
            
            catAtt_Arr.append(catAtt)
        }
        return catAtt_Arr
    }
    
    // *********************************
    // *********************************
}

