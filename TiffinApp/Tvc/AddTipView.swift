
import Foundation
import UIKit
import SwiftMessages
class AddTipView : MessageView{
    
    @IBOutlet private weak var tablev : UITableView!
    @IBOutlet private weak var applyBtn : UIButton!

    @IBAction func applyTip(_ sender : UIButton){
        self.applyTip(taxRate: selectedTip)
    }
    var tvds : [String] = [String]()
    var selectedTip : String = ""
    var taxID = ""
    var tipChange : ((String)->())?
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.tvds = getDataSource()
//        self.setselectedTip()
        self.setTaxId()
        tablev.delegate = self
        tablev.dataSource = self
        
    }
    func getDataSource()->[String]{
        var dropdowndatasource = ["0"]
        if  DBManager.sharedInstance.get_merchntId_DataFromDB().count != 0 {}else {return dropdowndatasource}
        let MD  = DBManager.sharedInstance.get_merchntId_DataFromDB()[0] as MerchantID
        let fees = MD.object?.FEES
        
        guard let fee = fees else {
            return dropdowndatasource
        }
        let f = fee.split(separator: "|").map { (sub) in
            return String(sub)
        }
        dropdowndatasource += f
        return dropdowndatasource
    }
    func applyTip(taxRate : String){
        
        ProductsApi.update_fee_tip(taxId: taxID, taxRate: taxRate) { (success, result) in
            if !success{
                Message.showErrorOnTopStatusBar(message: "Oops! some error occur")
            }else{
                self.tipChange?(taxRate)
                self.refreshThePreviousview()
                Message.hideMsgView()
            }
        }
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
