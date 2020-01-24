

import UIKit
import NVActivityIndicatorView
import Stripe

class ProcessingPaymentScreen: UIViewController {

    @IBOutlet weak var loaderview : NVActivityIndicatorView!
    var placeOrderModel : PlaceOrderModel!
    var guestPlaceOrderModel : GuestPlaceOrderModel?
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // navigationController?.navigationBar.isHidden = true
        
        
        //self.navigationController?.setNavigationBarHidden(true, animated: true)
        //self.placeApiCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
         self.placeApiCall()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func startAnimation(){
        loaderview.startAnimating()
    }
    
    
    
    func placeApiCall(){
        
        
        SubmissionAPIs.placeOrder_api(placeOrderModel: placeOrderModel, guestPlaceOrderModel: guestPlaceOrderModel) { (succ, rst, err) in
            print("response",rst)
            if succ{
                cartbadgevalue = "0"
                print(rst)
                
               
                
                UserDefaults.standard.setValue(rst, forKey: "rst")
                
                Message.showSuccessmsg(style: .bottom, message: "Thankyou for your order. Your order is successfully placed")
                PlaceOrderCredentials.shared.address_id = ""
                var x : [NSDictionary] = []
                x.append(rst as! NSDictionary)
              //  print(x)
               
                 //MapOrderData().mapData(value: x)
                let vc = secondSBVC("OrderDetailVC") as! OrderDetailVC
    
                 let rsdict = rst as! NSDictionary
                
                
               let orderDetailDict = rsdict.value(forKey: "object") as! NSDictionary
              let orderDetailObj =  orderDetailDict.value(forKey: "order_detail") as! NSDictionary
                vc.passedOrderData =  DatainOrdersData(value:orderDetailObj  )
                print(vc.passedOrderData)
                
                self.navigationController?.pushViewController(vc, animated: true)
    
                
                
            }else{
                
                if err.contains("Bucket"){
                    return
                }
                
//                Message.showSuccessmsg(style: .bottom, message: err)
                Message.showErrorMessage(style: .bottom, message: err, title: "Oops!")
                
                self.navigationController?.popViewController(animated: true)
//                for controller in self.navigationController!.viewControllers as Array {
//                    if controller.isKind(of: BillSummaryVC.self) {
//                        _ =  self.navigationController!.popToViewController(controller, animated: true)
//                        break
//                    }
//                }
                
                

//                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
//                self.navigationController?.popViewController(animated: true)
                
//
              //  self.goToCardScreen(delegate: self, amount: self.getTotalAmount())
//
//                let vc = secondSBVC("ProcessingPaymentScreen") as! ProcessingPaymentScreen
//                vc.placeOrderModel = self.placeOrderModel
//                self.navigationController?.pushViewController(vc, animated: true)
//
                
//                Message.showErrorOnTopStatusBar(message: err)
//                self.sideMenuController?.performSegue(withIdentifier: "toHome", sender: self)
            }
            
        }
        
    }
    
   
    
//    func goToOrderDtailScrenn(){
//
////        if let orderid = Global().getOrderIdFromPlaceOrderResult(data: data){
//            let vc = secondSBVC("OrderDetailVC") as! OrderDetailVC
//           vc.passedOrderData = getDatafrmDatabase(orderId: orderid)
////            if let x = rst as? DatainOrdersData {
//                vc.orderId = orderid
//                self.navigationController?.pushViewController(vc, animated: true)
//
//           // }
////            vc.passedOrderData = rst as! DatainOrdersData
////            vc.orderId = orderid
////            self.navigationController?.pushViewController(vc, animated: true)
////        }else{
////            self.nvmanager.makeHomeVCAsRootVC()
////        }
//    }
    
    func getDatafrmDatabase(orderId: String)->DatainOrdersData?{
        let predicate = NSPredicate(format: "orderId == %@", orderId)
        guard let orderDetail = DBManager.sharedInstance.database.objects(DatainOrdersData.self).filter(predicate).first else{
            
            return nil
        }
        return orderDetail
    }
//    func getTotalAmount()->String{
//        if let dbm = DBManager.sharedInstance.get_CartData_DataFromDB().first{
//            if let total = (dbm.object?.total_amount){
//                return (cleanDollars(String(total)))
//            }
//        }
//        return ""
//
//    }
}
//extension ProcessingPaymentScreen : STPAddCardViewControllerDelegate{
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//        self.view.endEditing(true)
////        IQKeyboardManager.shared.enable = true
//       print("kkkk")
//
//          if isUserLoggedIn{
//            for controller in self.navigationController!.viewControllers as Array {
//                if controller.isKind(of: BillSummaryVC.self) {
//                    _ =  self.navigationController!.popToViewController(controller, animated: true)
//                    break
//                }
//            }
//
//          }
//          else {
//
//        for controller in self.navigationController!.viewControllers as Array {
//                                if controller.isKind(of: GuestUserDetailForm.self) {
//                                    _ =  self.navigationController!.popToViewController(controller, animated: true)
//                                    break
//                                }
//                            }
//        //self.navigationController?.popViewController(animated: true)
//        }}
//    func addCardViewController(_ addCardViewController: STPAddCardViewController,
//                               didCreateToken token: STPToken,
//                               completion: @escaping STPErrorBlock) {
//        print("stripe token \(token)")
//       // IQKeyboardManager.shared.enable = true
//        self.navigationController?.popViewController(animated: true)
//        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_ID)
//        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_cost)
//        placeOrderModel.cardToken = token.tokenId
//        //self.processThePayment()
//
//    }
//
//}
