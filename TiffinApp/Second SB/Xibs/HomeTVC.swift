
import UIKit
import DropDown
import CreditCardForm
import Stripe

class HomeTVC: UITableViewCell {

    @IBOutlet weak var homeCV: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

// MARK:- HomeProductTVC
class HomeProductTVC: UITableViewCell {
    
    @IBOutlet weak var product_imgV: UIImageView!
    @IBOutlet weak var productName_lbl: UILabel!
    @IBOutlet weak var productPrice_lbl: UILabel!
    @IBOutlet weak var description_lbl: UILabel!
    @IBOutlet weak var shadow_v: ShadowView!
    @IBOutlet weak var bottmview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        product_imgV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        shadow_v.layer.cornerRadius = 5
        shadow_v.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        
        bottmview.clipsToBounds = true
        bottmview.layer.cornerRadius = 10
        bottmview.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        
    }
    var dataSet : Products?
    var id : String = ""{
        didSet{
            self.product_imgV.hero.id = "Prod\(id)img"
            //            self.bottmview.hero.id = "Prod\(id)btmview"
            
        }
    }
    func restrauntStatus(_ open : Bool){
        let opencolor = UIColor.MyTheme.marooncolor
        let closecolor = UIColor.lightGray
        
        productName_lbl.textColor = open ? opencolor : closecolor
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        configureCell()
    }
    func configureCell(){
        guard let product = dataSet else{return}
        
        
        if product.image.count > 0{
            let url = URL(string: product.image[0])
            product_imgV.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder img"))
        }
        productName_lbl.text = product.name
        description_lbl.text = product.descriptions
        productPrice_lbl.text = cleanDollars(String(product.price))
        if product.variations.count != 0{
            var p = [Double]()
            for variation in product.variations{
                p.append(variation.price)
            }
            
            let min = cleanDollars(String(describing: p.min() ?? 0.0))
            let max = cleanDollars(String(describing: p.max() ?? 0.0))
            productPrice_lbl.text = min +  " - " +  max
        }
        
    }
}

// MARK:- CartTVC
class CartTVC:UITableViewCell{
    
