

import UIKit
import SCLAlertView
import DropDown

class ExistingAddressVC: UIViewController , UINavigationControllerDelegate{

    //MARK: - IBOUTLETS
    @IBOutlet weak var existingAddressTV: UITableView!
    @IBOutlet weak var paginationView: SegmentForPaginationView!
    
    @IBOutlet weak var left_btn_at_header: UIBarButtonItem!
    @IBAction func left_btn_at_header(_ sender: Any) {

        if self.navigationController?.viewControllers.count == 1{
            sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBOutlet weak var add_floating_btn: UIButton!{
        didSet{
//            add_floating_btn.layer.cornerRadius = add_floating_btn.frame.height / 2
        }
    }
    @IBAction func addfloating_btn(_ sender: Any) {
        newaddress(_sender: sender)
    }
    
    
    //MARK: - VARIABLES
    var addressArr = [DataAdressModel]()
    var selectedAddressModel : DataAdressModel?
    var addressSelect : ((DataAdressModel)->())?
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.delegate = self
        paginationView.valueChanged = {
            (val) in
            self.getExistingAddress(pageNumber: val)
        }
    }
    override func viewWillAppear(_ animated: Bool) {

        addressArr.removeAll()
        let vcs = self.navigationController?.viewControllers
        if (vcs?.count) ?? 0 > 3{
            add_floating_btn.isHidden = false
        }        
        do_when_AddresFound()

        NetworkManager.isUnreachable { (_) in
            SCLAlertView().showError("network unreachable")
            
        }
        NetworkManager.isReachable { (_) in
            self.getExistingAddress(pageNumber: 0)
        }        
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
       
    }
    //MARK: - NAVIGATION DELEGATE
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
//        if let controller = viewController as? CheckOutVC {
//            controller.addressModel = selectedAddressModel    // Here you pass the data back to your original view controller
//        }
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
       
    }
    
    //MARK: - FUNCTIONS

    func getExistingAddress(pageNumber : Int){
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        SomeInformationApi.get_existing_address(pageNumber: String(pageNumber)) { (success, result) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                self.addressArr.removeAll()
                let orderData = DBManager.sharedInstance.get_Addresses_DataFromDB()[0] as AdressModel
                self.paginationView.maxLimitOfPageNumber =  orderData.total/10
                if orderData.total%10 != 0{
                    self.paginationView.maxLimitOfPageNumber = self.paginationView.maxLimitOfPageNumber + 1
                }
                
                if  orderData.data.count != 0{
                    for address in orderData.data{
                        self.addressArr.append(address)
                    }
                }
                self.do_when_AddresFound()
                self.existingAddressTV.reloadData()
            }
            else{
                self.do_when_AddresFound()
                if result == nil{
                    SCLAlertView().showError("error", subTitle: "") // Error
                }else{
                    
                }
            }
        }
    }

}


extension ExistingAddressVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.addressArr.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("HomeTVC", owner: Any?.self, options: nil)?[3] as! ExistingAddressTVC
        
        //name
        let fname = self.addressArr[indexPath.row].firstName
        let mname = self.addressArr[indexPath.row].middleName
        let lname = self.addressArr[indexPath.row].lastName
        cell.Name_Lbl.text =  fname + " " + mname + " " + lname
        
        //emai phn
        let email = self.addressArr[indexPath.row].email
        let phn = self.addressArr[indexPath.row].mobileNumber
        cell.emailndPhn_lbl.text = email
        cell.phoneno_lbl.text = phn
        //Address
        let address1 = self.addressArr[indexPath.row].address1
        let address2 = self.addressArr[indexPath.row].address2
        
        if address2 == "" {
             cell.local_address_lbl.text = address1
            cell.local_address_lbl.font = cell.local_address_lbl.font.withSize(18)
        }
        else {
        cell.local_address_lbl.text = address1 + "\n" + address2
        }
        //City state
        let city = self.addressArr[indexPath.row].city
        let stateName = self.addressArr[indexPath.row].stateName
//        let state = self.addressArr[indexPath.row].state
//        print(state)
        let postalcode = self.addressArr[indexPath.row].postalCode
        cell.city_state_lbl.text = city + ", " + stateName + ", " + postalcode
        
        // Edit Button
//        cell.edit_btn.tag = indexPath.row
//        cell.edit_btn.addTarget(self, action: #selector(editTheAddress), for: .touchUpInside)
        let dropdown_dataSource = ["Delete            ","Update            "]
        cell.optionDropDown.anchorView = cell.edit_btn
        cell.optionDropDown.dataSource = dropdown_dataSource
        cell.optionDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                self.showalert_for_delete(at: indexPath.row)
                
            }else{
                self.editTheAddress(cell.edit_btn)
            }
            
        }
        cell.edit_btn.tag = indexPath.row
        cell.optionDropDown.direction = .any
        
        return cell
    }
    
    func do_when_AddresFound(){
        if addressArr.count == 0{
            existingAddressTV.isHidden = true
        }else{
            existingAddressTV.isHidden = false
        }
        
    }
    @objc func editTheAddress(_ sender:UIButton){
        let vc = secondSBVC("EditCreateAddressVC") as! EditCreateAddressVC
        vc.passedAddress = addressArr[sender.tag]
        vc.update = true
        vc.statenameForAdddrss = addressArr[sender.tag].stateName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func newaddress(_sender:Any){
        let vc = secondSBVC("EditCreateAddressVC") as! EditCreateAddressVC
        vc.update = true
        
        vc.passedAddress = nil
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcs = self.navigationController?.viewControllers
        if vcs?.count == 1{
            let vc = secondSBVC("EditCreateAddressVC") as! EditCreateAddressVC
            vc.passedAddress = addressArr[indexPath.row]
            vc.statenameForAdddrss = addressArr[indexPath.row].stateName
            //vc.stateIDD = addressArr[indexPath.row].state
            
            vc.update = false
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            addressSelect?(addressArr[indexPath.row])
            selectedAddressModel = addressArr[indexPath.row]
            self.navigationController?.popViewController(animated: true)

        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            self.showalert_for_delete(at: indexPath.row)
        }
        delete.backgroundColor = .red
        
        
        return [delete]
    }
    func delete_address(at index:Int){
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let addressid = self.addressArr[index].address_id
        UserDefaults.standard.setValue(addressid, forKey: "add_id")
        RegisterApi.delete_address(address_id: addressid) { (success, _) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                self.addressArr.removeAll()
                self.getExistingAddress(pageNumber: self.paginationView.pageNumber)
//                print(index)
//                self.existingAddressTV.deleteRows(at: [IndexPath(row:index,section:0)], with: .none)
            }else{
                SCLAlertView().showError("error occured")
            }
        }
    }
    func showalert_for_delete(at index : Int){
        let alert = UIAlertController(title: "Address Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        let done = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.delete_address(at: index)
        }
        let cnle = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(done)
        alert.addAction(cnle)
        self.present(alert, animated: true, completion: nil)
        
    }
}
