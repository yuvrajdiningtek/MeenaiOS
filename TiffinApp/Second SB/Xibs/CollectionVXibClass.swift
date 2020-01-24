
// https://stackoverflow.com/questions/31232689/how-to-set-cornerradius-for-only-bottom-left-bottom-right-and-top-left-corner-te
import Foundation
import UIKit
class HomeCVC : UICollectionViewCell{
    
    @IBOutlet weak var product_imgV: UIImageView!
    @IBOutlet weak var productName_lbl: UILabel!
    @IBOutlet weak var productPrice_lbl: UILabel!
    @IBOutlet weak var shadow_view: ShadowView!
    @IBOutlet weak var product_Desciption_lbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        product_imgV.layer.masksToBounds = true
        
        product_imgV.clipsToBounds = true
        //        product_imgV.layer.cornerRadius = 4
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
        
        
        if product.image.count > 0{
            // let url = URL(string: product.image[0])
            // product_imgV.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "placeholder img"))
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


