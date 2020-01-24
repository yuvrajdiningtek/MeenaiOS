// https://stripe.com/docs/testing

import UIKit

class CardView: UIView {

    public enum Brands : String {
        case NONE, Visa, UnionPay, MasterCard, Amex, JCB, DEFAULT, Discover
    }
    public var colors = [String : [UIColor]]()
    let imagesname = ["Amex","Diners Club","Discover","JCB","MasterCard","UnionPay","Visa"]
    
    @IBOutlet weak private var contentV: UIView!
    @IBOutlet weak  private var gradientView : UIView!
    @IBOutlet weak private var cardNumberLbl: UILabel!
    @IBOutlet weak private var cardHolderNameLbl : UILabel!
    @IBOutlet weak private var cardExpiryLbl : UILabel!
    @IBOutlet weak private var cardBarndImgV : UIImageView!
    
    
    @IBInspectable var cardNumber : String?
     @IBInspectable var cardHolderName : String?
     @IBInspectable var cardExpiryYear : String?
    @IBInspectable var cardExpiryMonth : String?
    @IBInspectable var cardBrand : String?
    
    override func didMoveToSuperview() {
        super.didMoveToWindow()        
        setCardView()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit(){
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(contentV)
        contentV.frame = self.bounds
        contentV.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        setBrandColors()
        gradientView.clipsToBounds = true
        gradientView.layer.cornerRadius = 5
        contentV.layer.cornerRadius = 5
    }
    
}
extension CardView {
    func refresh(){
        setCardView()
    }
    func setCardView(){
        
        cardNumberLbl.text = setCardNumber() ?? "**** **** **** ****"
        cardHolderNameLbl.text = cardHolderName ?? "---"
        cardExpiryLbl.text = (cardExpiryMonth ?? "MM")+"/"+(cardExpiryYear ?? "YY")
        if cardBrand == nil{return}
        let imgs =  imagesname.filter({ (str) -> Bool in
            
            if str.lowercased().contains(cardBrand!.lowercased()){return true}
            return false
        })
        cardBarndImgV.image = UIImage(named: imgs[0])
        let color = colors[imgs[0]]
        if color == nil{return
            gradientView.setGradientBackground(colorTop: colors[Brands.NONE.rawValue]![0], colorBottom: colors[Brands.NONE.rawValue]![1])

        }
        gradientView.setGradientBackground(colorTop: color![0], colorBottom: color![1])
        
    }
    fileprivate func setBrandColors() {
        colors[Brands.NONE.rawValue] = [UIColor(hex: 0x363434),  UIColor(hex: 0x363434)]
        
        colors[Brands.Visa.rawValue] = [UIColor(hex: 0x5D8BF2), UIColor(hex: 0x3545AE)]
        colors[Brands.MasterCard.rawValue] = [UIColor(hex: 0xED495A), UIColor(hex: 0x8B1A2B)]
        
        colors[Brands.UnionPay.rawValue] = [UIColor(hex: 0x987c00), UIColor(hex: 0x826a01)]
        colors[Brands.Amex.rawValue] = [ UIColor(hex: 0x005B9D),UIColor(hex: 0x132972)]
        colors[Brands.JCB.rawValue] = [UIColor(hex: 0x265797),  UIColor(hex: 0x3d6eaa)]
        colors["Diners Club"] = [UIColor(hex: 0x5b99d8), UIColor(hex: 0x4186CD)]
        colors[Brands.Discover.rawValue] = [UIColor(hex: 0xe8a258), UIColor(hex: 0xD97B16)]
        colors[Brands.DEFAULT.rawValue] = [UIColor(hex: 0x5D8BF2), UIColor(hex: 0x3545AE)]
    }
    func setCardNumber()->String?{
        
        guard let cardNumber =  cardNumber else{return nil}
        
        let v = Int.parse(from: cardNumber) ?? "****"
        let str = "**** **** **** \(v)"
        
        return str

    }
}
