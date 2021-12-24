

import UIKit
import DropDown


class ProductDetailCVC : UICollectionViewCell, CustomStepperDelegate {
    func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        let pr = (price ?? 0) * Float(value)
        let title = "ADD TO CART (\(cleanDollars(String(pr))))"
        //        addTocartBtn.setTitle((title), for: .normal)
        price_lbl_onaddtocart_btn.text = "(\(cleanDollars(String(pr))))"
        
    }
    struct AddTocartObject{
        var productid : String = ""
        var variationId : String = ""
        var quantity : String = ""
    }
    
    // MARK: - IBOUTLETS
    @IBOutlet weak private var price_lbl_onaddtocart_btn: UILabel!
    
    @IBOutlet weak private  var product_imgV: UIImageView!
    @IBOutlet weak private  var product_imgVNew: UIImageView!

    @IBOutlet weak private var productName_lbl: UILabel!
    @IBOutlet weak private var productDescription_lbl: UILabel!
    @IBOutlet weak private var lowerView: UIView!
    
    @IBOutlet weak private var varirtyLbl: UILabel!
    @IBOutlet weak private var mandatoryLbl: UILabel!
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    //    @IBOutlet weak private var prizeHeadingLbl: UILabel!
    
    @IBOutlet weak private var productPrize_lbl: UILabel!
    @IBOutlet weak private var prizevalueLbl: UILabel!
    
    @IBOutlet  private var addOnBtns: [UIButton]!
    @IBOutlet weak private var addOnLbl: UITextView!
    @IBOutlet weak var cookingInstructionTv: UITextView!
    @IBOutlet weak var cookingInstView: UIView!
    
    @IBOutlet weak var addTocartBtn: UIButton!{
        didSet{
                        addTocartBtn.layer.cornerRadius = 10
        }
    }
    
    @IBOutlet weak private var stepperView: CustomStepper!
    
    
    @IBOutlet weak private var dropDwnImgBtn: UIButton!
    @IBOutlet weak private var varityBtn: UIButton!
    //    var prdViewModel : ProductsDetailViewModel
    
    @IBAction private  func varirtyOptionBtn(_ sender: Any) {
        //        variationDropDown.show()
        if let varietyOptionObj = varietyOptionObj{
            varietyOptionObj()
        }
        
        let vc = secondSBVC("VariationsVC") as! VariationsVC
        vc.productIDis = product!.productId
        vc.delegate = self
        viewController.present(vc, animated: true, completion: nil)
    }
    @IBAction private  func addOns(_ sender: Any) {
        let vc = secondSBVC("AddOnsListVC") as! AddOnsListVC
        vc.ids = product!.productId
        vc.delegate = self
        vc.modalPresentationStyle = .formSheet

        viewController.present(vc, animated: true, completion: nil)
    }
    
    @IBAction private  func addtoCart(_ sender: Any) {
        if let btnAction = self.doneobj
        {
            btnAction()
        }
        addtoCartObj.quantity = String(Int(stepperView.currentValue))
        self.addTocart(obj: addtoCartObj)
    }
    
    private  var price : Float = 0.0{
        didSet{
            let pr = (price)*Float(stepperView.currentValue)
            //            let title = "ADD TO CART (\(cleanDollars(String(pr))))"
            //            addTocartBtn.setTitle((title), for: .normal)
            price_lbl_onaddtocart_btn.text = "(\(cleanDollars(String(pr))))"
        }
    }
    public var  merchantId : String!
    var doneobj : (() -> Void)? = nil
    var done_variety_Types : (String,String,String)? = nil
    
    var varietyOptionObj : (() -> Void)? = nil
    var id : String = ""{
        didSet{
            self.product_imgV.hero.id = "Prod\(id)img"
            self.product_imgVNew.hero.id = "Prod\(id)img"

            self.lowerView.hero.id = "Prod\(id)btmview"
        }
    }
    var product : Products?{
        didSet{
            self.setUi(obj: product)
        }
    }
    var selectedAdons : [AddOnForAddToCart] = [AddOnForAddToCart]()
    var viewController : UIViewController!
    var addtoCartObj : AddTocartObject!
    private var isAdOnIsMandatory : Bool = false{
        didSet{
            mandatoryLbl.isHidden = !isAdOnIsMandatory
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        product_imgVNew.layer.cornerRadius = 10
        product_imgVNew.clipsToBounds = true
        imgHeight.constant = 0
//        stepperView.layer.cornerRadius = 7
//        stepperView.layer.borderColor = #colorLiteral(red: 0.838742435, green: 0.7268220782, blue: 0.01490934193, alpha: 1)
//        stepperView.layer.borderWidth = 1
        stepperView.clipsToBounds = true
        cookingInstructionTv.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cookingInstructionTv.layer.borderWidth = 1
        cookingInstructionTv.layer.cornerRadius = 6
        stepperView.delegate = self
        addtoCartObj = AddTocartObject(productid: "", variationId: "", quantity: "")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    func resetData(){
        self.varirtyLbl.text = ""
        
    }
}

extension ProductDetailCVC {
    
    func setUi(obj : Products?){
        guard let product = obj  else {
            return
        }
        if product.image.count > 0{
            let url = URL(string: product.image[0])
              product_imgVNew.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder img"))
        }
//        product_imgVNew.image = #imageLiteral(resourceName: "backgrnd_@x2")
        if product.enabledUserInstructions == true{
            cookingInstView.isHidden = false
        }
        else{
            cookingInstView.isHidden = true
        }
        
        productName_lbl.text = product.name
        productDescription_lbl.text = product.descriptions
        productPrize_lbl.text = cleanDollars(String(product.price))
        price = Float(product.price)
        addtoCartObj.productid = product.productId
        self.setstepper(product: product)
        self.setUiofVariance(product: product)
        self.setUIForAddOn(product: product)
    }
    private func setUIForAddOn(product :  Products){
        let hide = (product.addonsGroups.count == 0)
        for i in addOnBtns{
            i.isHidden = hide
        }
        addOnLbl.isHidden = hide
        mandatoryLbl.isHidden = true
        if hide{return}
        for i in product.addonsGroups{
            if i.isRequired == 1{
                print("product name ",product.name,i.addOnGroupId)
                
                self.isAdOnIsMandatory = true
                break
            }
        }
    }
    func setUiofVariance(product :  Products){
        
        guard let dynamicCat = product.varianceAttribute?.Group?.Category else{
            //            prizeHeadingLbl.isHidden = true
            varityBtn.isHidden = true
            prizevalueLbl.isHidden = true
            dropDwnImgBtn.isHidden = true
            
            return
            
        }
        if dynamicCat.count == 0 {return }
        
        guard let variations = product.variations.first else{
            return
        }
        let variationID = variations.productVariationId
        //        let title = variations.varianceAttribute?.Group?.Category.first?.value.first ?? ""
        let value = String(variations.price)
        //        let key = variations.varianceAttribute?.Group?.Category.first?.category_key ?? ""
        //        self.varityBtn.setTitle(title, for: .normal)
        self.varityBtn.isHidden = false
        self.varirtyLbl.text = setFirstValueOfVariance(product: product)
        self.prizevalueLbl.text = cleanDollars(value)
        self.addtoCartObj.variationId = variationID
        self.price = Float(variations.price)
        
        
    }
    func setFirstValueOfVariance(product : Products)->String{
        var str = ""
        if let i = product.variations.first{
            var d : (String,String,String,Double) = ("","","",0.0)
            guard let varianceAttribute = i.varianceAttribute else{return str}
            guard let Group = varianceAttribute.Group else{return str}
            let cat = Group.Category
            var ds = [(String,String,String,Double)]()
            for j in cat{
                let key = j.category_key
                var value = j.value.first ?? ""
                // assuming only one value in array
                for i in 0..<j.value.count{
                    if i > 0 {
                        let v = j.value[i]
                        value.append(" ,"+v)
                    }
                }
                d = (i.productVariationId,key,value,i.price)
                ds.append(d)
                str.append(d.1 + " : " + d.2)
                str.append("\n")
            }
        }
        return str
    }
    func setstepper(product :  Products){
        let (min,max) = ProductsDetailViewModel(vc : self.viewController).get_stepper_min_max_value()
        stepperView.minValue = CGFloat(min)
        stepperView.maxValue = CGFloat(max)
        stepperView.value = 1
        
        if product.variations.count != 0{
            var p = [Double]()
            for variation in product.variations{
                p.append(variation.price)
            }
            
            let min = cleanDollars(String(describing: p.min() ?? 0.0))
            let max = cleanDollars(String(describing: p.max() ?? 0.0))
            productPrize_lbl.text = min +  " - " +  max
        }
    }
}


extension ProductDetailCVC: SelectedVariationsDelegate{
    func alreadySelectedAdons() -> [AddOnForAddToCart]? {
        return self.selectedAdons
    }
    
    func selectedAddOns(addOns: [AddOnForAddToCart]) {
        self.selectedAdons = addOns
        func attributedStringForHeader(str : String)->NSAttributedString{
            let att : [NSAttributedString.Key:Any] = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14),
                                                      NSAttributedString.Key.foregroundColor : UIColor.black
            ]
            let str = NSAttributedString(string: str, attributes: att)
            return str
        }
        func attributedStringForSubHeading(str : String)->NSAttributedString{
            let att : [NSAttributedString.Key:Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14) ,
                                                      NSAttributedString.Key.foregroundColor : UIColor.black
            ]
            let str = NSAttributedString(string: str, attributes: att)
            return str
        }
        func addLineSpacing()->NSMutableParagraphStyle{
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 7
            return paragraphStyle
        }
        let str = NSMutableAttributedString(string: "")
        for i in addOns{
            let titleStr = self.getAdOnTitle(adOnGroupID: i.addOnGroupId)
            let name =  attributedStringForHeader(str : i.addon.name)
            
            str.append(attributedStringForSubHeading(str: "\n"))
            str.append(attributedStringForHeader(str : (titleStr + "-")) )
            str.append(name)
            if i.quantity != 0{
                str.append(attributedStringForHeader(str :  " x " + String(i.quantity)  ) )
            }
            
        }
        str.addAttribute(.paragraphStyle, value: addLineSpacing(), range: NSRange(location: 0, length: str.length) )
        self.addOnLbl.attributedText = str
    }
    
    private func getAdOnTitle(adOnGroupID : String)->String{
        guard let adons = self.product?.addonsGroups else{return ""}
        let filteredAdons =  adons.filter("addOnGroupId == %a",adOnGroupID)
        guard let neededAdon = filteredAdons.first else{return ""}
        return neededAdon.name
    }
    
    func selectedvariation(variationId: String, variationKey: String, variationname: String, variationPrice: Double) {
        
        self.varirtyLbl.text = variationname
        //        self.varityBtn.setTitle(variationname, for: .normal)
        let price = cleanDollars(String(variationPrice))
        prizevalueLbl.text = price
        self.addtoCartObj.variationId = variationId
        self.price = Float(variationPrice)
    }
    
    func addTocart(obj : AddTocartObject){
        if !validateAdOnData(){
            Message.showErrorMessage(style: .bottom, message: "Please add mandatory fields", title: "")
            
            return}
        self.addTocartBtn.isEnabled = false
        ProductsDetailViewModel(vc: self.viewController).AddToCart(cookingInstruction: cookingInstructionTv.text, productid: obj.productid, productVariationId: obj.variationId, quantity: obj.quantity, addons: selectedAdons) { (succ, msg) in
            self.addTocartBtn.isEnabled = true
            let activityIndicator = loader(at: self.viewController.view, active: .circleStrokeSpin)
            self.viewController.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            hideactivityIndicator(activityIndicator: activityIndicator)
            
            if succ{
                Message.showSuccessmsg(style: .bottom, message: "Added successfully")
                NotificationCenter.default.post(name: Notification.Name("MoveToHome"), object: true, userInfo: nil)

                self.viewController.dismiss(animated: true)
                //MyCartVC
                let vc = secondSBVC("PlaceOrderVC")//PlaceOrderVC
                self.viewController.navigationController?.pushViewController(vc, animated: true)
                
            }
            else{
                Message.showErrorMessage(style: .bottom, message: msg, title: "error")
                
            }
        }
        
    }
    private func validateAdOnData()->Bool{
        if isAdOnIsMandatory {
            return !(selectedAdons.count  == 0)
        }
        return true
    }
}
