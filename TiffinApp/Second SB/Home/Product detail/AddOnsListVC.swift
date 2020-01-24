

import UIKit

class AddOnsListVC: UIViewController {

    @IBOutlet weak var tableV : UITableView!
    @IBAction func applyAdons(_ sender : UIButton){
        if !checkMandatoryFilledIsSelectedOrNot(){
            Message.showErrorMessage(style: .center, message: "Please add mandatory feilds", title: "")
            return
        }
        delegate?.selectedAddOns(addOns: (selectedAddOnIDs))
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var ids : String! // product id
    var selectedAddOnIDs : [AddOnForAddToCart] = [AddOnForAddToCart]()
    
    public var delegate :SelectedVariationsDelegate?
    private var addOns : [AddOnsGroup] = [AddOnsGroup]()
    private let type = ["RADIO","CHECKBOX","SELECT"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableV.delegate = self
        tableV.dataSource = self
        
        self.getDataSource()
        self.setDefaultSelectedAdon()
        if let a = delegate?.alreadySelectedAdons(), a.count > 0{
            self.selectedAddOnIDs =  a
            
        }
        self.tableV.reloadData()
        
        
    }
    func setDefaultSelectedAdon(){
        // in drop down i.e. adontype = "SELECT" im displaying first adon so for that selected adon append the first adon of "selected" type
        for i in addOns{
            if i.type == type[2]{ // i.e. seleted adon type
                if let f = i.addons.first{
                    let adon = getaddedData(adon: f, adonGrpID: i.addOnGroupId)
                    selectedAddOnIDs.append(adon)
                }
            }
        }
        for j in addOns{
            if j.type == type[0]{ // i.e. seleted adon type
                if let f = j.addons.first{
                    let adon = getaddedData(adon: f, adonGrpID: j.addOnGroupId)
                    selectedAddOnIDs.append(adon)
                }
            }
        }
    }
    
    private func getDataSource(){
        guard let product = GetData().getProductFromDataBase( productId: ids) else{return}
        self.addOns = Array(product.addonsGroups)
    }
    
}

extension AddOnsListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addOns[section].type == type[2]{return 1}
        return addOns[section].addons.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return addOns.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data  = addOns[indexPath.section].addons[indexPath.row]
        var cell = UITableViewCell()
        switch addOns[indexPath.section].type{
        case type[0]:
            if data.quantitative == 1{
                cell = Bundle.main.loadNibNamed("AdOnTVC", owner: self, options: nil)?[1] as! AdOnRadioTVC
            }else{
                cell = Bundle.main.loadNibNamed("AdOnTVC", owner: self, options: nil)?.first as! AdOnRadioTVC
            }
            let adOncell = (cell as! AdOnRadioTVC )
            
            for model in selectedAddOnIDs{
                if model.addon.addOnId == data.addOnId{
                    adOncell.isselected = true
                    adOncell.setQuantity(value: CGFloat(model.quantity))
                }
            }
            adOncell.stepperValueChange = {
                (value) in
                if adOncell.isselected{
                    self.radioBtnChange(index: indexPath, quantity: (value),selection : false)
                }
                
            }
            (cell as! AdOnRadioTVC ).dataSet = data
        case type[1]:
            if data.quantitative == 1{
                cell = Bundle.main.loadNibNamed("AdOnTVC", owner: self, options: nil)?[3] as! AdOnCheckBoxTVC
            }else{
                cell = Bundle.main.loadNibNamed("AdOnTVC", owner: self, options: nil)?[2] as! AdOnCheckBoxTVC
            }
            let adOncell = (cell as! AdOnCheckBoxTVC )
            
            adOncell.dataSet = data
            for model in selectedAddOnIDs{
                if model.addon.addOnId == data.addOnId{
                    adOncell.isselected = true
                    adOncell.setQuantity(value: CGFloat(model.quantity))
                }
            }
            adOncell.stepperValueChange = {
                (value) in
                self.changeCheckBox(index: indexPath, quantity: value )
            }
            
        case type[2]:
            cell = Bundle.main.loadNibNamed("AdOnTVC", owner: self, options: nil)?[4] as! AdOnSelectTVC
            for model in selectedAddOnIDs{
                if model.addOnGroupId == addOns[indexPath.section].addOnGroupId{
                    (cell as! AdOnSelectTVC ).selectedAdon = model.addon
                    (cell as! AdOnSelectTVC ).setQuantity(value: CGFloat(model.quantity))
                }
            }
            let adOncell = (cell as! AdOnSelectTVC )
            adOncell.dataSet = (addOns[indexPath.section])
            adOncell.selectedChange = {
                (selectedAdOn) in
                self.selectAddOnChange(index: indexPath, selectedData: selectedAdOn)
            }
            break
        default:
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return addOns[section].name
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else{return}
        if let a = cell as? AdOnRadioTVC{
            if addOns[indexPath.section].addons[indexPath.row].quantitative == 1{
                self.radioBtnChange(index: indexPath, quantity: Int(a.quantity))
            }else{
                self.radioBtnChange(index: indexPath, quantity: 0)
                
            }
        }
        else if let checkbox  = cell as? AdOnCheckBoxTVC{
            checkbox.isselected = !checkbox.isselected
            
            if addOns[indexPath.section].addons[indexPath.row].quantitative == 1{
                self.changeCheckBox(index: indexPath, quantity: Int(checkbox.quantity) )
                
            }else{
                self.changeCheckBox(index: indexPath, quantity: 0 )
                
            }
            
        }
    }
    private func selectAddOnChange(index : IndexPath, selectedData : AddOnForAddToCart){
        // this add on for drop down
        // if addon of type "Select" come multiple then handdle with  "addOnGroupId"
        
        let section = index.section
        let selected_adonGrpId = addOns[section].addOnGroupId
        if addOns[section].type == self.type.last!{ // last is "Select"
            for i in 0..<selectedAddOnIDs.count{
                if selectedAddOnIDs[i].addOnGroupId == selected_adonGrpId{
                    selectedAddOnIDs.remove(at: i)
                    break
                }
            }
        }
        selectedAddOnIDs.append(selectedData)
    }
    
