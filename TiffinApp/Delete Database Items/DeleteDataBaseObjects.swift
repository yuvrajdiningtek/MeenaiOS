

import Foundation

struct DeleteDataBaseObjects {
    
    static func deleteOrderData(){
        let od = DBManager.sharedInstance.get_Orders_DataFromDB()
        
        for i in od {
            DBManager.sharedInstance.deleteFromDb(object: i as OrdersData)
        }
        
        
        let obj1 = DBManager.sharedInstance.database.objects(DatainOrdersData.self)
        let obj2 = DBManager.sharedInstance.database.objects(ItemsOrdersData.self)
        let obj3 = DBManager.sharedInstance.database.objects(ItemsFeesOrdersData.self)
        let obj4 = DBManager.sharedInstance.database.objects(OrderStatusOrdersData.self)
        let obj5 = DBManager.sharedInstance.database.objects(MetaInfoObjectData.self)
        let obj6 = DBManager.sharedInstance.database.objects(OrderRefunedsObjectData.self)
        let obj7 = DBManager.sharedInstance.database.objects(TaxesOrdersData.self)
        let obj8 = DBManager.sharedInstance.database.objects(CheckoutMethod.self)
        //                let obj9 = DBManager.sharedInstance.database.objects(GroupVarianceAttributeOrders.self)
        //                let obj10 = DBManager.sharedInstance.database.objects(CategoryVarianceAttributeOrders.self)
        
        try? DBManager.sharedInstance.database.write {
            DBManager.sharedInstance.database.delete(obj1)
            DBManager.sharedInstance.database.delete(obj2)
            DBManager.sharedInstance.database.delete(obj3)
            DBManager.sharedInstance.database.delete(obj4)
            DBManager.sharedInstance.database.delete(obj5)
            DBManager.sharedInstance.database.delete(obj6)
            DBManager.sharedInstance.database.delete(obj7)
            DBManager.sharedInstance.database.delete(obj8)
//                    DBManager.sharedInstance.database.delete(obj9)
//                    DBManager.sharedInstance.database.delete(obj10)
            
        }
        
    }
    
    
    static func deleteAddress(){
        
        let data = DBManager.sharedInstance.get_Addresses_DataFromDB()
        for i in data{
            DBManager.sharedInstance.deleteFromDb(object: i)
        }
        
        let obj = DBManager.sharedInstance.database.objects(DataAdressModel.self)
        for i in obj {
            DBManager.sharedInstance.deleteFromDb(object: i)
        }
        
    }
    
    static func delete_cartData(){
        if DBManager.sharedInstance.get_CartData_DataFromDB().count != 0{
            let data = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
            DBManager.sharedInstance.deleteFromDb(object: data)
            
            let obj1 = DBManager.sharedInstance.database.objects(ObjectCartData.self)
            let obj2 = DBManager.sharedInstance.database.objects(ItemsObjectOrdersData.self)
            let obj3 = DBManager.sharedInstance.database.objects(FeesObjectOrdersData.self)
            let obj4 = DBManager.sharedInstance.database.objects(TaxesObjectOrdersData.self)
//            let obj5 = DBManager.sharedInstance.database.objects(Applied_couponsObjectOrdersData.self)
            let obj6 = DBManager.sharedInstance.database.objects(Available_delivery_methods.self)
            let obj7 = DBManager.sharedInstance.database.objects(Available_checkout_methods.self)
            
            try? DBManager.sharedInstance.database.write {
                DBManager.sharedInstance.database.delete(obj1)
                DBManager.sharedInstance.database.delete(obj2)
                DBManager.sharedInstance.database.delete(obj3)
                DBManager.sharedInstance.database.delete(obj4)
//                DBManager.sharedInstance.database.delete(obj5)
                DBManager.sharedInstance.database.delete(obj6)
                DBManager.sharedInstance.database.delete(obj7)
            }
        }
    }
    
    static func deleteGalleryImages(){
        let obj = DBManager.sharedInstance.database.objects(GalleryImages.self)
        try? DBManager.sharedInstance.database.write {
            DBManager.sharedInstance.database.delete(obj)
        }
        
    }

    
    static func deleteAppliedCouponsData(){
        
        let dbm = DBManager.sharedInstance
        let db = dbm.database
        let appliedc = db.objects(AppliedCoupon.self)
        for i in appliedc{
           let dataappliedc = i.data
            try! db.write{
                db.delete(dataappliedc)
                db.delete(i)
            }
        }
        
        
    }
    
}
