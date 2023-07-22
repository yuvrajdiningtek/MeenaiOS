    //
//  ProductsAPi.swift
//  TiffinApp
//


import Foundation
import Alamofire
import RealmSwift


class ProductsApi:NSObject{
    
    // MARK: - GET ALL ORDERS API
    
    class public func get_Orders( id : String?,pageNumber : String ,pageSize : String = "10",callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.apibase + ApiKeys.pastOrders)
        
        let user_id : String
        let accesstoken : String
        
        print("urlAPI",apiurl)
        
        if isUserLoggedIn {
             user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            
             let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
             accesstoken = (logindata.object?.access_token)!
            
            
        }else{
            accesstoken = GuestUserCredential.access_token
            user_id = GuestUserCredential.user_id
            
            
        }
        

        
//        
        if id != nil {
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "id", value: id),
                                  URLQueryItem(name: "pageSize", value: pageSize),
                                  URLQueryItem(name: "pageNumber", value: pageNumber)
                
            ]
        }
        else{
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "pageSize", value: pageSize),
                                  URLQueryItem(name: "pageNumber", value: pageNumber)
            ]
        }
     //"https/rules.diningtek.com/api/v1/users/business/order/history"
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let result = respose.result.value as? NSDictionary
                else {return callback(false,respose)}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{return callback(false,result)}
            DeleteDataBaseObjects.deleteOrderData()
            
          
