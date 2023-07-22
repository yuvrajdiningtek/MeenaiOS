

import UIKit
import NVActivityIndicatorView
import SCLAlertView

class OrdersVC: UIViewController {

    //MARK: - IBOUTLETS
    @IBOutlet weak var orders_TV: UITableView!
    @IBOutlet weak var paginationView: SegmentForPaginationView!

    @IBAction func menuBtn_action(_ sender: Any) {
//        self.sideMenuController?.toggle()
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)

    }
    
    //MARK: - VARIABLES
    var items = [DatainOrdersData]()
    
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        NetworkManager.isUnreachable { (_) in
            SCLAlertView().showError("network unreachable")            
        }
        NetworkManager.isReachable { (_) in
            self.getAll_orders(pageNumber: 0)
        }
        paginationView.valueChanged = {
            (val) in
            self.getAll_orders(pageNumber: val)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: - FUNCTIONS
    func getAll_orders(pageNumber : Int){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        ProductsApi.get_Orders(id: nil, pageNumber: String(pageNumber)) { (success, _) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            if !success{
               return
            }
            let od = DBManager.sharedInstance.get_Orders_DataFromDB()
            print(od)
            if od.count > 0{
                self.items.removeAll()
                self.paginationView.maxLimitOfPageNumber =  od[0].total/10
                if od[0].total%10 != 0{
                    self.paginationView.maxLimitOfPageNumber = self.paginationView.maxLimitOfPageNumber + 1
                }
                for item in od[0].data{
                    self.items.append(item)
                }
                if self.items.count > 0{
                    self.orders_TV.isHidden = false
                    self.orders_TV.reloadData()
                }
            }
            
        }
    }
    
}




extension OrdersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTVC", owner: Any?.self, options: nil)?[4] as! OrdersTVC
        
        
       // cell.date_lbl.text =  "Placed at : " + items[indexPath.row].orderedDate
        cell.orderid_Lbl.text = items[indexPath.row].orderId
        cell.prize_Lbl.text = (cleanDollars(String(items[indexPath.row].orderTotal)))
        if items[indexPath.row].orderStatus.count > 0{
            cell.status_Lbl.text = items[indexPath.row].orderStatus[0].status
            if items[indexPath.row].orderStatus.last?.status.contains("Order") == true{
                if items[indexPath.row].orderCreatedDate != ""{
                cell.date_lbl.text =  "Placed at : " + items[indexPath.row].orderCreatedDate
                }
                else{
                    cell.date_lbl.text =  "Placed at : N/A"
                }
            }
            else{
                cell.date_lbl.text =  "Placed at : " + items[indexPath.row].orderedDate
               
            }
        }
        else{
            cell.date_lbl.text =  "Placed at : " + items[indexPath.row].orderedDate
        }
        cell.viewdetail_btn.tag = indexPath.row
        
//        cell.viewdetail_btn.addTarget(self, action: #selector(viewDetail_btn), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = secondSBVC("OrderDetailVC") as! OrderDetailVC
        vc.isOrderHistory = true
        vc.orderId = items[indexPath.row].orderId
        vc.stateNmae = items[indexPath.row].billingAddress?.stateName
        vc.notee = items[indexPath.row].note
        vc.orderCreated_At = items[indexPath.row].orderCreatedDate
        UserDefaults.standard.setValue(true, forKey: "iscomefrompast")
//
//        let defaults = UserDefaults.standard
//        defaults.removeObject(forKey: "AddressKind")
//
//        defaults.synchronize()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func viewDetail_btn(_ sender: UIButton){
        let vc = secondSBVC("OrderDetailVC") as! OrderDetailVC
        vc.orderId = items[sender.tag].orderId
        vc.notee = items[sender.tag].note
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
