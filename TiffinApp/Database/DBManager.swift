
import Foundation
import RealmSwift

class DBManager{
    
    //
    static let   sharedInstance = DBManager()
    public var   database:Realm
    
    
    
    let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 1,
        migrationBlock: { migration, oldSchemaVersion in
            
            
    },deleteRealmIfMigrationNeeded : true)
    
    
    func getallObjectsOfRealm()->[Object.Type]{
        
        return [LoginUserDAta.self,LoginObject.self,MerchantID.self,MerchantObject.self,ProductCatData.self,AllCategory.self,ProdCategory.self,Products.self,Attributes.self,VarianceAttribute.self,RawValue.self,MerchantDetail.self,MerchantDetailObject.self,GroupVarianceAttribute.self,CategoryVarianceAttribute.self,Variations.self,CartData.self,ObjectCartData.self,ItemsObjectOrdersData.self,FeesObjectOrdersData.self,TaxesObjectOrdersData.self,Available_delivery_methods.self,Available_checkout_methods.self, CurrencyModel.self , DataCurrencyModel.self, AdressModel.self , DataAdressModel.self,OrdersData.self, DatainOrdersData.self, ItemsOrdersData.self, ItemsFeesOrdersData.self ,AdditionalFeesOrdersData.self, OrderStatusOrdersData.self , MetaInfoObjectData.self, OrderRefunedsObjectData.self , TaxesOrdersData.self , CheckoutMethod.self,UserInfo.self, UserInfoObject.self, /*GroupVarianceAttributeOrders.self, CategoryVarianceAttributeOrders.self,*/CountryModel.self, DatainCountryModel.self,ObjectBankCardModel.self,BankCards.self,GalleryImages.self,OpenTimingVsec.self,OpenTimingVsecData.self,RestrauntTiming.self,RestrauntTimingData.self,UserDataLocal.self//,ShopTimimgObject.self//Applied_couponsObjectOrdersData.self,
        ]
    }
    
    
    
    
    
    let merchantIdRealmConf = Realm.Configuration( schemaVersion: 1, migrationBlock: { (migration, oldSchemaVersion) in
        
        if oldSchemaVersion < 1{
            
        }
    }, deleteRealmIfMigrationNeeded: true, objectTypes: [MerchantID.self,MerchantObject.self])
    
    
    
    private init() {
        
        //        let loginUserRealmConf = Realm.Configuration( schemaVersion: 1, migrationBlock: { (migration, oldSchemaVersion) in
        //
        //            if oldSchemaVersion < 1{
        //
        //            }
        //        }, deleteRealmIfMigrationNeeded: true, objectTypes: self.getallObjectsOfRealm())
        
        database =  try! Realm(configuration: config)
        
        Realm.Configuration.defaultConfiguration = config
    }
    
    // MARK: - FOR LOG IN USER DATA ITEM
    
    func get_loginUser_DataFromDB() ->   Results<LoginUserDAta> {
        
        let results =   database.objects(LoginUserDAta.self)
        return results
        
    }
    
    func get_merchntId_DataFromDB() ->   Results<MerchantID> {
        
        let results =   database.objects(MerchantID.self)
        
        return results
        
    }
    
    func get_merchntdetail_DataFromDB() ->   Results<MerchantDetail> {
        
        let results =   database.objects(MerchantDetail.self)
        
        return results
        
    }
    func get_productCat_DataFromDB() ->   Results<ProductCatData> {
        
        let results =   database.objects(ProductCatData.self)
        
        return results
        
    }
    func get_CartData_DataFromDB() ->   Results<CartData> {
        
        let results =   database.objects(CartData.self)
        
        return results
        
    }
    func get_currency_DataFromDB() ->   Results<CurrencyModel> {
        
        let results =   database.objects(CurrencyModel.self)
        
        return results
        
    }
    func get_Addresses_DataFromDB() ->   Results<AdressModel> {
        
        let results =   database.objects(AdressModel.self)
        
        return results
        
    }
    func get_Orders_DataFromDB() ->   Results<OrdersData> {
        
        let results =   database.objects(OrdersData.self)
        
        return results
        
    }
    func get_userInfo_DataFromDB() ->   Results<UserInfo> {
        
        let results =   database.objects(UserInfo.self)
        
        return results
        
    }
    func get_countries_DataFromDB() ->   Results<CountryModel> {
        
        let results =   database.objects(CountryModel.self)
        
        return results
        
    }
    
    
    func addData(object: Object)   {
        
        try! database.write {
            
//            database.add(object, update: false)
            database.create(Object.self, value: object)

            
            
        }
        
    }
    
    func deleteAllFromDatabase()  {
        
        let id = self.getBucketId()
        
        try!   database.write {
            
            database.deleteAll()
            
            let rst = database.objects(UserDataLocal.self)
            if let obj = rst.first {
                obj.bucketId = id
            }
            else{
                let obj = UserDataLocal()
                obj.bucketId = id
//                database.add(obj)
                database.create(UserDataLocal.self,value: obj)
                
            }
        }
        
    }
    
    func deleteFromDb(object: Object)   {
        
        try!   database.write {
            
            database.delete(object)
            
        }
        
    }
    
    
    
    func create_logindata_DB(value: NSDictionary){
        
        try! database.write {
            database.create(LoginUserDAta.self, value: value)
        }
    }
    func create_userInfo_DB(value: NSDictionary){
        
        try! database.write {
            database.create(UserInfo.self, value: value)
        }
    }
    
    func create_merchantIDData_DB(value: NSDictionary){
        
        try! database.write {
            database.create(MerchantID.self, value: value)
        }
    }
    func create_prodCatData_DB(value: NSDictionary){
        
        try! database.write {
            database.create(ProductCatData.self, value: value)
        }
    }
    func create_merchantDetail_DB(value: NSDictionary){
        
        try! database.write {
            database.create(MerchantDetail.self, value: value)
        }
    }
    func create_currency_DB(value: NSDictionary){
        
        try! database.write {
            database.create(CurrencyModel.self, value: value)
        }
    }
    func create_Adress_DB(value: NSDictionary){
        
        try! database.write {
            database.create(AdressModel.self, value: value)
        }
    }
    func create_Country_DB(value: NSDictionary){
        
        try! database.write {
            database.create(CountryModel.self, value: value)
        }
    }
    func create_timingV2_DB(value: NSDictionary)->OpenTimingVsec?{
        
        var db : OpenTimingVsec?
        try! database.write {
            db = database.create(OpenTimingVsec.self, value: value)
        }
        return db
    }
    func create_timing_DB(value: NSDictionary)->RestrauntTiming?{
        
        var db : RestrauntTiming?
        try! database.write {
            db = database.create(RestrauntTiming.self, value: value)
        }
        return db
    }
    func create_Gallery_DB(value: [String]){
        
        try! database.write {
            let g = GalleryImages()
            for i in value{
                g.image.append(i)
            }
            
//            database.add(g)
            database.create(GalleryImages.self,value: g)

        }
    }
    func saveBuketId(bucket id : String){
        
        let rst = database.objects(UserDataLocal.self)
        if let obj = rst.first {
            try? database.write {
                obj.bucketId = id
            }
        }
        else{
            try? database.write {
                let obj = UserDataLocal()
                obj.bucketId = id
//                database.add(obj)
                database.create(UserDataLocal.self,value: obj)

            }
        }
    }
    func getBucketId()->String?{
        let rst = database.objects(UserDataLocal.self)
        return rst.first?.bucketId
    }
    
    func deleteBucketId(){
        let rst = database.objects(UserDataLocal.self)
        try? database.write {
            database.delete(rst)
        }
    }
    
    func deleteApplyCoupon(){
        let rst = database.objects(AppliedCoupon.self)
        try? database.write {
          //  database.delete(rst)
        }
    }
    
    
    // editing the object
    func editObjects(objs: LoginUserDAta) {
        
        try? database.write ({
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
//            database.add(objs, update: true)
            database.create(LoginUserDAta.self,value: objs)

        })
    }
    
    
}