    @IBOutlet weak var itemName_Lbl: UILabel!
    @IBOutlet weak var quantity_lbl: UILabel!
    @IBOutlet weak var shipmentPriceLbl: UILabel!
    @IBOutlet weak var unitPrizeLbl: UILabel!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var variation_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class CartExtraRowTVC : UITableViewCell{
    
    @IBOutlet weak var qty_Lbl: UILabel!
    @IBOutlet weak var steppr: UIStepper!
    @IBOutlet weak var dltt_btn: UIButton!
    @IBOutlet weak var done_btn: UIButton!
    
    var yourobj : (() -> Void)? = nil
    var doneobj : (() -> Void)? = nil
    
    @IBAction func stepper(_ sender: Any) {
        if let btnAction = self.yourobj
        {
            btnAction()
        }
    }
    @IBAction func done_btn(_ sender: Any) {
        if let btnAction = self.doneobj
        {
            btnAction()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class CartThirdTVC:UITableViewCell{
    
    @IBOutlet weak var itemName_Lbl: UILabel!
    @IBOutlet weak var variation_lbl: UILabel!
    @IBOutlet weak var adOnLbl: UILabel!
    @IBOutlet weak var quantity_lbl: UILabel!
    @IBOutlet weak var unitPrizeLbl: UILabel!
    @IBOutlet weak var single_item_price: UILabel!
    @IBOutlet weak var adOnLbl2: UILabel!
    
    @IBOutlet weak var custom_stepperV: CustomStepper!
    
    @IBOutlet weak var Spicy_heading_lbl: UILabel!
    
    var obj : (() -> Void)? = nil
    var deleteDropDown = DropDown()
    var product_id : String? = nil{
        didSet{
            Configure()
        }
    }
    
    @IBOutlet weak var option_btn: UIButton!
    @IBAction func opt_btn(_ sender: Any) {
        if let btnAction = self.obj
        {
            btnAction()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    private func setAddOnsLbl (){
        
        guard let adons = getItem()?.addons else{
            return
        }
        adOnLbl.attributedText = Global().getAdOnString(adOns: Array(adons))
        print(adOnLbl.attributedText)
    }
    func Configure(){
        guard let data = getItem() else{
            return
        }
        self.itemName_Lbl.text = data.itemName
        self.quantity_lbl.text = String(data.qty)
        let a = data.qty
        let p = data.unit_price * a
        let pr = cleanDollars(String(p))
        unitPrizeLbl.text = "\(pr)"
        single_item_price.text = cleanDollars("\((data.unit_price))")
        self.setAddOnsLbl()
        variation_lbl.text = ""
        Spicy_heading_lbl.text = ""
        
        
        if data.variations_attrubutes.count != 0{
            
            for i in 0...data.variations_attrubutes.count-1 {
                let key = data.variations_attrubutes[i].category_key
                let values = data.variations_attrubutes[i].value
                if values.count != 0{
                    Spicy_heading_lbl.text?.append(key+"\n")
                    variation_lbl.text?.append(values[0]+"\n")
                }
            }
            variation_lbl.sizeToFit()
            Spicy_heading_lbl.sizeToFit()
            
        }
        
        
    }
    private func getItem ()->ItemsObjectOrdersData?{
        guard let id = product_id else{return nil}
        let model = DBManager.sharedInstance.database.objects(ItemsObjectOrdersData.self).filter("product_id == %a",id)
        return model.first
    }
}

// MARK:- checkout vc
class CheckOutTVC:UITableViewCell{
    
    @IBOutlet weak var itemName_Lbl: UILabel!
    @IBOutlet weak var quantity_lbl: UILabel!
    
    @IBOutlet weak var unitPrizeLbl: UILabel!
    @IBOutlet weak var adOnLbl: UILabel!
    
    @IBOutlet weak var totalPrize_lbl: UILabel!
    var datasource : ItemsObjectOrdersData?{
        didSet{
            configure()
        }
    }
    func configure(){
        guard let ds = datasource else{return}
        if itemName_Lbl == nil{return}
        itemName_Lbl.text = ds.itemName
        
        quantity_lbl.text = String(Int(ds.qty)) + " x"
        
        unitPrizeLbl.text = cleanDollars(String(ds.unit_price))
        
        let totalp = ds.unit_price * ds.qty
        
        totalPrize_lbl.text = cleanDollars(String(totalp))
        for var_att in ds.variations_attrubutes{
            var key = "\n" + var_att.category_key + ": "
            for i in var_att.value{
                key.append(i)
            }
            key.append("\n")
            itemName_Lbl.text?.append(key)
        }
        adOnLbl.attributedText = Global().getAdOnString(adOns: Array(ds.addons))
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


// MARK:- in address vc

class ExistingAddressTVC:UITableViewCell{
    
    @IBOutlet weak var Name_Lbl: UILabel!
    @IBOutlet weak var emailndPhn_lbl: UILabel!
    
    @IBOutlet weak var local_address_lbl: UILabel!
    @IBOutlet weak var city_state_lbl: UILabel!
    
    @IBOutlet weak var edit_btn: UIButton!
    
    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var phoneno_lbl: UILabel!
    
    @IBAction func done_btn(_ sender: Any) {
        optionDropDown.show()
    }
    
    var optionBtnAction : (()->())? = nil
    var optionDropDown = DropDown()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
// MARK:- OrdersTVC
class OrdersTVC:UITableViewCell{
    
    @IBOutlet weak var itemName_Lbl: UILabel!
    @IBOutlet weak var date_lbl: UILabel!
    @IBOutlet weak var orderid_Lbl: UILabel!
    @IBOutlet weak var prize_Lbl: UILabel!
    @IBOutlet weak var status_Lbl: UILabel!
    @IBOutlet weak var viewdetail_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

// MARK:- bankTVC
class BankCardTVC:UITableViewCell{
    
    @IBOutlet weak private var cardName_Lbl: UILabel!
    @IBOutlet weak  private var cardNumber_lbl: UILabel!
    @IBOutlet weak   private var cardType_lbl: UILabel!
    
    var dataSource : ObjectBankCardModel?{
        didSet{
            cardName_Lbl.text = dataSource?.creditCardName
            cardNumber_lbl.text = dataSource?.creditCardNumber
            cardType_lbl.text = dataSource?.cardType
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        
        addShadowToContentView()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func addShadowToContentView() {
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowOffset = CGSize.zero
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowPath = UIBezierPath(rect: self.contentView.bounds).cgPath
        
    }
}

// MARK:- bankTVC
class BankCardViewTVC:UITableViewCell{
    
    @IBOutlet weak  var creditCardview: CardView!
    var dataSource : ObjectBankCardModel?{
        didSet{
            
        }
    }
    //    func setCardView(){
    //        if dataSource == nil{return}
    //        creditCardview.cardHolderString = dataSource?.creditCardName ?? ""
    //
    //
    //        let stringValue = dataSource?.creditCardNumber ?? ""
    //        let v = Int.parse(from: stringValue)!
    //        let str = "424242424242\(String(describing: v))"
    //        print("\n\n",str)
    //        creditCardview.cardHolderExpireDateColor = UIColor.clear
    //        let type = CreditCardValidator().type(from: str)
    //        creditCardview.chipImage = UIImage(named: (type?.name)!)
    //
    //    }
    func setCardView(){
        if dataSource == nil{return}
        creditCardview.cardHolderName = dataSource?.creditCardName
        creditCardview.cardNumber = dataSource?.creditCardNumber
        creditCardview.cardBrand = dataSource?.cardType
        creditCardview.refresh()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        setCardView()
        
        //        addShadowToContentView()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func addShadowToContentView() {
        self.contentView.layer.masksToBounds = false
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.3
        self.contentView.layer.shadowOffset = CGSize.zero
        self.contentView.layer.shadowRadius = 4
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowPath = UIBezierPath(rect: self.contentView.bounds).cgPath
        
    }
}
