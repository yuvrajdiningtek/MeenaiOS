

import UIKit
import SCLAlertView
import DropDown

class MyCartVC: UIViewController, CustomStepperDelegate {
    
    
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBAction func menuBtn(_ sender: Any) {
        if self.navigationController?.viewControllers.count == 1{
            self.sideMenuController?.toggle()
        }else{
            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.getAlOredrs(completion: {(_, _) in
               self.navigationController?.popViewController(animated: true)
            })
            
//            self.orders_TV.reloadData()
            
        }
        
    }
    @IBAction func homeBtn(_ sender: Any) {
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
        
     
        
    }
    
    @IBOutlet weak var removecart: UIBarButtonItem!
    @IBAction func removeCartBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Cart", message: "Are you sure you want to delete cart ?",         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { _ in
            self.deleteWholeCart()
        }))
        alert.addAction(UIAlertAction(title: "No",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                      self.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
       
    }
    @IBOutlet weak var orders_TV: UITableView!
    
    
    @IBAction func checkOutBtn(_ sender: Any?) {
        
        chkOutBtn.isEnabled = false
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        getAlOredrs(completion: {
            (succ,error) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            
            if succ{
                self.pushToPlaceOrderVC()
            }else{
                
                Message.showErrorMessage(style: .bottom, message: error ?? "some error occue", title: "")
                
            }
        })
        
        
        
    }
    
    @IBOutlet weak var chkOutBtn: UIButton!
    
    //MARK: - VARIABLES
    
    var items = [ItemsObjectOrdersData]()
    var rowselcted : (Bool,IndexPath)?
    var maxQuantity_userCan_order : Int = 0
    var orderData = CartData()
    var already_applied_coupons : [String:String]?
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(false, forKey: "iscomefromApply")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "GlacialIndifference-Regular", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        chkOutBtn.isEnabled = true
        
        
        NetworkManager.isUnreachable { (_) in
            SCLAlertView().showError("network unreachable")
        }
        NetworkManager.isReachable { (_) in
            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
            self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            self.orders_TV.isHidden = false
            self.getAlOredrs(completion: {
                
                (succ,error) in
                hideactivityIndicator(activityIndicator: activityIndicator)
                
                if !succ{
                    print("eeeeeeeeeeeee",error)

                    print(error)
                    if (error?.contains("INVALID") ?? false) || (error?.contains("Invalid") ?? false) {
                        self.deleteInvAlidBucket()
                        return
                        
                    }
                    
                    SCLAlertView().showError("error", subTitle: error ?? "Some error occur") // Error
                }
                else{
                }
                
            })
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if self.navigationController?.viewControllers.count == 1{
            menuBtn.image =  UIImage(named : "menu_@x1")
        }else{
            menuBtn.image =  UIImage(named : "left-arrow")
        }
        
        
        
    }
    
    
    //MARK: - FUNCTIONS
    func pushToPlaceOrderVC(){
        //        let vc = secondSBVC("CheckOutVC") as! CheckOutVC
        let vc = secondSBVC("PlaceOrderVC") as! PlaceOrderVC
        
        vc.applied_coupons = self.already_applied_coupons
        let a = already_applied_coupons?.first?.value
        UserDefaults.standard.setValue(a, forKeyPath: "savedCouponValue")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAlOredrs(completion: @escaping (Bool,String?)->()){
        
         let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        orders_TV.allowsSelection  = false
        
        items.removeAll()
        
        ProductsApi.detail_Cart_Info { (success, result,_) in
              activityIndicator.startAnimating()
            self.orders_TV.allowsSelection  = true
            
            if success{
                print("----",self.self.items.count)
                
                let object = (result as! NSDictionary).value(forKey: "object") as? NSDictionary
                let applied_coupons = object?.value(forKey: "applied_coupons") as? [String:String]
                self.already_applied_coupons = applied_coupons
            }
            
            
            
            if DBManager.sharedInstance.get_CartData_DataFromDB().count > 0 {
                
                self.orderData = DBManager.sharedInstance.get_CartData_DataFromDB()[0] as CartData
                
                if let items = self.orderData.object?.items{
                    self.items.removeAll()
                    self.rowselcted = nil
                    for item in items{
                        print(item)
                        self.items.append(item)
                    }
                }
                let totalPrice = self.orderData.object?.sub_total ?? 0
                let tp = cleanDollars(String(describing: totalPrice))
                self.chkOutBtn.setTitle("CHECK OUT \(tp)", for: .normal)
                completion(true, nil)
                self.orders_TV.reloadData()
            }
            else{
                if result == nil{
                    completion(false, nil)
                }else{
                    if let object = (result as? NSDictionary)?.value(forKey: "object") as? NSDictionary{
                        if let error = object.value(forKey: "error") as? String{
                            completion(false, error)
                        }
                    }
                    self.items.removeAll()
                }
                
            }
            self.visibilityThings()
        }
        
        
        
    }
}

extension MyCartVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("HomeTVC", owner: Any?.self, options: nil)?[6] as! CartThirdTVC
        cell.itemName_Lbl.text = items[indexPath.row].itemName
         cell.product_id = items[indexPath.row].product_id
        cell.quantity_lbl.text = "\(Int(items[indexPath.row].qty))"
        
        print("Ccc",items[indexPath.row].customerInstruction.first)
        let customerInstructionn = items[indexPath.row].customerInstruction.first
        
        
        if items[indexPath.row].addons.count == 1{
             cell.adOnLbl.text = items[indexPath.row].addons[0].addon_full_name
        }
        if items[indexPath.row].addons.count == 2{
        
      //  for i in 0...1 {
             cell.adOnLbl.text = items[indexPath.row].addons[0].addon_full_name
            cell.adOnLbl2.text = items[indexPath.row].addons[1].addon_full_name
       // }
        }
        else {
            print("empty")
        }
      
        
        
        
        // cell.adOnLbl.text = "AddOns: \n" + items[indexPath.row].addons[1].addon_full_name
        
        
//        func getAdOnString(adOns : [AdOnObjectModel])->NSMutableAttributedString?{
//            if adOns.count == 0{return nil}
//            let heading = NSMutableAttributedString(string: "AddOns: \n", attributes: attributesHeading())
//            for i in adOns{
//                let subH = NSAttributedString(string: i.addon_full_name, attributes: attributesSubHeading())
//               // let qty = NSAttributedString(string: "   x \(i.qty)", attributes: attributesSubHeading())
//               // let unitPrice = NSAttributedString(string: "  :  USD \(i.unit_price) $\n", attributes: attributesSubHeading())
//                cell.adOnLbl.text = i.addon_full_name
//                heading.append(subH)
////                heading.append(qty)
////                heading.append(unitPrice)
//            }
//            return heading
//        }
//        func attributesHeading()->[NSAttributedString.Key: Any]{
//            let font = UIFont(name: "GlacialIndifference-Bold", size: 14)
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: font,
//                .foregroundColor: UIColor.black,
//            ]
//            return attributes
//        }
//        func attributesSubHeading()->[NSAttributedString.Key: Any]{
//            let font = UIFont(name: "GlacialIndifference-Regular", size: 12)
//
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: font,
//                .foregroundColor: UIColor.darkGray,
//            ]
//            return attributes
//        }
        
//        cell.adOnLbl.text = items[indexPath.row].addons(add)
        let a = Double(cell.quantity_lbl.text ?? "0") ?? 0
        let p = items[indexPath.row].unit_price * a
        let pr = cleanDollars(String(p))
        cell.unitPrizeLbl.text = "\(pr)"
        if customerInstructionn == ""{
            cell.single_item_price.text = "\(cleanDollars("\((items[indexPath.row].unit_price))"))  \(customerInstructionn ?? "")"
        }
        else{
            
            cell.single_item_price.text = "\(cleanDollars("\((items[indexPath.row].unit_price))"))  📝 \(customerInstructionn ?? "")"
        }
        
        cell.variation_lbl.numberOfLines = 0
        cell.variation_lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
       
        cell.Spicy_heading_lbl.numberOfLines = 0
        cell.Spicy_heading_lbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        
        cell.variation_lbl.text = ""
        cell.Spicy_heading_lbl.text = ""
//        cell.adOnLbl.text =
        
        if items[indexPath.row].variations_attrubutes.count != 0{
            
            for i in 0...items[indexPath.row].variations_attrubutes.count-1 {
                let key = items[indexPath.row].variations_attrubutes[i].category_key
                let values = items[indexPath.row].variations_attrubutes[i].value
                if values.count != 0{
                    cell.Spicy_heading_lbl.text?.append(key+"\n")
                    cell.variation_lbl.text?.append(values[0]+"\n")
                }
            }
            cell.variation_lbl.sizeToFit()
            cell.Spicy_heading_lbl.sizeToFit()
//            let key = items[indexPath.row].variations_attrubutes[0].category_key
//            let values = items[indexPath.row].variations_attrubutes[0].value
//
//            if values.count != 0{
//                cell.Spicy_heading_lbl.text = key
//                cell.variation_lbl.text = values[0]
//            }
            
        }
        
        
        // delete drop down
        let dropdowndatasource = ["         DELETE          "]
        
        cell.obj = {
            cell.deleteDropDown.show()
        }
        cell.deleteDropDown.anchorView = cell.option_btn
        cell.deleteDropDown.dataSource = dropdowndatasource
        
        cell.deleteDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.deleteitemBtn(at: indexPath.row)
            //            self.tip_amount_lbl.text = ((amount / Double(item)) * 100)
        }
        cell.deleteDropDown.direction = .any
        
        
        // stepper view
        cell.custom_stepperV.value = CGFloat(items[indexPath.row].qty)
        cell.custom_stepperV.delegate = self
        cell.custom_stepperV.tag = indexPath.row
        cell.custom_stepperV.step = 1
        
        let (min,max) = ProductsDetailViewModel(vc: self).get_stepper_min_max_value()
        cell.custom_stepperV.minValue = CGFloat(min)
        cell.custom_stepperV.maxValue = CGFloat(max)
        
        
        return cell
        
    }
    
    
    func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        sender.isUserInteractionEnabled = true
