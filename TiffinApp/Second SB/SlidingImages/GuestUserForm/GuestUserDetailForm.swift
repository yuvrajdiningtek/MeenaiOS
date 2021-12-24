
import UIKit
import Stripe
import IQKeyboardManagerSwift
import SCLAlertView

class GuestUserDetailForm: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var txtfields : [UITextField]!
    @IBOutlet var placeOrderBtn : UIButton!

    var placeOrderModel : PlaceOrderModel!
    var guestPlaceOrderModel : GuestPlaceOrderModel = GuestPlaceOrderModel()
    
    
    let textfieldfilledFirstName = UserDefaults.standard.value(forKey: "textfieldfilledFirstName") as? String ?? ""
    let textfieldfilledLastName = UserDefaults.standard.value(forKey: "textfieldfilledLastName") as? String
    let textfieldfilledPhone = UserDefaults.standard.value(forKey: "textfieldfilledPhone") as? String
    let textfieldfilledEmail = UserDefaults.standard.value(forKey: "textfieldfilledEmail") as? String
    let textfieldfilledAddress1 = UserDefaults.standard.value(forKey: "textfieldfilledAddress1") as? String
    let textfieldfilledCity = UserDefaults.standard.value(forKey: "textfieldfilledCity") as? String
    //  let textfieldfilledState = UserDefaults.standard.value(forKey: "textfieldfilledState") as? String
    let textfieldfilledPostalcode = UserDefaults.standard.value(forKey: "textfieldfilledPostalcode") as? String
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        placeOrderBtn.layer.cornerRadius = 10
        txtfields[0].text = textfieldfilledFirstName
        txtfields[1].text = textfieldfilledLastName
        txtfields[2].text = textfieldfilledPhone
        txtfields[3].text = textfieldfilledEmail
        txtfields[4].text = textfieldfilledAddress1
        txtfields[5].text = textfieldfilledCity
        //txtfields[6].text = textfieldfilledState
        txtfields[7].text = textfieldfilledPostalcode
        
        
        txtfields[0].delegate = self
        txtfields[1].delegate = self
        txtfields[2].delegate = self
        txtfields[7].delegate = self
    }
    
    var countryId: Int?
    @IBAction func doneBtn(_ sender : UIButton){
        if txtfields[6].text == "" {
            Message.showWarningOnStatusBar(msg: "Please Fill all the details")
        }
            
        else if txtfields[2].text!.isValidPhone == false {
            SCLAlertView().showNotice("Phone number should be 10 digit number.")
        }
        else if txtfields[3].text != nil , !isValidEmail(testStr: txtfields[3].text!){SCLAlertView().showNotice("Email is not valid")}
        
        else if txtfields[7].text!.isValidZip == false {
            SCLAlertView().showNotice("Please enter a valid Zip Code.")
        }
       
        
        else {
            self.mapData()
        }
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == txtfields[2]){
            
            saveDataGuest()
            
            
            
            
            let characterCountLimit = 10
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
        }
        if(textField == txtfields[7]){
            
            
            saveDataGuest()
            
            
            
            
            
            
            let characterCountLimit = 5
            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
        }
        if(textField == txtfields[0]){
            
            saveDataGuest()
            
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
            
            
            
        }
        if(textField == txtfields[1]){
            
            saveDataGuest()
            
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
            
            
            
        }
        else {
            showAlert(msg: "Allowed alphabets only", title: "Warning!")
        }
        //         else {
        //            showAlert(msg: "Allowed alphabets only", title: "Warning!")
        //        }
        
        return true
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.view.endEditing(true)
    }
    
    
    @IBAction func country_btnAction(_ sender: Any) {
        saveDataGuest()
        //        countryDropDown.show()
        self.view.endEditing(true)
        let vc = secondSBVC("SelectCountryStateVC") as! SelectCountryStateVC
        countryId = nil
        vc.CS_delegate =  self
        vc.iso = "US"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func statebtnAction(_ sender: Any) {
        saveDataGuest()
        countryId = 254
        //        stateDropDown.show()
        self.view.endEditing(true)
        if countryId != nil{
            let vc = secondSBVC("SelectCountryStateVC") as! SelectCountryStateVC
            vc.CS_delegate =  self
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            Message.showWarningOnStatusBar(msg: "First Select Country")
        }
    }
}
extension GuestUserDetailForm : CountryStateDelegate{
    func selected_country_state(id country: Int?, name Country: String?, Id State: Int?, Name state: String?) {
        
        if country != nil{
            self.countryId = country
            guestPlaceOrderModel.country = country
        }
        txtfields[8].text = Country ?? txtfields[8].text
        
        
        txtfields[6].text = state
        guestPlaceOrderModel.state = State
        guestPlaceOrderModel.state = State
        // UserDefaults.standard.setValue(State, forKey: "stateidd")
    }
    
