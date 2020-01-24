
import Foundation
import Stripe

class Global: NSObject{
    func setStripePublishKey(){
        if  DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0 {}else {return }
        let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
        let stripePublish_key = MD.object?.STRIPE_PUBLISHABLE_KEY
        print(stripePublish_key as Any)
        STPPaymentConfiguration.shared().publishableKey = stripePublish_key ?? ""
        Stripe.setDefaultPublishableKey(stripePublish_key ?? "")
    }
    func getOrderIdFromPlaceOrderResult(data : NSDictionary?)->String?{
        guard let  dict = data else{return nil}
        guard let  obj = dict.value(forKey: "object") as? NSDictionary else{return nil}
        guard let  orderId = obj.value(forKey: "orderId") as? String else{return nil}
        return orderId
    
}
func getAdOnString(adOns : [AdOnObjectModel])->NSMutableAttributedString?{
    if adOns.count == 0{return nil}
     let heading = NSMutableAttributedString(string: "", attributes: attributesHeading())
  // let heading = NSMutableAttributedString(string: "AddOns: \n", attributes: attributesHeading())
    for i in adOns{
        let subH = NSAttributedString(string: i.addon_full_name, attributes: attributesSubHeading())
       // let qty = NSAttributedString(string: "   x \(i.qty) ", attributes: attributesSubHeading())
           let qty = NSAttributedString(string: "", attributes: attributesSubHeading())
        var unitPrice = NSAttributedString(string: "  :  $\(i.unit_price) \n", attributes: attributesSubHeading())
        let unitp = i.unit_price
        if unitp == 0.0 {
             unitPrice = NSAttributedString(string: "\n", attributes: attributesSubHeading())
             // unitPrice = NSAttributedString(string: "  :  \(i.unit_price) \n", attributes: attributesSubHeading())
        }
        else {
        
          unitPrice = NSAttributedString(string: "  :  $\(i.unit_price) \n", attributes: attributesSubHeading())
        }
        
        heading.append(subH)
        heading.append(qty)
        heading.append(unitPrice)
    }
    return heading
}
func attributesHeading()->[NSAttributedString.Key: Any]{
    let font = UIFont(name: "GlacialIndifference-Bold", size: 14)
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: UIColor.black,
    ]
    return attributes
}
func attributesSubHeading()->[NSAttributedString.Key: Any]{
    let font = UIFont(name: "GlacialIndifference-Regular", size: 12)
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: UIColor.darkGray,
    ]
    return attributes
}
func attributesDetail()->[NSAttributedString.Key: Any]{
    let font = UIFont(name: "GlacialIndifference-Regular", size: 14)
    let attributes: [NSAttributedString.Key: Any] = [
        .font: font,
        .foregroundColor: UIColor.darkGray,
    ]
    return attributes
}
}
class GlobalVariables {
    static let placeholderImg = UIImage(named: "placeholder img")!
}
class AddOnForAddToCart : NSObject{
    var addon : AddOns
    var quantity : Int
    var addOnGroupId : String
    init(addon : AddOns, qty : Int = 0, addOnGroupId : String) {
        self.addon = addon
        self.quantity = qty
        self.addOnGroupId = addOnGroupId
    }
    static func ==(lhs : AddOnForAddToCart,rhs : AddOnForAddToCart) -> Bool{
        if lhs.addOnGroupId == rhs.addOnGroupId{
            if lhs.addon.addOnId == rhs.addon.addOnId {
                return true
            }
        }
        
        return false
    }
}