    private func radioBtnChange(index : IndexPath, quantity : Int, selection change : Bool  = true){
        let section = index.section
        let rows = tableV.numberOfRows(inSection: section)
        if change {
            selectedAddOnIDs.removeAll { (model) -> Bool in
                return model.addOnGroupId == addOns[section].addOnGroupId
            }
        }
        for i in 0..<rows{
            let indexpath = IndexPath(row: i, section: section)
            let data  = self.getaddedData(adon: addOns[section].addons[i], qty : quantity, adonGrpID: addOns[section].addOnGroupId)
            if change{
                
                
                if let cell = tableV.cellForRow(at: indexpath) as? AdOnRadioTVC{
                    if indexpath != index{
                        cell.isselected = false
                        
                    }
                    else{
                        
                        cell.isselected = !cell.isselected
                        selectedAddOnIDs.append(data)
                    }
                }
            }
            else{
                let filtrdata = selectedAddOnIDs.filter({$0.addOnGroupId == data.addOnGroupId})
                filtrdata.first?.quantity = quantity
            }
        }
    }
    
    
    private func changeCheckBox(index : IndexPath,quantity : Int){
        let section = index.section
        let data  = self.getaddedData(adon: addOns[section].addons[index.row], qty : quantity,adonGrpID: addOns[section].addOnGroupId)
        if let cell = tableV.cellForRow(at: index) as? AdOnCheckBoxTVC{
            if cell.isselected{
                let filterdata =  selectedAddOnIDs.filter({ (model) -> Bool in
                    return model.addon.addOnId == data.addon.addOnId
                })
                if filterdata.count == 0{
                    selectedAddOnIDs.append(data )
                }else{
                    for i in filterdata{
                        selectedAddOnIDs.removeAll { (model) -> Bool in
                            return model == i
                        }
                    }
                    selectedAddOnIDs.append(data )
                }
                
            }else{
                selectedAddOnIDs.removeAll { (model) -> Bool in
                    return model.addon.addOnId == data.addon.addOnId
                }
                
            }
        }
        
    }
    
    private func getaddedData(adon : AddOns, qty : Int = 0, adonGrpID : String)->AddOnForAddToCart{
        
        return AddOnForAddToCart(addon: adon, qty: qty, addOnGroupId: adonGrpID)
        
    }
    private func checkMandatoryFilledIsSelectedOrNot()->Bool{
        var mandatoryFIds = [String]()
        for i in addOns{
            if i.isRequired == 1{
                mandatoryFIds.append(i.addOnGroupId)
            }
        }
        if mandatoryFIds.count == 0
        {
            return true
        }
        for i in mandatoryFIds{
            let filtrd = selectedAddOnIDs.filter({return ($0.addOnGroupId == i)})
            if filtrd.count == 0{
                return false
            }
        }
        return true
    }
}






