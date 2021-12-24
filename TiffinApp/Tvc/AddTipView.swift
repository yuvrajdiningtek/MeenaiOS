
import Foundation
import UIKit
import SwiftMessages
class AddTipView : MessageView{
    
    @IBOutlet private weak var tablev : UITableView!
    @IBOutlet private weak var applyBtn : UIButton!

    @IBAction func applyTip(_ sender : UIButton){
      
        self.applyTip(taxRate: selectedTip)
        if selectedTip == "Custom Fees"{
            customTipTF.isHidden = false
        }
        else{
            customTipTF.isHidden = true
        }
        
    }
    @IBOutlet weak var customTipTF: UITextField!
    var tvds : [String] = [String]()
    var selectedTip : String = ""
    var taxID = ""
    var tipChange : ((String)->())?
    override func didMoveToWindow() {
        super.didMoveToWindow()
        applyBtn.layer.cornerRadius = 10
        self.tvds = getDataSource()
//        self.setselectedTip()
        self.setTaxId()
        tablev.delegate = self
        tablev.dataSource = self
        
    }
    func getDataSource()->[String]{
        
        customTipTF.isHidden = true
        
//        var dropdowndatasource = ["0"]
        var dropdowndatasource = [String]()

        if  DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0 {}else {return dropdowndatasource}
        let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
        
        var indexx = Int()
                           let indexRest = UserDefaults.standard.value(forKey: "indexRest") as? Int
                            indexx = indexRest ?? 0
        
        let fees = MD.object?.FEES
        
        
        guard  fees != "" else {
                 
                            return dropdowndatasource
                  
              }
            
        
        guard let fee = fees else {
            return dropdowndatasource
        }
        let f = fee.split(separator: "|").map { (sub) in
            return String(sub)
        }
        dropdowndatasource += f
        
        if MD.object?.CUSTOM_TIP == "true"{
                  dropdowndatasource.append("Custom Fees")
              }
        
        return dropdowndatasource
    }
    func applyTip(taxRate : String){
        
        if taxRate == "Custom Fees"{
            customTipTF.isHidden = false
            
            ProductsApi.update_fee_tip(taxId: taxID, taxRate: customTipTF.text ?? "0") { (success, result) in
                      if !success{
                          Message.showErrorOnTopStatusBar(message: "Oops! some error occur")
                      }else{
                        
                        UserDefaults.standard.setValue(self.customTipTF.text ?? "0", forKey: "customTip")
                          self.tipChange?(taxRate)
                          self.refreshThePreviousview()
                          Message.hideMsgView()
                      }
                  }
        }
        else{
         customTipTF.isHidden = true
        ProductsApi.update_fee_tip(taxId: taxID, taxRate: taxRate) { (success, result) in
            if !success{
                Message.showErrorOnTopStatusBar(message: "Oops! some error occur")
            }else{
                self.tipChange?(taxRate)
                self.refreshThePreviousview()
                Message.hideMsgView()
            }
            }}
    }
    func setTaxId(){
        
        if DBManager.sharedInstance.get_CartData_DataFromDB().count != 0 {
            let cartitems = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
            if cartitems.object?.fees.count != 0 {
                taxID = (cartitems.object?.fees[0].fee_id)!
            }
        }
    }
    func refreshThePreviousview(){
        print(self.parentContainerViewController()?.children)
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
}

extension AddTipView : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tvds[indexPath.row] + "%"
        cell.accessoryType = (selectedTip == tvds[indexPath.row]) ? .checkmark : .none

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.refreshThePreviousview()
        selectedTip = tvds[indexPath.row]
        if selectedTip == "Custom Fees"{
            customTipTF.isHidden = false
        }
        else{
             customTipTF.isHidden = true
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    func setselectedTip(){
        guard let cartData = DBManager.sharedInstance.get_CartData_DataFromDB().first else{return}
        guard let rate = cartData.object?.fees.first?.rate else{return}
        let ratestr = String(Int(rate))
        if tvds.contains(ratestr){
            selectedTip = ratestr
        }
    }
}