//        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
//        activityIndicator.startAnimating()
        if sender.tag < items.count{
          //  hideactivityIndicator(activityIndicator: activityIndicator)

            present_action_sheet(itemid: self.items[sender.tag].item_id, qty: String(describing: value)) { (update) in
                if !update{
                    if increment{
                        sender.value = value - 1
                        
                    }else if decrement{
                        sender.value = value + 1
                    }
                    
                }else{
                    try? DBManager.sharedInstance.database.write {
                        if self.items.count != 0{
                        self.items[sender.tag].qty = Double(value)
                        }
                    }
                    
                    self.orders_TV.reloadRows(at: [IndexPath(row:sender.tag,section:0)], with: .none)
                    
                }
            }
        }
        else{
            sender.isUserInteractionEnabled = false
//            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
//            self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
//            activityIndicator.startAnimating()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                hideactivityIndicator(activityIndicator: activityIndicator)
//            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        if items.count == 0 {
//            navigationController?.popViewController(animated: true)
//        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            self.deleteitemBtn(at: indexPath.row)
        }
        delete.backgroundColor = .red
        
        
        
        return [delete]
        
        
    }
    
    
    func present_action_sheet(itemid:String,qty:String,callback:@escaping ((Bool)->())){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let update_action = UIAlertAction(title: "Update item", style: .default) { (_) in
            self.submitThe_qty(bucketItemId: itemid, quantity: qty, completion: {
                (success) in
                if success{
                    callback(true)
                }else{
                    callback(false)
                }
            })
            
        }
        let cancle_action = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            callback(false)
        }
        actionSheet.view.tintColor = UIColor.MyTheme.marooncolor
        actionSheet.addAction(update_action)
        actionSheet.addAction(cancle_action)
        
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            
            
            
            //            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
            popoverController.sourceRect = chkOutBtn.frame
        }
        
        self.present(actionSheet, animated: true) {
            
        }
        
    }
    @objc func
        deleteitemBtn(at index:Int){
        
        print("items", items)
        if index >= items.count{
            return
        }
        if items.count == 1{
            deleteWholeCart()
            return
        }
        let itemid = items[index].item_id
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("deleteitemBtn press")
        
        ProductsApi.delete_item_from_cart(item_id: itemid) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            print("deleteitemBtn api response")
            if success{
                
                let obj = self.items.remove(at: index)
                
                self.rowselcted = nil
                self.orders_TV.reloadData()
                self.deleteObject(obj: obj)
                
                print("obj is ", obj)
                
            }
            else{
                if result == nil{
                    SCLAlertView().showError("error", subTitle: "") // Error
                }else{
                    SCLAlertView().showError("error", subTitle: "") // Error
                }
            }
            print("all object", self.items)
            self.visibilityThings()
        }
    }
    
    
    func deleteWholeCart(){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        ProductsApi.delete_cart { (success, result) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                self.items.removeAll()
                DBManager.sharedInstance.deleteBucketId()
                ProductsApi.detail_Cart_Info(callback: { (_, _,_) in
                    
                })
                self.orders_TV.reloadData()
            }
            else{
                SCLAlertView().showError("error", subTitle: "") // Error
            }
            self.visibilityThings()
        }
    }
    func visibilityThings(){
        if self.items.count == 0{
            self.orders_TV.isHidden = true
            self.removecart.tintColor = .clear
            self.chkOutBtn.isHidden = true
        }
        if self.items.count != 0{
            self.orders_TV.isHidden = false
            self.removecart.tintColor = .white
            self.chkOutBtn.isHidden = false
        }
    }
    
    func submitThe_qty(bucketItemId: String , quantity: String, completion: @escaping (Bool)->()){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        SubmissionAPIs.update_quantity_of_product(bucketItemId: bucketItemId, quantity: quantity) { (success, _) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                
                self.getAlOredrs(completion: {(_, _) in
                    completion(true)
                })
                
                
            }else{
                SCLAlertView().showError("some error occured")
                completion(false)
            }
        }
    }
    
    func deleteObject(obj : ItemsObjectOrdersData){
        
        print("delete object")
        
        try! DBManager.sharedInstance.database.write {
            DBManager.sharedInstance.database.delete(obj)
        }
        
    }
    
    func deleteInvAlidBucket(){
        print(isUserLoggedIn)
        if !isUserLoggedIn{
            if let a = DBManager.sharedInstance.getBucketId() , a == ""{return}
            DBManager.sharedInstance.deleteBucketId()
            return}
        else{
            if let a = DBManager.sharedInstance.getBucketId() , a != ""{
                self.deleteWholeCart()
                DBManager.sharedInstance.deleteBucketId()
                return}
            
        }
    }
}
