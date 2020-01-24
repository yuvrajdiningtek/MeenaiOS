
import UIKit
import Stripe
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class BillSummaryVC: UIViewController {

    @IBOutlet weak private var priceLbl : UILabel!
    @IBOutlet weak private var loaderView : UIView!
    @IBOutlet weak private var nvloaderview : NVActivityIndicatorView!
    @IBOutlet weak private var payBtn : UIButton!
    @IBAction func payBtn(_ sender : UIButton){
        self.goToNextScreen()
    }
    var placeOrderModel : PlaceOrderModel!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setPriceLabel()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         navigationController?.navigationBar.isHidden = false
         self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    func setPriceLabel(){
        loaderView.isHidden = false
        startAnimation()
        ProductsApi.detail_Cart_Info { (succ, _, _) in
            self.loaderView.isHidden = true
            if succ{
                if let  cartData = DBManager.sharedInstance.get_CartData_DataFromDB().first{
                    let total_amount = cartData.object?.total_amount ?? 0
                    self.priceLbl.text = cleanDollars(String(describing: total_amount))
                    return
                }
            }
            self.setWhendataNotGet()
        }
    }
    func startAnimation(){
        nvloaderview.startAnimating()
    }
    func setWhendataNotGet(){
        priceLbl.text = "Oops! some error occur"
        payBtn.isHidden = true
    }
    
//    func goToCardScreen(){
//        let addCardViewController = STPAddCardViewController()
//        self.navigationController?.navigationBar.barTintColor = UIColor.MyTheme.marooncolor
//        addCardViewController.title = "Pay "
//        addCardViewController.delegate = self
//        addCardViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
//        addCardViewController.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
//        addCardViewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
//
////        Stripe.setDefaultPublishableKey("pk_test_IkvHgAPOhO9A64esd1re")
//
//        self.navigationController?.pushViewController(addCardViewController, animated: true)
//
//    }

}

extension BillSummaryVC : STPAddCardViewControllerDelegate{
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        IQKeyboardManager.shared.enable = true
        navigationController?.popViewController(animated: true)
        print("noooo")
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        print("stripe token \(token)")
        self.navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_ID)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_cost)
        placeOrderModel.cardToken = token.tokenId
        IQKeyboardManager.shared.enable = true
        self.processThePayment()
    }
    
    func goToNextScreen(){
        if isUserLoggedIn{
            
            self.goToCardScreen(delegate: self, amount: priceLbl.text!)
            
        }
        else{
            
            let vc = secondSBVC("GuestUserDetailForm") as!  GuestUserDetailForm
            vc.placeOrderModel = placeOrderModel
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func processThePayment(){
        
        let vc = secondSBVC("ProcessingPaymentScreen") as! ProcessingPaymentScreen
        vc.placeOrderModel = placeOrderModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
