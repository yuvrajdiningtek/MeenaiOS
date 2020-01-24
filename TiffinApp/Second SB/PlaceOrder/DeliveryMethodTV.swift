

import Foundation
import UIKit
import SCLAlertView


class DeliveryMethodTV : UITableView , UITableViewDelegate, UITableViewDataSource{
    var dataset : ObjectCartData?{
        didSet{
            if dataset != nil{
                tvdataSource = setDataSource(data: dataset!)
            }
        }
    }
    var vc : UIViewController{
        return self.viewContainingController()!
    }
    var selectedid : String?{
        didSet{
            if let sid = tvdataSource.first?.2, selectedid != nil{
                if sid == selectedid!{
                    didChangeValueOfSelecteId?(true )
                    return
                }
            }
            didChangeValueOfSelecteId?(false )
        }
    }
    var numberOfRows : Int{
        return tvdataSource.count
    }
    var didChangeValueOfSelecteId : ((_ isPickup : Bool)->())?
    
    var pickUpid : String = ""
     var userselected_shippingMethod : String {
        
        return selectedid ?? dataset?.shippment_method ?? ""
    }
    private var tvdataSource = [(String,String,String)](){ // (key, value, shippimgId)
        didSet{
            self.reloadData()
        }
    }
    func setDataSource (data : ObjectCartData)->[(String,String,String)]{
        
        var ds = [(String,String,String)]()
        var shop_address = ""
        if  DBManager.sharedInstance.get_merchntdetail_DataFromDB().count != 0 {
            let MD  = DBManager.sharedInstance.get_merchntdetail_DataFromDB()[0] as MerchantDetail
            shop_address = (MD.object?.description_point) ?? ""
        }else { }
        
       // var key = "Pickup at Restaurant \n \(shop_address)"
        var key = "Pickup at the Restaurant - Free"
        var value = cleanDollars("0.0")
        var shippimgId = data.available_pickup_methods
        self.pickUpid = shippimgId
        
        ds.append((key, value, shippimgId))
        
        for i in data.available_delivery_methods{
            key = i.name
            value = cleanDollars(String(i.cost))
            shippimgId = i.id
//            if !(key == "FREE_SHIPPING" || key == "INTERNATIONAL_FLAT_RATE"){
//                ds.append((key, value, shippimgId))
//            }
            ds.append((key, value, shippimgId))

        }
        return ds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvdataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeliveryMethod_TVC
        
        cell.dataSet = tvdataSource[indexPath.row]
        cell.radioBtn.isSelected = (cell.shippingId == userselected_shippingMethod)
        if selectedid != nil{
            cell.radioBtn.isSelected = (cell.shippingId == selectedid!)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updateDeliveryMethod(shippingId: tvdataSource[indexPath.row].2)
    }
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commoninit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commoninit()
    }
    func commoninit(){
        self.delegate = self
        self.dataSource = self
    }
    
    func updateDeliveryMethod(shippingId : String){
        
        let activityIndicator = loader(at: self.vc.view, active: .circleStrokeSpin)
        self.vc.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        SubmissionAPIs.update_Shipping_method(shippingId: shippingId, callback: { (success, result) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
//            UserDefaults.standard.set(shippingID, forKey: userdefaultKeys().selected_delivery_method_ID)
//            UserDefaults.standard.set(cost, forKey: userdefaultKeys().selected_delivery_method_cost)
            if !success{
                SCLAlertView().showNotice("error occur")
            }else{
                self.selectedid = shippingId
            }
            self.reloadData()
        })
        
    }
    
}
