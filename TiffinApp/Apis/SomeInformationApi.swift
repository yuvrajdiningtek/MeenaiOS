//
//  SomeInformationApi.swift
//  TiffinApp
//
//  Created by yuvraj kakkar on 23/05/18.
//  Copyright © 2018 YAY. All rights reserved.
//

import Foundation
import Alamofire

class SomeInformationApi : NSObject{
    
    
    //MARK: - GET CURRENCY
    class public func getcurrency( callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var currncy = ""
        
        var apiurl = URLComponents(string: ApiKeys.getCurrency)
        
        
        if  DBManager.sharedInstance.get_merchntdetail_DataFromDB().count != 0 {
            let merchantDetail = DBManager.sharedInstance.get_merchntdetail_DataFromDB()[0] as MerchantDetail
            currncy = merchantDetail.object?.CURRENCY ?? ""
        }
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [URLQueryItem(name: "status", value: "ACTIVE"),
                                  URLQueryItem(name: "name", value: currncy),
                                  URLQueryItem(name: "access_token", value: accesstoken)
            ]
        }
        else{
            let accesstoken = GuestUserCredential.access_token
            
            
            apiurl?.queryItems = [URLQueryItem(name: "status", value: "ACTIVE"),
                                  URLQueryItem(name: "name", value: currncy),
                                  URLQueryItem(name: "access_token", value: accesstoken)
            ]
        }
        
        
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else{callback(false, respose);return}
            guard let request_status = rst.value(forKey: "request_status") as? Int else{callback(false, respose); return}
            if request_status == 1{
                if let data = rst.value(forKey: "data") as? [NSDictionary] {
                    
                    
                    if DBManager.sharedInstance.get_currency_DataFromDB().count != 0{
                        let data = DBManager.sharedInstance.get_currency_DataFromDB()[0] as CurrencyModel
                        DBManager.sharedInstance.deleteFromDb(object: data)
                        let obj = DBManager.sharedInstance.database.objects(DataCurrencyModel.self)
                        
                        try? DBManager.sharedInstance.database.write {
                            DBManager.sharedInstance.database.delete(obj)
                        }
                        
                    }
                    
                    DBManager.sharedInstance.create_currency_DB(value: rst)
                     callback(true, rst)
                    return
                }
                 callback(false, rst)
                return
            }else{
                callback(false, rst)
                
            }
            
        }
    }
    
    
    //MARK: - GET Existing Address
    class public func get_existing_address( pageNumber : String , callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.apibase + ApiKeys.getAddresses)
        let pageSize = String(describing : (10 * Int(pageNumber)! + 10))

       
        if isUserLoggedIn {
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "pageSize", value: pageSize),
                                  URLQueryItem(name: "pageNumber", value: "0")
                
            ]
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            let user_id = GuestUserCredential.user_id
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "pageSize", value: pageSize),
                                  URLQueryItem(name: "pageNumber", value: "0")
                
            ]
        }
        
         print(apiurl)
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            
            if let request_status = rst.value(forKey: "request_status") as? Int{
                if request_status == 1{
                    DeleteDataBaseObjects.deleteAddress()
                    
                    DBManager.sharedInstance.create_Adress_DB(value: rst)
                    callback(true,rst)
                }
                else{
                    callback(false,rst)
                }
            }
            else{
                callback(false,rst)
            }
            
            
        }
    }
    
    
    //MARK: - GET country
    class public func get_country( callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        var apiurl = URLComponents(string: ApiKeys.getCountries)
        
        
        if isUserLoggedIn {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [URLQueryItem(name: "pageSize", value: "250"),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "status", value: "ACTIVE")
                
                
            ]
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            
            apiurl?.queryItems = [URLQueryItem(name: "pageSize", value: "250"),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "status", value: "ACTIVE")                                  
            ]
        }
        
        
        
        
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            if let  request_status = rst.value(forKey: "request_status") as? Int , request_status != 1 {
                
                
               callback(false,respose)
                return
            }else{
                if DBManager.sharedInstance.get_countries_DataFromDB().count != 0{
                    let data = DBManager.sharedInstance.get_countries_DataFromDB()[0] as CountryModel
                    DBManager.sharedInstance.deleteFromDb(object: data)
                    
                    let obj1 = DBManager.sharedInstance.database.objects(DatainCountryModel.self)
                    try? DBManager.sharedInstance.database.write {
                        DBManager.sharedInstance.database.delete(obj1)
                    }
                    
                }
                
                DBManager.sharedInstance.create_Country_DB(value: rst)
                
                
                callback(true, rst)
            }
            
            
        }
    }
    
    //MARK: - GET state
    class public func get_state( countryid : String,callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        var apiurl = URLComponents(string: ApiKeys.getState)
        
        if isUserLoggedIn {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [URLQueryItem(name: "pageSize", value: "250"),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "status", value: "ACTIVE"),
                                  URLQueryItem(name: "country_id", value: countryid)
                
            ]
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            
            apiurl?.queryItems = [URLQueryItem(name: "pageSize", value: "250"),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "status", value: "ACTIVE"),
                                  URLQueryItem(name: "country_id", value: countryid)
                
            ]
        }
        
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            if let  request_status = rst.value(forKey: "request_status") as? Int , request_status != 1 {
                callback(false,respose)
                return
            }else{
                callback(true, rst)
            }
            
            
        }
    }
    
    class public func getStateName( countryid : String,stateId : String, callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.getState)
        
        if isUserLoggedIn {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  
                                  URLQueryItem(name: "country_id", value: countryid),
                                  URLQueryItem(name: "regionId", value: stateId)
                
            ]
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            
            apiurl?.queryItems = [
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  
                                  URLQueryItem(name: "country_id", value: countryid),
                                  URLQueryItem(name: "regionId", value: stateId)
                
            ]
        }
        
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            if let  request_status = rst.value(forKey: "request_status") as? Int , request_status != 1 {
                callback(false,respose)
                return
            }else{
                callback(true, rst)
            }
        }
    }
    //MARK: - GET Bucket ID
    
    class public func get_bucketid( callback:@escaping (( _ success :Bool, _ bucket: String?)->())){
        var apiurl = URLComponents(string: ApiKeys.getBucketID)
        if isUserLoggedIn {
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""

            
            apiurl?.queryItems = [
                URLQueryItem(name: "user_id", value: user_id),
                URLQueryItem(name: "access_token", value: accesstoken)
            ]
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            let user_id = GuestUserCredential.user_id
            
            apiurl?.queryItems = [
                URLQueryItem(name: "user_id", value: user_id),
                URLQueryItem(name: "access_token", value: accesstoken)
                
            ]            
        }
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,nil)}
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else {
                cartbadgevalue = ""
                 callback(false,nil)
                return
            }
            guard let object = rst.value(forKey: "object") as? NSDictionary  else { callback(false,nil)
                return
            }
            guard let  bucketId = object.value(forKey: "bucketId") as? String else{ callback(false,nil)
                return
            }
            DBManager.sharedInstance.saveBuketId(bucket: bucketId)
            callback(true,bucketId)
        }
    }
    
    
    //MARK: - user information
    class public func get_user_info(callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        var apiurl = URLComponents(string: ApiKeys.getuserInfo)
        
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken),
                
                URLQueryItem(name: "user_id", value: user_id)                
            ]
        }
        else{
            
            let accesstoken = GuestUserCredential.access_token
            let user_id = GuestUserCredential.user_id
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken),
                
                URLQueryItem(name: "user_id", value: user_id)
                
            ]
        }
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else {return callback(false,rst)}
            if DBManager.sharedInstance.get_userInfo_DataFromDB().count != 0{
                let data = DBManager.sharedInstance.get_userInfo_DataFromDB()[0] as UserInfo
                DBManager.sharedInstance.deleteFromDb(object: data)
                
            }
            
            DBManager.sharedInstance.create_userInfo_DB(value: rst)
            
            callback(true,rst)

        }
    }
    
    
    //MARK: - Check Payment Status
    class public func check_Payment_Status(orderId:String,callback:@escaping (( _ success :Bool, _ orderstatus: [NSDictionary]?)->())){
        var apiurl = URLComponents(string: ApiKeys.checkPaymentStatus)
        
        var user_id = ""
        var accesstoken = ""
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
             accesstoken = (logindata.object?.access_token)!
             user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            
            
        }else{
            
            accesstoken = GuestUserCredential.access_token
            user_id = GuestUserCredential.user_id
            
        }
        
       
        
        apiurl?.queryItems = [
            URLQueryItem(name: "access_token", value: accesstoken)
           
            
        ]
        
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "orderId" : orderId,
                
            ]
        ]
        
       
        
        Alamofire.request(apiurl!,method: .post,parameters: parametrs, encoding: JSONEncoding.default).responseJSON { (respose) in
            
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,nil)}
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else {return callback(false,nil)}
            guard let object = rst.value(forKey: "object") as? NSDictionary  else {return callback(false,nil)}
            guard let orderStatus = object.value(forKey: "orderStatus") as? [NSDictionary]  else {return callback(false,nil)}
            
            callback(true,orderStatus)
            
        }
    }
    
    //MARK: - GET USER COUPONS
    class public func get_coupons(callback:@escaping (( _ success :Bool, _ results: [CouponsModel])->())){
        var apiurl = URLComponents(string: ApiKeys.getCoupons)
        
        
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken)
                
            ]
        }else{
            let accesstoken = GuestUserCredential.access_token
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken)
                
            ]

        }
        
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            var cm = [CouponsModel]()
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,cm)}
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else {return callback(false,cm)}
            guard let data = rst.value(forKey: "data") as? [NSDictionary] else {return callback(false,cm)}
            
            for i in data{
                let ds = CouponsModel(dict: i )
                cm.append(ds)
            }
            
            callback(true,cm)
            
        }
    }

    //MARK: - GET Gallery
    class public func get_galleryImages( callback:@escaping (( _ success :Bool, _ results: [String]?, _ error : String)->())){
        // home screen header images
        
        var apiurl = URLComponents(string: ApiKeys.galleryImages)
        var header : [String:String] = ["authorization":""]
        
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            header["authorization"] = "Bearer " + accesstoken
        }
        else{
            let accesstoken = GuestUserCredential.access_token
            header["authorization"] = "Bearer " + accesstoken
        }
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default, headers : header).responseJSON { (respose) in
            
            
            let errormsg = "unknown error"
            
            switch respose.result{
            case .success(let rst):
                guard let rst = rst as? NSDictionary else{callback(false, nil, errormsg);return}
                guard let request_status = rst.value(forKey: "request_status") as? Int else{callback(false, nil, errormsg); return}
                if request_status == 1{
                    let arr = GetData.getImagesUrlArr(data: rst)
                    DeleteDataBaseObjects.deleteGalleryImages()
                    DBManager.sharedInstance.create_Gallery_DB(value: arr)
                    callback(true, arr,"success")
                    return
                }else{
                    callback(false, nil,errormsg)
                    
                }
                break
            case .failure(let err):
                callback(false,nil,err.localizedDescription)
                break
            }
            
        }
    }
    
    //MARK: - GET RESTRAUNT TIMING
    
    class public func restraunt_timing(secVersion : Bool ,callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.restaurantTiming)
        if secVersion{
            apiurl = URLComponents(string: ApiKeys.restaurantTiming_v2)
        }
        var header : [String:String] = ["authorization":""]

        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            header["authorization"] = "Bearer " + accesstoken
        }
        else{
            let accesstoken = GuestUserCredential.access_token
            header["authorization"] = "Bearer " + accesstoken
        }
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default, headers : header).responseJSON { (respose) in

            guard let rst = respose.result.value as? NSDictionary else {return callback(false,nil)}
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else {return callback(false,nil)}
            if secVersion{
                let db =  DBManager.sharedInstance.create_timingV2_DB(value: rst)
                callback(true,db)
            }
            else{
                let db =  DBManager.sharedInstance.create_timing_DB(value: rst)
                callback(true,db)
            }
            
            
        }
    }

    //MARK: - CHECK RESTRAUNT IS OPEN
    class public func checkrestrauntIsOpen(callback:@escaping (( _ open :Bool, _ error: String?)->())){
        
        let apiurl = URLComponents(string: ApiKeys.restaurantOpenOrClose)
        
        var header : [String:String] = ["authorization":""]
        
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            header["authorization"] = "Bearer " + accesstoken
        }
        else{
            let accesstoken = GuestUserCredential.access_token
            header["authorization"] = "Bearer " + accesstoken
        }
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default, headers : header).responseJSON { (respose) in
            
            var errorMsg = "Server error"
            switch respose.result{
            case .success(let rstt):
                guard let rst = rstt as? NSDictionary else { callback(false,errorMsg)
                    return
                }
                guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else { callback(false,errorMsg)
                    return
                }
                guard let object = rst.value(forKey: "object") as? Int else{
                    callback(false,errorMsg)
                    return
                }
                let open = (object == 1) ? true : false
                callback(open,nil)
            case .failure(let err):
                errorMsg = err.localizedDescription
                callback(false,errorMsg)
            }
            
        }
    }

