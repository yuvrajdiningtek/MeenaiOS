

import UIKit
import UIKit
import SDWebImage
import SideMenuController
import DropDown
import SCLAlertView

class ProductsDetailVC: UIViewController {
    
    @IBOutlet weak var blackViewClearIpad: UIView!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var header_lbl: UILabel!
    @IBAction func backBtnn(_ sender: Any) {
        self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var collection_v: UICollectionView!
    
    @IBAction func cartBtn(_ sender: Any) {
        //MyCartVC
        let vc = secondSBVC("PlaceOrderVC")//PlaceOrderVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var cartBadgeBtn: BadgeButton!
    
    
    //MARK : - VARIABLES
    var productsArr = [Products]()
    var selectedProduct = Products()

    var selected_cell_index :IndexPath?
    
    
    // MARK: - VARIABLES
    
    var items = [ItemsObjectOrdersData]()
    
    
    var bdgevalue: String = "0"{
        didSet {
            if bdgevalue == "0"{
                cartBadgeBtn.badgeValue = ""
            }else{
                cartBadgeBtn.badgeValue = bdgevalue
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.current.userInterfaceIdiom == .pad{
            blackViewClearIpad.backgroundColor = .clear
        }
        print(selected_cell_index,"iiiiii")
        collection_v.layer.cornerRadius = 10
        UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        set_badge_btn()
        collection_v.setNeedsLayout()
        collection_v.layoutIfNeeded()
//        if selected_cell_index != nil{
//            collection_v.scrollToItem(at: selected_cell_index!, at: .centeredHorizontally, animated: false)
//            selected_cell_index = nil
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    func set_badge_btn(){
        self.bdgevalue = cartbadgevalue
    }
    
    
    
    // MARK: - SelectedVariationsDelegate
    var variationId: String = ""
    
    var price: Double = 0.0
    var selectedVID : ((String,Double,String) -> ()) = { (_,_,_) in
        
    }
    
    func selectedvariation(variationId: String, variationKey: String, variationname: String, variationPrice: Double) {
        selectedVID(variationId, variationPrice,variationname)
        
    }
}
extension ProductsDetailVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductDetailCVC
        cell.viewController = self
        cell.product = selectedProduct
        cell.id = selectedProduct.name
//        cell.id = "\(productsArr[indexPath.row].name)\(indexPath.row)"
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.header_lbl.text = self.productsArr[indexPath.row].name.uppercased()
    }
    
}
