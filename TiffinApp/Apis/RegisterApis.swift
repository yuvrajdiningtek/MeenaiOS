// alamofire —-header is always [String:String]
//http://server.avrsh.in/json-server//restaurants/951b86ebef0c3ef40d3f38f76da17242/menu
import Foundation
import Alamofire
import Stripe


class RegisterApi:NSObject{
    
    //MARK: - MERCHANT TOKEN
    
    
    class public func merchant_token(callback:@escaping (( _ success :Bool, _ access_token: String?)->())){
        
        let headers : [String:String] = ["Content-Type":"application/json",
                                         "key":"meenas",
                                         "secret":"meenas"]
        
        
        let apiurl = URL(string: ApiKeys.merchantToken)
        
        
        
        Alamofire.request(apiurl!,method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            print(apiurl,respose.result.value as? NSDictionary)
            
            guard let rst = respose.result.value as? NSDictionary else{callback(false, nil);return}
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else{callback(false, nil); return}
            guard let object = rst.value(forKey: "object") as? NSDictionary else{callback(false, nil); return}
            guard let access_token = object.value(forKey: "access_token") as? String else{callback(false, nil); return}
            UserDefaults.standard.set(access_token, forKey: userdefaultKeys().merchant_access_token)

            callback(true, access_token)
            
        }
    }
   
    static func registerDevice( email : String ,accesstoken : String,callback:@escaping (( _ success :Bool, _ results: Any?, _ error:(Error)?)->())){
        let urlStr : String = ApiKeys.registerDeviceUser
        
        //iPhone or iPad
        let model = UIDevice.current.model
       
        let deviceid = UIDevice.current.identifierForVendor?.uuidString ?? ""
       
        let deviceInfo = UIDevice.current.name
        let smartDeviceOS = UIDevice.current.systemName
        let deviceToken = UserDefaults.standard.value(forKey: "deviceToken") as? String
        
        let parameters : [String:Any] = ["user_id":email ,
                                         "fields":[
                                            "smartDeviceOS" : "IPHONE",
                                            "deviceToken" : deviceToken,
                                            "deviceId" : deviceid,
                                            "deviceInfo" : deviceInfo,
                                            "pushNotificationService":[
                                                "groupName" : "TIFFIN_IOS"
                                            ]
            ]
        ]
        
        
        let headers : [String:String] = [
            "Content-Type":"application/json",
            "device_id":deviceid
        ]
        
        var urlComponent = URLComponents(string: urlStr)
        urlComponent?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
        ]
        
        print("url",urlComponent)
        