//    //MARK: - SEARCH NEARBY RESTAURANTS
//    class public func get_nearbyRestaurants(distance min : CGFloat = 0, distance max : CGFloat = 15 ,address : String?,callback:@escaping (( _ success :Bool, _ results: SearchNearByRestaurantModel?)->())){
//        var apiurl = URLComponents(string: ApiKeys.nearbyRestaurants)
//        
//        apiurl?.queryItems = [
//            URLQueryItem(name: "distance_min", value: "\(min)"),
//            URLQueryItem(name: "distance_max", value: "\(max)"),
//            URLQueryItem(name: "page", value: "0"),
//            URLQueryItem(name: "size", value: "10"),
//            URLQueryItem(name: "search", value: "REGIONAL"),
//            URLQueryItem(name: "serviceType", value: "NO"),
//            URLQueryItem(name: "address", value: address ?? "Boulder"),
//            
//        ]
//        
//        if isUserLoggedIn{
//            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
//            let accesstoken = (logindata.object?.access_token)!
//            apiurl?.queryItems?.append(URLQueryItem(name: "access_token", value: accesstoken))
//        }else{
//            let accesstoken = GuestUserCredential.access_token
//            apiurl?.queryItems?.append(URLQueryItem(name: "access_token", value: accesstoken))
//        }
//        
//        
//        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
//            
//            guard let rst = respose.result.value as? NSDictionary else { callback(false,nil)
//                return
//            }
//            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else { callback(false,nil)
//                return
//            }
//            let model = SearchNearByRestaurantModel(value: rst)
//            
//            callback(true,model)
//        }
//    }

}