    func mapData(){
        
        
        guestPlaceOrderModel.firstName = txtfields[0].text
        guestPlaceOrderModel.lastName = txtfields[1].text
        
        guestPlaceOrderModel.mobileNumber = txtfields[2].text
        
        guestPlaceOrderModel.email = txtfields[3].text
        
        guestPlaceOrderModel.address1 = txtfields[4].text
        
        guestPlaceOrderModel.city = txtfields[5].text
        
        guestPlaceOrderModel.postalCode = txtfields[7].text
        
        
        
        let mirror = Mirror(reflecting: guestPlaceOrderModel)
        
        for i in mirror.children{
            
            if i.value is String{
                
                if (i.value as! String) == ""{
                    Message.showWarningOnStatusBar(msg: "Please Fill all the details")
                    return
                }
            }
        }
        
        self.doPayemntOfUser()
        
        
    }
    func textfIsValid(txtf : UITextField)->Bool{
        return !((txtf.text == nil) || (txtf.text == ""))
    }
    
    func doPayemntOfUser(){
        
        
        
        removeGuestUserdefaults()
        
        self.goToCardScreen(delegate: self, amount: getTotalAmount())
    }
    func removeGuestUserdefaults(){
        let idForUserDefaults = "textfieldfilledFirstName"
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: idForUserDefaults)
        userDefaults.synchronize()
        
        let idForUserDefaults2 = "textfieldfilledLastName"
        let userDefaults2 = UserDefaults.standard
        userDefaults2.removeObject(forKey: idForUserDefaults2)
        userDefaults2.synchronize()
        
        let idForUserDefaults3 = "textfieldfilledPhone"
        let userDefaults3 = UserDefaults.standard
        userDefaults3.removeObject(forKey: idForUserDefaults3)
        userDefaults3.synchronize()
        
        let idForUserDefaults4 = "textfieldfilledEmail"
        let userDefaults4 = UserDefaults.standard
        userDefaults4.removeObject(forKey: idForUserDefaults4)
        userDefaults4.synchronize()
        
        let idForUserDefaults5 = "textfieldfilledAddress1"
        let userDefaults5 = UserDefaults.standard
        userDefaults5.removeObject(forKey: idForUserDefaults5)
        userDefaults5.synchronize()
        
        let idForUserDefaults6 = "textfieldfilledCity"
        let userDefaults6 = UserDefaults.standard
        userDefaults6.removeObject(forKey: idForUserDefaults6)
        userDefaults6.synchronize()
        
        let idForUserDefaults7 = "textfieldfilledState"
        let userDefaults7 = UserDefaults.standard
        userDefaults7.removeObject(forKey: idForUserDefaults7)
        userDefaults7.synchronize()
        
        let idForUserDefaults8 = "textfieldfilledPostalcode"
        let userDefaults8 = UserDefaults.standard
        userDefaults8.removeObject(forKey: idForUserDefaults8)
        userDefaults8.synchronize()
    }
    func getTotalAmount()->String{
        if let dbm = DBManager.sharedInstance.get_CartData_DataFromDB().first{
            if let total = (dbm.object?.total_amount){
                return (cleanDollars(String(total)))
            }
        }
        return ""
        
    }
    func processThePayment(){
        let vc = secondSBVC("ProcessingPaymentScreen") as! ProcessingPaymentScreen
        vc.placeOrderModel = placeOrderModel
        vc.guestPlaceOrderModel = guestPlaceOrderModel
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func saveDataGuest(){
        UserDefaults.standard.setValue(txtfields[0].text, forKey: "textfieldfilledFirstName")
        UserDefaults.standard.setValue(txtfields[1].text, forKey: "textfieldfilledLastName")
        UserDefaults.standard.setValue(txtfields[2].text, forKey: "textfieldfilledPhone")
        
        UserDefaults.standard.setValue(txtfields[3].text, forKey: "textfieldfilledEmail")
        UserDefaults.standard.setValue(txtfields[4].text, forKey: "textfieldfilledAddress1")
        UserDefaults.standard.setValue(txtfields[5].text, forKey: "textfieldfilledCity")
        UserDefaults.standard.setValue(txtfields[6].text, forKey: "textfieldfilledState")
        UserDefaults.standard.setValue(txtfields[7].text, forKey: "textfieldfilledPostalcode")
        
    }
}

extension GuestUserDetailForm : STPAddCardViewControllerDelegate{
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        self.view.endEditing(true)
        IQKeyboardManager.shared.enable = true
        self.navigationController?.popViewController(animated: true)
    }
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
        print("stripe token \(token)")
        IQKeyboardManager.shared.enable = true
        self.navigationController?.popViewController(animated: true)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_ID)
        UserDefaults.standard.removeObject(forKey: userdefaultKeys().selected_delivery_method_cost)
        placeOrderModel.cardToken = token.tokenId
        self.processThePayment()
        
    }
    
}