        Alamofire.request(urlComponent!,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            
            switch (respose.result) {
            case .success:
                //do json stuff
                guard let result = respose.result.value as? NSDictionary else {return callback(false,respose,nil)}
                
                guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{
                    
                    if let obj = result.value(forKey: "object") as? NSDictionary{
                        if let error = obj.value(forKey: "error") as? String{
//                            callback(false,result,RuntimeError(error) )
                            return
                        }
                    }
                    callback(false,result,nil)
                    return
                }
                
                callback(true,result,nil)
                
                break
            case .failure(let error):
                
                callback(false,nil,error)
                break
            }
        }
    }
    
    
    
    
    //MARK: - REGISTER USER
    

    class public func register_user(registrationEmail:String,registrationPassword:String, registrationMobile:String,registrationFirstName:String,registrationLastName:String,registrationCity:String,callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        
        let parameters : [String:Any] = [
            "form_id" : "",
            
            
            "fields" : [
                "registrationEmail" : registrationEmail,
                "registrationPassword" : registrationPassword,
//                "registrationMobile" : registrationMobile,
                "registrationFirstName" : registrationFirstName,
                "registrationLastName" : registrationLastName,
//                "registrationCity" : registrationCity,
                "registrationMiddleName" : "s"
                
                
            ]
        ]
        
       

        var apiurl = URLComponents(string: ApiKeys.registerUser)
        let access_token = UserDefaults.standard.value(forKey: userdefaultKeys().merchant_access_token) as? String ?? ""
        
        
         let   bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
       
        
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let headers : [String:String] = ["Content-Type":"application/json",
                                         "device_id":udid]
        apiurl?.queryItems = [
                              URLQueryItem(name: "access_token", value: access_token),
                              URLQueryItem(name: "bucket_id", value: bucket_id)
                              
        ]
        
        
        Alamofire.request(apiurl!,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
           
            guard let rst = respose.result.value as? NSDictionary else{callback(false, respose);return}
            guard let request_status = rst.value(forKey: "request_status") as? Int , request_status == 1 else{callback(false, rst); return}
            
            
            callback(true, rst)
            
        }
    }
    
    //MARK: - Verify OTP
    class public func verify_otp( user: String, state: String,callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        let apiurl : String = ApiKeys.verifyOtp
        let headers : [String:String] = ["Content-Type":"application/json",
                                         "key":"meenas",
                                         "secret":"meenas",
                                                "device_id":udid]
        
        
        
        let parameters :[String:Any] = ["user":user,
                                       "state":state,
                                       "otp":"111111"]
        
        
        Alamofire.request(apiurl,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{return callback(false,result)}
            
            if DBManager.sharedInstance.get_loginUser_DataFromDB().count != 0{
                let data = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
                DBManager.sharedInstance.deleteFromDb(object: data)
                let objc = DBManager.sharedInstance.database.objects(LoginObject.self)
                try? DBManager.sharedInstance.database.write {
                    DBManager.sharedInstance.database.delete(objc)
                }
                
            }
//            isUserLoggedIn = true
            DBManager.sharedInstance.create_logindata_DB(value: result)
            if DBManager.sharedInstance.database.objects(LoginUserDAta.self).count != 0{
            }
            callback(true,result)
        }
    }
    
    //MARK: - LOGIN USER
    class public func login_user( parameters : [String:Any],callback:@escaping (( _ success :Bool, _ results: Any?, _ error:(Error)?)->())){
        
        
        
//        SomeInformationApi.get_bucketid(callback: { (succ, err) in
//                       if succ{
//                           ProductsApi.detail_Cart_Info(callback: { (ss, _, _) in
//                            //   callback(ss)
//                           })
//                       }else{
//                          // callback(false)
//                       }
//                   })
        
        
        var loginurl  = URLComponents(string: ApiKeys.loginUser)
        
        let udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
        let headers: HTTPHeaders = [
            "key": "meenas",
            "secret": "meenas",
            "Content-Type": "application/json",
            "device_id" : udid
        ]
        loginurl?.queryItems = [
                              URLQueryItem(name: "bucket_id", value: bucket_id)
        ]

        
        Alamofire.request(loginurl!,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            
            switch (respose.result) {
            case .success:
                //do json stuff
                guard let result = respose.result.value as? NSDictionary else { callback(false,respose,nil)
                    return
                }
                guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{ callback(false,result,nil)
                    return
                }
                DBManager.sharedInstance.deleteAllFromDatabase()
                DBManager.sharedInstance.create_logindata_DB(value: result)
                
                callback(true,result,nil)
                
                break
            case .failure(let error):
                
                callback(false,nil,error)
                break
            }
           
            
        }
    }
    //MARK: - UPDATE USER PROFILE
    class public func update_user_profile(email:String,primaryPhone : String,firstName:String, middleName:String,lastName:String,callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.updateUserProfile)
        
        let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
        let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
        let accesstoken = (logindata.object?.access_token)!
        let parameters : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "email" : email,
                "primaryPhone" : primaryPhone,
                "firstName" : firstName,
                "middleName" : middleName,
                "lastName" : lastName
                
            ]
        ]
        apiurl?.queryItems = [
                              URLQueryItem(name: "access_token", value: accesstoken)
        ]
        
        
        Alamofire.request(apiurl!,method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (respose) in
            
            guard let result = respose.result.value as? NSDictionary else {return callback(false,respose)}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{return callback(false,result)}
            if DBManager.sharedInstance.get_userInfo_DataFromDB().count != 0{
                let data = DBManager.sharedInstance.get_userInfo_DataFromDB()[0] as UserInfo
                DBManager.sharedInstance.deleteFromDb(object: data)
                let objc = DBManager.sharedInstance.database.objects(UserInfoObject.self)
                try? DBManager.sharedInstance.database.write {
                    DBManager.sharedInstance.database.delete(objc)
                }
                
            }
            
            DBManager.sharedInstance.create_userInfo_DB(value: result)
            callback(true,result)
            
        }
    }
    
    //MARK: - MERCHANT ID
        class public func merchant_id( callback:@escaping (( _ success :Bool, _ results: Any?, _ urlOfprodCAt:String?)->())){
            
            var apiurl = URLComponents(string: ApiKeys.merchantID)
            
            if isUserLoggedIn {
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
            
            print("----",apiurl)
            
            Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
                
                if respose.result.value != nil{
                    if let a = respose.result.value as? NSDictionary{
                        
                        if let request_status = a.value(forKey: "request_status") as? Int {
                            if request_status == 1{
                                
                                print("\n\n\n\n/n//nn/n\n\\n\n",respose.result.value,"\n\\n\n\n\n\n\n\n\n")
                                
                                DBManager.sharedInstance.create_merchantIDData_DB(value: a)
                                
                                let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
                                
                                print(MD.object?.STRIPE_PUBLISHABLE_KEY)
                                
                                let isShopOpen = MD.object?.IS_SHOP_OPEN
                                
                                let merchantIDD = MD.object?.MERCHANT_ID
                                UserDefaults.standard.setValue(merchantIDD, forKey: "m_idd")
                                
                                guard let _ = a.value(forKey: "request_status") as? Int else {
                                    return
                                }
                                
                                
                                guard let object = a.value(forKey: "object") as? [String:Any] else {return}
                             
                             print(object)
                                
                                STPPaymentConfiguration.shared().publishableKey = object["STRIPE_PUBLISHABLE_KEY"] as! String
                                
                                 let MERCHANT_ID = object["MERCHANT_ID"] as? String ?? ""
                                 let STATIC_RESOURCE_CATEGORIES_PREFIX = object["STATIC_RESOURCE_CATEGORIES_PREFIX"] as? String ?? ""
                             let STATIC_RESOURCE_ENDPOINT = object["STATIC_RESOURCE_ENDPOINT"] as? String ?? ""
                         let STATIC_RESOURCE_SUFFIX = object["STATIC_RESOURCE_SUFFIX"] as? String ?? ""
                     let ORDER_AHEAD_DAYS = object["ORDER_AHEAD_DAYS"] as? [String] ?? []
                        print(ORDER_AHEAD_DAYS,"----------")
                        UserDefaults.standard.setValue(ORDER_AHEAD_DAYS, forKey: "ORDER_AHEAD_DAYS")
                                if let SHOP_TIMING = object["SHOP_TIMING"] as? [[String:Any]]{
                                    UserDefaults.standard.setValue(SHOP_TIMING, forKey: "SHOP_TIMING")

                                }

                                 let ENABLE_ORDER_AHEAD = object["ENABLE_ORDER_AHEAD"] as? Bool ?? false
                                    UserDefaults.standard.setValue(ENABLE_ORDER_AHEAD, forKey: "ENABLE_ORDER_AHEAD")
                                

                             
                                
                                if let requestId = a.value(forKey: "requestId") as? String{
                                }
                                
                                let urlofProdCat = STATIC_RESOURCE_ENDPOINT+STATIC_RESOURCE_CATEGORIES_PREFIX+MERCHANT_ID+STATIC_RESOURCE_SUFFIX
                                print(urlofProdCat)
                                callback(true, respose.result.value, urlofProdCat)
                                guard let _ = object["FEES"] as? String else {
                                    return
                                }
                                return
                            }else{
                                callback(false,a,nil)
                                return
                            }
                        }
                    }
                    callback(false,nil,nil)
                    
                    
                }else{
                    callback(false, nil, nil)
                }
            }
        }
     
    //MARK: - MERCHANT DETAIL
    class public func merchant_detail( callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        var apiurl = ""
        if DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0{
            let merchantidOBJ = DBManager.sharedInstance.get_merchntId_DataFromDB() [0] as MerchantID
            let IS_SHOP_OPEN = (merchantidOBJ.object?.IS_SHOP_OPEN)!
            let merchantid = (merchantidOBJ.object?.MERCHANT_ID)!
            
            
            let STATIC_RESOURCE_ENDPOINT = (merchantidOBJ.object?.STATIC_RESOURCE_ENDPOINT)!
            let STATIC_RESOURCE_SUFFIX = (merchantidOBJ.object?.STATIC_RESOURCE_SUFFIX)!
            apiurl = STATIC_RESOURCE_ENDPOINT + merchantid + STATIC_RESOURCE_SUFFIX
        }
        
        Alamofire.request(apiurl,method: .get, encoding: JSONEncoding.default).responseJSON { (respose) in
            
            if let rst = respose.result.value as? NSDictionary{
                
                
                if let request_status = rst.value(forKey: "request_status") as? Int{
                    if  request_status == 1{
                        if DBManager.sharedInstance.get_merchntdetail_DataFromDB().count != 0{
                            let data = DBManager.sharedInstance.get_merchntdetail_DataFromDB()[0] as MerchantDetail
                            DBManager.sharedInstance.deleteFromDb(object: data)
                            
                        }
                        DBManager.sharedInstance.create_merchantDetail_DB(value: rst)
                        
                        if (rst.value(forKey: "request_status") as? Int) == 1{
                            callback(true,respose.result.value)
                        }else{
                            callback(false,respose.result.value)
                        }
                        return
                    }
                    if DBManager.sharedInstance.database.objects(MerchantDetail.self).count != 0{
                        
                       
                    }
                    
                }
                else{
                        callback(false, rst)
                        return
                    }
                }
            callback(false, nil)
                
            
        }
    }
    //MARK: - CREATE AND UPDATE ADDRESS
    class public func update_address( parameter : [String:Any],callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.updateAddress)
        
        if isUserLoggedIn {
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken)
            ]
            
        }else{
            let accesstoken = GuestUserCredential.access_token
            let user_id = GuestUserCredential.user_id
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken)
            ]
            
        }
        
        
        
        let headers: [String:String] = [
            "Content-Type" : "application/json"
        ]
        
       
        Alamofire.request(apiurl!,method: .post,parameters: parameter,encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            if let  request_status = rst.value(forKey: "request_status") as? Int , request_status != 1 {
                callback(false,respose)
                return
            }else{
                callback(true, rst)
            }
        }
        
        
    }
    
    //MARK: - CREATE AND UPDATE SHIPPING ADDRESS
    class public func update_shipping_address( bucket_id:String,shippingId:String,callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        var apiurl = URLComponents(string: ApiKeys.updateShippingMethod)
        var user_id = ""
        if isUserLoggedIn{
             user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken)
            ]
            
        }else{
             user_id = GuestUserCredential.user_id
            let accesstoken = GuestUserCredential.access_token
            
            
            apiurl?.queryItems = [
                URLQueryItem(name: "access_token", value: accesstoken)
            ]
        }
        
        let headers: [String:String] = [
            
            "Content-Type" : "application/json"
        ]
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "bucketId" : bucket_id,
                "shippingId" : shippingId
            ]
        ]
        
        
        Alamofire.request(apiurl!,method: .post,parameters: parametrs,encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            if let  request_status = rst.value(forKey: "request_status") as? Int , request_status != 1 {
                callback(false,respose)
                return
            }else{
                callback(true, rst)
            }
        }
        
        
    }
    //MARK: - Delete Address
    
    class public func delete_address( address_id : String,callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        var apiurl = URLComponents(string: ApiKeys.updateAddress)
        
        if isUserLoggedIn{
            let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "address_id", value: address_id)
                
            ]
        }
        else{
            let user_id = GuestUserCredential.user_id
            let accesstoken = GuestUserCredential.access_token
            
            
            apiurl?.queryItems = [URLQueryItem(name: "user_id", value: user_id),
                                  URLQueryItem(name: "access_token", value: accesstoken),
                                  URLQueryItem(name: "address_id", value: address_id)
                
            ]
        }
        
        
        let headers: [String:String] = [
            
            "Content-Type" : "application/json"
        ]
        
        
        Alamofire.request(apiurl! , method: .delete ,encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            guard let rst = respose.result.value as? NSDictionary else {return callback(false,respose)}
            if let  request_status = rst.value(forKey: "request_status") as? Int , request_status != 1 {
               // DeleteDataBaseObjects.deleteAddress()

                callback(false,respose)
                return
            }else{
                callback(true, rst)
            }
        }
    }

    
    
    // MARK: - BANK CARDS
    
    class public func addBankCard( cardname : String,cardNumber : String,cardExpYear : String,cardExpMonth : String,CardCvv : String,cardType : String,  callback:@escaping (( _ success :Bool, _ results: Any?,_ error : String?)->())){
        
        let apiStr = ApiKeys.addcard
        var apiurl = URLComponents(string: apiStr)
        var userid = ""
        var accesstoken = ""
        
        if isUserLoggedIn {
            userid = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accesstoken = (logindata.object?.access_token)!
            
        }else{
            userid = GuestUserCredential.user_id
             accesstoken = GuestUserCredential.access_token
            
        }
        apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)]
        
        let parameters : [String:Any] = [
            "user_id" : userid,
            "fields" : [
            
                "cardName" : cardname,
                "cardNumber" : cardNumber,
                "cardExpYear" : cardExpYear,
                "cardExpMonth" : cardExpMonth,
                "cardCvv" : CardCvv,
                "bankCardType" : cardType
            
            ]
        ]
        
        
        let headers : [String:String] = ["Content-Type":"application/json"]
        
        
        Alamofire.request(apiurl!,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            if let result = respose.result.value as? NSDictionary{
                guard let request_status = result.value(forKey: "request_status") as? Int , request_status == 1 else{
                    
                    
                    if let object = result.value(forKey: "object") as? NSDictionary{
                        if let error = object.value(forKey: "error") as? String{
                            callback(false, result,error)
                            return
                        }
                    }
                    callback(false,result,nil)
                    return
                }
                
                
                
                callback(true,result,nil)
            }else{
                callback(false, nil,nil)
            }
            
        }
    }
    
    
    class public func getBankCards(   callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        let apiStr = ApiKeys.getAllcard
        var apiurl = URLComponents(string: apiStr)
        var userid = ""
        var accesstoken = ""
        
        if isUserLoggedIn {
            userid = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accesstoken = (logindata.object?.access_token)!
            
        }else{
            userid = GuestUserCredential.user_id
            accesstoken = GuestUserCredential.access_token
            
        }
        apiurl?.queryItems = [URLQueryItem(name: "user_id", value: userid),
            URLQueryItem(name: "access_token", value: accesstoken)]
        
        
        let headers : [String:String] = ["Content-Type":"application/json"]
        
        
        Alamofire.request(apiurl!,method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            if let result = respose.result.value as? NSDictionary{
                guard let request_status = result.value(forKey: "request_status") as? Int , request_status == 1 else{
                    callback(false,result)
                    return
                }
                let bnkcards = DBManager.sharedInstance.database.objects(BankCards.self)
                let objBnkCards = DBManager.sharedInstance.database.objects(ObjectBankCardModel.self)
                
                try! DBManager.sharedInstance.database.write {
                    DBManager.sharedInstance.database.delete(bnkcards)
                    DBManager.sharedInstance.database.delete(objBnkCards)
                    DBManager.sharedInstance.database.create(BankCards.self, value: result, update: false)
                }
                
                callback(true,result)
            }
            else{
                callback(false, nil)
            }            
        }
    }

    
    
    
    class public func deleteBankCard(card_id : String,   callback:@escaping (( _ success :Bool, _ results: Any?,_ error : String? )->())){
        
        let apiStr = ApiKeys.deletecard
        var apiurl = URLComponents(string: apiStr)
        var userid = ""
        var accesstoken = ""
        
        if isUserLoggedIn {
            userid = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accesstoken = (logindata.object?.access_token)!
            
        }else{
            userid = GuestUserCredential.user_id
            accesstoken = GuestUserCredential.access_token
            
        }
        apiurl?.queryItems = [URLQueryItem(name: "user_id", value: userid),
                              URLQueryItem(name: "access_token", value: accesstoken),
                              URLQueryItem(name: "card_id", value: card_id)
        ]
        
        
        let headers : [String:String] = ["Content-Type":"application/json"]
        
        
        Alamofire.request(apiurl!,method: .delete, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            if let result = respose.result.value as? NSDictionary{
                guard let request_status = result.value(forKey: "request_status") as? Int , request_status == 1 else{
                    
                    if let object = result.value(forKey: "object") as? NSDictionary{
                        if let error = object.value(forKey: "error") as? String{
                            callback(false, result,error)
                            return
                        }
                    }
                    
                    callback(false,result,nil)
                    return
                }
                
                
                callback(true,result,nil)
            }
            else{
                callback(false, nil,nil)
            }
        }
    }
}
