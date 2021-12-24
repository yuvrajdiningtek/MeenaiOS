

import UIKit
import DropDown

class AdOnRadioTVC: UITableViewCell, CustomStepperDelegate {

    @IBOutlet weak private var radiobtn : RadioButton!
    @IBOutlet weak private var stepper : CustomStepper?
    @IBOutlet weak private var lbl : UILabel!

    var dataSet : AddOns?{
        didSet{
            configure()
        }
    }
    var isselected = false{
        didSet{
            radiobtn.isSelected = isselected
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper?.delegate = self
    }
    var quantity : CGFloat {
        if stepper == nil{return 1}
        return stepper!.currentValue
    }
    var stepperValueChange : ((Int)->())?
    func configure(){
        if dataSet == nil, lbl == nil{return}
        let price = dataSet?.unitPrice
        let priceString:String = String(format:"%.1f", price ?? 0.0)
        if priceString == "0.0"{

        
        lbl.text = dataSet?.name
        }
        else{
            lbl.text = dataSet!.name + "  ($\(priceString))"
        }
    }
    func setQuantity(value : CGFloat){
        stepper?.value = value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    internal func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        stepperValueChange?(Int(value))
    }
}
class AdOnCheckBoxTVC: UITableViewCell , CustomStepperDelegate{
    
    
    @IBOutlet weak private var checkBox : CheckBox!
    @IBOutlet weak private var stepper : CustomStepper?
    @IBOutlet weak private var lbl : UILabel!
    
    var dataSet : AddOns?{
        didSet{
            configure()
        }
    }
    var isselected = false{
        didSet{
            checkBox.isChecked = isselected
        }
    }
    var stepperValueChange : ((Int)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper?.delegate = self
    }
    var quantity : CGFloat {
        return stepper?.currentValue ?? 1
    }
    func setQuantity(value : CGFloat){
        stepper?.value = value
    }
    private func configure(){
        if dataSet == nil, lbl == nil{return}
        
        
        let price = dataSet?.unitPrice
        let priceString:String = String(format:"%.1f", price ?? 0)
        if priceString == "0.0"{
            
            
            lbl.text = dataSet?.name
        }
        else{
            lbl.text = dataSet!.name + "  ($\(priceString))"
        }
        
       // lbl.text = dataSet?.name
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    internal func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        stepperValueChange?(Int(value))
    }
}
class AdOnSelectTVC: UITableViewCell , CustomStepperDelegate{
    
    
    @IBOutlet weak private var dropDownLbl : UILabel!
    @IBOutlet weak private var stepper : CustomStepper?
    @IBOutlet weak private var stepperContainView : UIView!

    private var dropDown : DropDown = DropDown()
    public var selectedChange : ((AddOnForAddToCart  )->())?
    @IBAction func showDropDown(){
        
        dropDown.show()
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stepper?.delegate = self
    }
    func setQuantity(value : CGFloat){
        if stepper == nil{return}
        stepper?.value = value
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    private var addOnsArr : [AddOns]?{
        didSet{
            setDropDown()
        }
    }
    var dataSet : AddOnsGroup?{
        didSet{
            if let a = dataSet?.addons{
                self.addOnsArr = Array(a)
            }
        }
    }
    var selectedAdon : AddOns?
    var tableV : UITableView?
    private func setDropDown(){
        
        let ds = self.dropDownDataSource()

        dropDown.anchorView = dropDownLbl
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.dataSource = ds
      
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            let d = self.addOnsArr![index]
            self.dropDownLbl.text = item
            if d.taxable == 1{
                let cur = cleanDollars(String(d.unitPrice))
                self.dropDownLbl.text?.append("(+ \(cur))")
            }
            self.selectedChange?(self.getSelectedDS(index: index))
            self.stepperContainView.isHidden = (d.quantitative == 0)
//            self.stepperContainView.isHidden = false
//            self.changeHeight()

        }
        
        let price = selectedAdon?.unitPrice
        let priceString:String = String(format:"%.1f", price ?? 0)
        if priceString == "0.0"{
            
            
            dropDownLbl.text = selectedAdon?.name ?? ds.first
        }
        else{
            dropDownLbl.text = selectedAdon!.name + "  ($\(priceString))"
        }
        
//        dropDownLbl.text = selectedAdon?.name ?? ds.first
        self.stepperContainView.isHidden = (self.addOnsArr?.first?.quantitative == 0)
    }
    private func dropDownDataSource()->[String]{
        if dataSet == nil{return [String]()}
        var arr = [String]()
        for i in addOnsArr!{
            arr.append(i.name)
        }
        return arr
    }
    private func getSelectedDS(index : Int)->AddOnForAddToCart{
        let adon = addOnsArr![index]
        let qty = Int(stepper?.currentValue ?? 0.0)
        return AddOnForAddToCart(addon: adon, qty: qty, addOnGroupId: dataSet?.addOnGroupId ?? "")
    }
    internal func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        self.selectedChange?(self.getSelectedDS(index: dropDown.indexForSelectedRow ?? 0 ))
    }
    
    func changeHeight(){
        self.tableV?.beginUpdates()
        self.tableV?.endUpdates()
    }
    
}
