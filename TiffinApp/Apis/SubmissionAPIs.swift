

import Foundation
import Alamofire

class SubmissionAPIs : NSObject{
    
    // MARK: - PLACE ORDER
    class public func placeOrder_api( placeOrderModel: PlaceOrderModel , guestPlaceOrderModel : GuestPlaceOrderModel?, callback:@escaping (( _ success :Bool, _ results: Any?, _ error : String)->())){
        
        var apiurl = URLComponents(string: ApiKeys.checkout)
        
        let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
        var accesstoken = GuestUserCredential.access_token
        if isUserLoggedIn{
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
             accesstoken = (logindata.object?.access_token)!
            
        }
        let deviceToken = UserDefaults.standard.value(forKey: "deviceToken") as? String
        print(apiurl)
        let bucket_id : String = DBManager.sharedInstance.getBucketId() ?? ""

        
        apiurl?.queryItems = [
            URLQueryItem(name: "access_token", value: accesstoken)
        ]
        var parametrs : [String:Any] =  [String:Any]()
        if guestPlaceOrderModel == nil{
             parametrs  = [
                "form_id" : "",
                "user_id" : user_id,
                
                "fields" : [
                    "bucketId" : bucket_id,
                    "addressId" : placeOrderModel.addressId!,
                    "notes" : placeOrderModel.notes!,
                    "orderDate" : "",
                    "orderTime" : "",
                    "paymentType" : "stripe",
                    "instrumentMode" : "cc",
                    "gatewayId" : placeOrderModel.gatewayId!,
                    "cardToken" : placeOrderModel.cardToken!,
                    "subscriberContainers": [ [
                        "token" : deviceToken]
                        ]
                ]
            ]
        }
        
        else if guestPlaceOrderModel != nil{
            parametrs  = [
                "form_id" : "",
                "user_id" : GuestUserCredential.user_id,
                
                "fields" : [
                    "bucketId" : bucket_id,
                    "addressId" :   placeOrderModel.addressId ?? "",
                    "notes" : placeOrderModel.notes!,
                    "orderDate" : "",
                    "orderTime" : "",
                    "paymentType" : "stripe",
                    "instrumentMode" : "cc",
                    "gatewayId" : placeOrderModel.gatewayId!,
                    "cardToken" : placeOrderModel.cardToken!,
                    "firstName" : guestPlaceOrderModel!.firstName!,
                    "lastName" : guestPlaceOrderModel!.lastName!,
                    "mobileNumber" : guestPlaceOrderModel!.mobileNumber!,
                    "email" : guestPlaceOrderModel!.email!,
                    "address1" : guestPlaceOrderModel!.address1!,
                    "city" : guestPlaceOrderModel!.city!,
                    "state" : guestPlaceOrderModel!.state!,
                    "postalCode" : guestPlaceOrderModel!.postalCode!,
                    "country" : 254,
                    "subscriberContainers": [ [
                        "token" : deviceToken]
                    ]
                ]
        ]
        }
        
print("oo",apiurl)
        print(parametrs)
        Alamofire.request(apiurl!,method: .post, parameters: parametrs,encoding: JSONEncoding.default).responseJSON { (respose) in
            var error = "Failed to place your order"
            
            guard let result = respose.result.value as? NSDictionary else { callback(false,nil,error);return}
           
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{
                if let object = result.value(forKey: "object") as? NSDictionary {
                    if let error_fromApi = object.value(forKey: "error") as? String{
                        error = error_fromApi
                    }
                }
                callback(false,result,error);
                return}
            DBManager.sharedInstance.deleteBucketId()
            callback(true,result,"success")
            
        }
    }
    
    
    // MARK: - UPDATE SHIPPING METHOD
    class public func update_Shipping_method( shippingId:String , callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.updateShippingMethod)
        let user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
        let accesstoken : String
        if isUserLoggedIn{
            
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            accesstoken = (logindata.object?.access_token)!
            
        } else{
            accesstoken = GuestUserCredential.access_token
            
        }
        apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
        ]
        
        
        let bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
        
        
        apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
            
        ]
        
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "bucketId" : bucket_id,
                "shippingId" : shippingId,
                
            ]
        ]
        
        Alamofire.request(apiurl!,method: .post, parameters: parametrs,encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let result = respose.result.value as? NSDictionary else { callback(false,respose);return}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{callback(false,respose);return}
            
            callback(true,result)
        }
    }
    
    
    
    // MARK: - UPDATE QUANTITY
    class public func update_quantity_of_product( bucketItemId:String ,quantity:String, callback:@escaping (( _ success :Bool, _ results: Any?)->())){
        
        var apiurl = URLComponents(string: ApiKeys.updateQTYofProduct)
        var user_id = ""
        var bucket_id = ""
        if isUserLoggedIn{
             user_id = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            let logindata = DBManager.sharedInstance.get_loginUser_DataFromDB()[0] as LoginUserDAta
            let accesstoken = (logindata.object?.access_token)!
            
             bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
             apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
                
            ]
        }else{
             user_id = GuestUserCredential.user_id
            let accesstoken = GuestUserCredential.access_token
            
             bucket_id = DBManager.sharedInstance.getBucketId() ?? ""
            
            
            apiurl?.queryItems = [URLQueryItem(name: "access_token", value: accesstoken)
                
            ]
        }
        
        
        let parametrs : [String:Any] = [
            "form_id" : "",
            "user_id" : user_id,
            
            "fields" : [
                "bucketId" : bucket_id,
                "bucketItemId" : bucketItemId,
                "quantity" : quantity
            ]
        ]
        
        
        
        Alamofire.request(apiurl!,method: .post, parameters: parametrs,encoding: JSONEncoding.default).responseJSON { (respose) in
            guard let result = respose.result.value as? NSDictionary else { callback(false,respose);return}
            guard let request_status = result.value(forKey: "request_status") as? Int, request_status == 1 else{callback(false,respose);return}
            
            callback(true,result)
        }
    }
}
