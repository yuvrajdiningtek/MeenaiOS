import UIKit
import Foundation
import SCLAlertView
import NVActivityIndicatorView
class ProductsDetailViewModel{
    
    init(vc : UIViewController){
        self.vc = vc
    }
    func stepperValuechng(){
        
    }
    func drop_down(){
        
    }
    func showLoader(){
        
        
         activityIndicator = loader(at: vc.view, active: .circleStrokeSpin)
        vc.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        
    }
    func hideLoader(){
        hideactivityIndicator(activityIndicator: activityIndicator)
    }
    var activityIndicator : NVActivityIndicatorView!
    var vc : UIViewController!
    func    AddToCart(cookingInstruction:String,productid:String,productVariationId:String,quantity:String,addons : [AddOnForAddToCart]?, completion : @escaping (Bool,String)->()){
        
        
        addToCart_api(cookingInstruction: cookingInstruction, productid: productid, productVariationId: productVariationId, quantity: quantity, addons: addons, completion: { (success,msg) in
            
            completion(success,msg)

        })

    }
   
    func get_stepper_min_max_value()->(Int,Int){ // (min,max)
        if let merchntdetail = DBManager.sharedInstance.get_merchntdetail_DataFromDB().first as? MerchantDetail{
            let cart_max_item_qty = merchntdetail.object?.cart_max_item_qty ?? 0
            let cart_min_item_qty = merchntdetail.object?.cart_min_item_qty ?? 10
            
            return (Int(cart_min_item_qty),Int(cart_max_item_qty))
        }
        return ( 0,10)
    }
    
    private func addToCart_api(cookingInstruction:String,productid:String,productVariationId:String,quantity:String,addons : [AddOnForAddToCart]?, completion:@escaping (Bool,String)->() ){
        var userid =  ""
        
        if isUserLoggedIn{
            userid = UserDefaults.standard.value(forKey: usercredential().email) as? String ?? ""
            
        }
        else{
            userid = GuestUserCredential.user_id
        }
        var adonDict : [[String:Any]] = [[String:Any]]()
        if addons != nil{
            for i in addons!{
                let dic : [String:Any] = ["addOnId":i.addon.addOnId,
                                          "quantity":i.quantity]
                adonDict.append(dic)
            }
        }
        var formattedDate = String()
        let selectedDate = UserDefaults.standard.value(forKey: "selectedDate") as? String ?? ""
        let selectedTime = UserDefaults.standard.value(forKey: "selectedTime") as? String ?? ""
        if selectedDate != ""{
            formattedDate = selectedDate.replacingOccurrences(of: "/", with: "-", options: .literal, range: nil)
        }
        else{
            formattedDate = ""
        }
        var parametrs = [String:Any]()
        let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
        if ENABLE_ORDER_AHEAD == true{
            parametrs  = [
               "form_id" : "",
               "user_id" : userid,
               
               "fields" : [
                   "bucketId" : DBManager.sharedInstance.getBucketId(),
                   "productId" : productid,
                   "productVariationId" : productVariationId,
                   "quantity" : quantity,
                   "addOns":adonDict,
                   "cookingInstruction":cookingInstruction,
                   "orderDate" : formattedDate,
                   "orderTime" : selectedTime,
               ]
           ]
        }
        else{
         parametrs  = [
            "form_id" : "",
            "user_id" : userid,
            
            "fields" : [
                "bucketId" : DBManager.sharedInstance.getBucketId(),
                "productId" : productid,
                "productVariationId" : productVariationId,
                "quantity" : quantity,
                "addOns":adonDict,
                "cookingInstruction":cookingInstruction//,
//                "orderDate" : formattedDate,
//                "orderTime" : selectedTime,
            ]
        ]
        }
        print(parametrs)
         showLoader()
        ProductsApi.addToCart(parameters: parametrs) { (success, result) in
            self.hideLoader()
            print("Result \(result)")
            var msg = "Oops! Some Error Occur"
            if success{
                guard let rst = result as? NSDictionary else{
                    completion(false,msg)
                    return
                }
                guard  let request_status = rst.value(forKey: "request_status") as? Int else{
                    completion(false,msg)
                    return
                }
                if request_status == 1{
                    // success product added to cart

                    completion(true,"Success")
                }else{
                    
                    print(rst)
                    // fail
                    // show alert
                    if let object = rst.value(forKey: "object") as? NSDictionary{
                        if let error = object.value(forKey: "error") as? String{
                            msg = error
                        }
                    }
                    print(msg)
                    completion(false,msg)
                }
            }
            else{
                guard let rst = result as? NSDictionary else{
                    completion(false,msg)
                    return
                }
                if let object = rst.value(forKey: "object") as? NSDictionary{
                    if let error = object.value(forKey: "error") as? String{
                        msg = error
                    }
                }
                completion(false,msg)
                return
            }
        }
    }
    
}

