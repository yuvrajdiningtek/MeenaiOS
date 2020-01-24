
import UIKit
import Foundation
import DropDown
import SCLAlertView
class TipHandle: NSObject {
    
    var dropDownBtn : UIButton!
    var priceLbl : UILabel!
    var cartObj : ObjectCartData!
    
    private var dataSource : [CouponsModel] = [CouponsModel]()
    private var dropDown : DropDown = DropDown()
    private var dropdowndatasource = [String](){
        didSet{
            self.setDropDown()
        }
        
    }
    init(dropdownanchorBtn : UIButton, priceLbl : UILabel,cartdata : ObjectCartData) {
        super.init()
        
        self.dropDownBtn = dropdownanchorBtn
        self.priceLbl = priceLbl
        self.cartObj = cartdata
        commonInit()
    }
    
    func commonInit(){
        
        let fee = cartObj.fees
        for i in fee{
            let txt = String(i.rate) + "%"
            dropDownBtn.setTitle(txt, for: .normal)
            priceLbl.text = cleanDollars(String(describing: i.amount))
        }
        self.setDropDown()
    }
    
    func showDropDown(){
        
        dropDown.show()
        
    }
    func setDropDown(){
        
        dropDown.direction = .any
        dropDown.dataSource = getDropDwonDatSource()
        dropDown.anchorView = dropDownBtn
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            var rate = item
            rate.removeLast()
            self.update_fee_tip(taxRate: rate, completion: {(succ) in
                if succ{
                    self.dropDownBtn.setTitle("\(item)", for: .normal)
                    var amountwithperce =  item
                    amountwithperce.removeLast()
                    var amount = self.cartObj.sub_total ?? 0.0
                    
                    amount = (amount * (Double(amountwithperce) ?? 0.0))/100
                    self.priceLbl.text  = cleanDollars("\(amount)")
                }else{
                    Message.showErrorOnTopStatusBar(message: "failed to update tip")
                }
            })
        }
        
    }
    
    
    
    func getDropDwonDatSource()->[String]{
         var dropdowndatasource = ["0%"]
        if  DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0 {}else {return dropdowndatasource}
        let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
        let fees = MD.object?.FEES
       
        guard let fee = fees else {
            return dropdowndatasource
        }
        let f = fee.split(separator: "|").map { (sub) in
            return String(sub)+"%"
        }
        dropdowndatasource += f
        return dropdowndatasource
    }
    
    
    private func update_fee_tip(taxRate: String, completion : ((Bool)->())?){
        
        
        var taxID = ""
        if DBManager.sharedInstance.get_CartData_DataFromDB().count != 0 {
            let cartitems = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
            if cartitems.object?.fees.count != 0 {
                taxID = (cartitems.object?.fees[0].fee_id)!
            }
        }
        
        
        
        ProductsApi.update_fee_tip(taxId: taxID, taxRate: taxRate) { (success, result) in
            if !success{
                SCLAlertView().showError("some error occured")
                completion?(false)
            }else{
                completion?(true)
            }
        }
    }
    
}