//            try! DBManager.sharedInstance.database.write {
//                DBManager.sharedInstance.database.create(OrdersData.self, value: result)
//            }
            MapOrderData().mapPastOrdersData(value: result)
            print("RESULT::::",result)
            callback(true,result)
            
        }
    }
    
    // MARK: - PRODUCT CATEGORIES
    class public func ProductCat( callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        
        var loginurl : String = ""
        
        if DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0 {
            let data = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
            let STATIC_RESOURCE_ENDPOINT = data.object?.STATIC_RESOURCE_ENDPOINT
            let STATIC_RESOURCE_CATEGORIES_PREFIX = data.object?.STATIC_RESOURCE_CATEGORIES_PREFIX
            let merchntid = data.object?.MERCHANT_ID
            let STATIC_RESOURCE_SUFFIX = data.object?.STATIC_RESOURCE_SUFFIX
            loginurl = STATIC_RESOURCE_ENDPOINT! + STATIC_RESOURCE_CATEGORIES_PREFIX! + merchntid! + STATIC_RESOURCE_SUFFIX!
        }
        print("loginnn",loginurl)
        Alamofire.request(loginurl,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            
            
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
            
            if let  request_status = result.value(forKey: "request_status") as? Int{
                if request_status == 1{
                    let prod = Parse_Produvt_CategoryData().map_prodCat(data: result)
                    
                    let resultsdb =   DBManager.sharedInstance.database.objects(ProductCatData.self)
                    
//
                    try! DBManager.sharedInstance.database.write {
                        DBManager.sharedInstance.database.delete(resultsdb)
                        let obj1 = DBManager.sharedInstance.database.objects(Products.self)
                        DBManager.sharedInstance.database.delete(obj1)
                        let obj2 = DBManager.sharedInstance.database.objects(Variations.self)
                        DBManager.sharedInstance.database.delete(obj2)
                    }
                    try! DBManager.sharedInstance.database.write {
//                        DBManager.sharedInstance.database.add(prod)
                        
                        DBManager.sharedInstance.database.create(ProductCatData.self, value: result)
                    }
                    callback(true, result)
                }
                else{
                    callback(false, result)
                }
            }
            else{
                callback(false, nil)
            }
        }
        
    }
    
    // MARK: - ADD TO CART
    
    class public func addToCart(parameters : [String:Any], callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        let apiStr = ApiKeys.apibase + ApiKeys.addToCart
        var apiurl = URLComponents(string: apiStr)
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let headers : [String:String] = ["Content-Type":"application/json",
                                         "device_id":udid]
        let bucket_id =  DBManager.sharedInstance.getBucketId()
        print(apiStr)
        
        if isUserLoggedIn {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            
            let accesstoken = (logindata.object?.access_token)!
            
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "bucket_id", value: bucket_id)
]

        }else{
            let accesstoken = GuestUserCredential.access_token
            
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
            URLQueryItem(name: "bucket_id", value: bucket_id)
            ]

        }
        
        Alamofire.request(apiurl!,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            if let result = respose.result.value  as? NSDictionary{
                
                
                
                guard let request_status = result.value(forKey: "request_status") as? Int , request_status == 1 else{
                    callback(false,result)
                    return
                }
                if let object = result.value(forKey: "object") as? NSDictionary{
                    if let bucketid = object.value(forKey: "bucket") as? String{
                        DBManager.sharedInstance.saveBuketId(bucket: bucketid)
                    }
                }
                
                callback(true,result)
            }else{
                callback(false, nil)
            }
            
        }
    }
    
    // // MARK: - DETAILED CART INFORMATION
    
    class public func detail_Cart_Info( callback:@escaping (( _ success :Bool, _ results: Any?, _ appliedCoupons : AppliedCoupon? )->())){
        func invalidresult()->NSDictionary{
            
            
            let dic : [String:Any] = ["object":["error":"Invalid Bucket Data Id"]]
            return dic as NSDictionary
        }
        func callApi(apiurl : URLComponents?){
            
            
            Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
                
                var appliedCoupons : AppliedCoupon? = nil
                guard let result = respose.result.value as? NSDictionary else {return callback(false,respose,appliedCoupons)}
                

                if let request_status = result.value(forKey: "request_status") as? Int {
                    if request_status == 1{

//                    try! DBManager.sharedInstance.database.write {
//                        DBManager.sharedInstance.database.create(CartData.self, value: result)
//                    }
                        DeleteDataBaseObjects.delete_cartData()
                        print("\n\n\\nn\\nn\\n\n\\n\n\n\n\n\n\n\(result)\n\n\\nn\n\n\\n\n\n\n\n\n\n\n\\n\n,\(appliedCoupons)\n\n\n\\n")
                        let cartData = ParseCartData().map_CartData(data: result)
                        print(cartData,"-=-=-=-=-=-=-=-=-=-=----")
                        try! DBManager.sharedInstance.database.write {
                            print(DBManager.sharedInstance.database,"----")
                            print(DBManager.sharedInstance.database,"----")

                            if DBManager.sharedInstance.database.isEmpty == true{
                                print("ooooooooooooooo")
                                return
                            }
                            print(cartData.requestId,"----ccccccc")
//                            if cartData.requestId != ""{
//                            DBManager.sharedInstance.database.add(cartData)
                            DBManager.sharedInstance.database.create(CartData.self,value: cartData)

//                            }
//                            else{
                                //print(cartData.requestId,"----noooooooooooo")

                           // }
                          //  print(cartData.requestId,"----ccccccc")

//
//                            print(DBManager.sharedInstance.database,"----",cartData)
                         

                        }
                        // ******************** cart button badge ********************
//                        if DBManager.sharedInstance.get_CartData_DataFromDB().count != 0{
//                            let cartData = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
//
//                            cartbadgevalue = String(describing: (cartData.object?.items.count)!)
//
//                            if let items = cartData.object?.items{
//                                var qty:Double = 0
//                                var q: Double = 0
//                                for itm in items{
//                                    qty = qty + itm.qty
//                                    q = Double(items.count)
//                                }
//                                cartbadgevalue = String(describing: Int(q))
//
//                            }
//                            UserDefaults.standard.set(cartbadgevalue, forKey: userdefaultKeys().number_of_items_in_Cart)
//
//                        }
                        callback(true, result,appliedCoupons)
                    }
                    else{
                        cartbadgevalue = ""
                        UserDefaults.standard.set(cartbadgevalue, forKey: userdefaultKeys().number_of_items_in_Cart)
                        
                        callback(false, result,appliedCoupons)
                    }
                }else{
                    
                    
                    
                    callback(false, nil,appliedCoupons)
                }
            }
            
        }
        
        let apiStr = ApiKeys.apibase + ApiKeys.getDCI
        var apiurl = URLComponents(string: apiStr)
        
        
        if isUserLoggedIn {
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            let bucket_id =  DBManager.sharedInstance.getBucketId()
            
            if bucket_id != nil || bucket_id != ""{
                apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                      URLQueryItem(name: "access_token", value: accesstoken),
                                      URLQueryItem(name: "bucket_id", value: bucket_id)
                ]
                callApi(apiurl: apiurl)
            }
            else{
                SomeInformationApi.get_bucketid { (succ, bucketid) in
                    apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                          URLQueryItem(name: "access_token", value: accesstoken),
                                          URLQueryItem(name: "bucket_id", value: bucketid ?? "")
                    ]
                    callApi(apiurl: apiurl)
                }
            }
           
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            let user_id = GuestUserCredential.user_id
            let bucket_id = DBManager.sharedInstance.getBucketId()
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "bucket_id", value: bucket_id ?? "")
            ]
            
            if bucket_id == nil || bucket_id == "" {
                cartbadgevalue = ""
                callback(false,invalidresult(),nil)
                return
                
            }
            callApi(apiurl: apiurl)
            
        }
        
        
        
    }
    
    class public func detail_Cart_InfoFree(callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        func invalidresult()->NSDictionary{
            
            
            let dic : [String:Any] = ["object":["error":"Invalid Bucket Data Id"]]
            return dic as NSDictionary
        }
        func callApiFree(apiurl : URLComponents?){
            
            
            Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
                
           //     var appliedCoupons : AppliedCoupon? = nil
                guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
                

                if let request_status = result.value(forKey: "request_status") as? Int {
                    if request_status == 1{

                        callback(true, result)
                    }
                    else{
                        cartbadgevalue = ""
                        UserDefaults.standard.set(cartbadgevalue, forKey: userdefaultKeys().number_of_items_in_Cart)
                        
                        callback(false, result)
                    }
                }else{
                    
                    
                    
                    callback(false, nil)
                }
            }
            
        }
        let coupon = UserDefaults.standard.value(forKey: "yessKey") as? String ?? ""
        let apiStr = ApiKeys.apibase + ApiKeys.getFreeDCI + "\(coupon)/offer/compliment"
        var apiurl = URLComponents(string: apiStr)
        
        
        if isUserLoggedIn {
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            let bucket_id =  DBManager.sharedInstance.getBucketId()
            
            if bucket_id != nil || bucket_id != ""{
                apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                      URLQueryItem(name: "access_token", value: accesstoken),
                                      URLQueryItem(name: "bucket_id", value: bucket_id)
                ]
                callApiFree(apiurl: apiurl)
            }
            else{
                SomeInformationApi.get_bucketid { (succ, bucketid) in
                    apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                          URLQueryItem(name: "access_token", value: accesstoken),
                                          URLQueryItem(name: "bucket_id", value: bucketid ?? "")
                    ]
                    callApiFree(apiurl: apiurl)
                }
            }
           
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            let user_id = GuestUserCredential.user_id
            let bucket_id = DBManager.sharedInstance.getBucketId()
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "bucket_id", value: bucket_id ?? "")
            ]
            
            if bucket_id == nil || bucket_id == "" {
                cartbadgevalue = ""
                callback(false,invalidresult())
                return
                
            }
            callApiFree(apiurl: apiurl)
            
        }
        
        
        
    }
    
    // MARK: - DELETE ITEM FROM CART
    
    class public func delete_item_from_cart( item_id:String , callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        let apiStr = ApiKeys.apibase + ApiKeys.addToCart
        var apiurl = URLComponents(string: apiStr)
        
        
        if isUserLoggedIn{
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "user_id", value: user_id),
                                  
                                  URLQueryItem(name: "item_id", value: item_id)
            ]
            
        }else{
            let user_id = GuestUserCredential.user_id
            
            let accesstoken = GuestUserCredential.access_token
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "user_id", value: user_id),
                                  
                                  URLQueryItem(name: "item_id", value: item_id)
            ]
            
        }
        Alamofire.request(apiurl!,method: .delete, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
            
            if let request_status = result.value(forKey: "request_status") as? Int{
                if request_status == 1{
                    callback(true,result)
                }else{
                    callback(false, result)
                }
            }
            else{
                callback(false,nil)
            }
            
        }
    }
    // MARK: - DELETE CART
    
    class public func delete_cart(  callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        //
        
        var apiurl = URLComponents(string: ApiKeys.deleteCart)
        
        
        if isUserLoggedIn{
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            let bucket_id = DBManager.sharedInstance.getBucketId()
            
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "bucket_id", value: bucket_id)
            ]
        }else{
            let user_id = GuestUserCredential.user_id
            let accesstoken = GuestUserCredential.access_token
            
            let bucket_id = DBManager.sharedInstance.getBucketId()
            
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "bucket_id", value: bucket_id)
            ]
        }
        
        
        Alamofire.request(apiurl!,method: .delete, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
            
            if let request_status = result.value(forKey: "request_status") as? Int{
                if request_status == 1{
                    cartbadgevalue = "0"
                    callback(true, result)
                }
                else{
                    callback(false, result)
                }
            }
            else{
                callback(false, nil)
            }
            
        }
    }
    
    
    // MARK: - UPDATE FEE/TIP
    
    class public func update_fee_tip( taxId:String ,taxRate:String, callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.updateFeeTip)
        
        let user_id:String
        let bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
        let accesstoken : String
        
        if isUserLoggedIn{
            user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accesstoken = (logindata.object?.access_token)!
            
            
            
        } else{
            user_id = GuestUserCredential.user_id
            accesstoken = GuestUserCredential.access_token
            
        }
        apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
        ]
        
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "bucketId" : bucket_id,
                "taxId" : taxId,
                "taxRate" : taxRate,
            ]
        ]
        
        
        Alamofire.request(apiurl!,method: .post,parameters: parametrs, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{return callback(false,result)}
            callback(true,result)
            
        }
    }
    
    
    // MARK: - ADD COUPEN
    
    class public func add_coupen(rule:String, callback:@escaping (( _ success :Bool, _ results: Any?,_ error: String)->())){
        
        var apiurl = URLComponents(string: ApiKeys.addcoupon)
        
        let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
        
        let bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
        let accesstoken : String
        
        if isUserLoggedIn{
            
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accesstoken = (logindata.object?.access_token) ?? ""
            
            
            
        } else{
            accesstoken = GuestUserCredential.access_token
            
        }
        apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
        ]
        
        
        
        
        apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
        ]
        let headers : [String:String] = ["Content-Type":"application/json"]
        
        
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "bucketId" : bucket_id,
                "rule" : rule
            ]
        ]
        
        Alamofire.request(apiurl!,method: .post,parameters: parametrs,encoding: JSONEncoding.default,  headers: headers).responseJSON { (respose) in
            var error = "Failed to apply coupon"
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose,error)}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{
                
                if let obj = result.value(forKey: "object") as? NSDictionary{
                    if let errorstr = obj.value(forKey: "error") as? String{
                       error = errorstr
                    }
                }
                
                return callback(false,result,error)}
            callback(true,result,"Success")
            
        }
    }
    
    
    
    // MARK: - DELETE COUPEN
    
    class public func delete_coupon(rule:String, callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.removeCoupon)
        
        let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
        
        let accesstoken :String
        let bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
        
        if isUserLoggedIn{
            
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accesstoken = (logindata.object?.access_token) ?? ""
        
            
            
        } else{
            accesstoken = GuestUserCredential.access_token
            
        }
        
        
        apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
        ]
        let headers : [String:String] = ["Content-Type":"application/json"]
        
        
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "bucketId" : bucket_id,
                "rule" : rule
            ]
        ]
        
        Alamofire.request(apiurl!,method: .post,parameters: parametrs,encoding: JSONEncoding.default,  headers: headers).responseJSON { (respose) in
            
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{return callback(false,result)}
            callback(true,result)
            
        }
    }
    
    
    
    
    private func parseProduvt_Category_Data(_ data: NSDictionary){
        
    }
}


