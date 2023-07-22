
// https://stackoverflow.com/questions/31232689/how-to-set-cornerradius-for-only-bottom-left-bottom-right-and-top-left-corner-te
import Foundation
import UIKit
class HomeCVC : UICollectionViewCell{
    
    @IBOutlet weak var product_imgV: UIImageView!
    @IBOutlet weak var productName_lbl: UILabel!
    @IBOutlet weak var productPrice_lbl: UILabel!
    @IBOutlet weak var shadow_view: ShadowView!
    @IBOutlet weak var product_Desciption_lbl: UILabel!
    @IBOutlet weak var imggHeight: NSLayoutConstraint!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var custom_stepperV: CustomStepper!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let PRODUCT_IMAGE_PREVIEW = UserDefaults.standard.value(forKey: "PRODUCT_IMAGE_PREVIEW") as? String
        if PRODUCT_IMAGE_PREVIEW == "true"{
//            imggHeight.constant = 100
//            descHeight.constant = 0
            product_imgV.isHidden = false
        }
        else{
            product_imgV.isHidden = true

//            imggHeight.constant = 0
//            descHeight.constant = 60
        }
        
        product_imgV.layer.masksToBounds = true
        product_imgV.clipsToBounds = true
        product_imgV.layer.cornerRadius = 10
        
        addBtn.layer.cornerRadius = 7
        addBtn.layer.borderColor = UIColor.MyTheme.marooncolor.cgColor
        addBtn.layer.borderWidth = 0.5

//        product_imgV.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

    }
    var dataSet : Products?{
        didSet{
            configureUi()
        }
    }
    func configureUi(){
        if product_imgV == nil{return}
        guard let product = dataSet else{return}
        
        let PRODUCT_IMAGE_PREVIEW = UserDefaults.standard.value(forKey: "PRODUCT_IMAGE_PREVIEW") as? String
        
        if PRODUCT_IMAGE_PREVIEW == "true"{
            if product.image.count > 0{
                
                let url = URL(string: product.image[0])
                product_imgV.sd_setShowActivityIndicatorView(true)
                product_imgV.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder img"))
            }
        }
        
        
        productName_lbl.text = product.name
        product_Desciption_lbl.text = product.descriptions
        //        description_lbl.text = product.descriptions
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


class HomeCategoryCVC: UICollectionViewCell{
    
    @IBOutlet weak var homeCat_TableV: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}


