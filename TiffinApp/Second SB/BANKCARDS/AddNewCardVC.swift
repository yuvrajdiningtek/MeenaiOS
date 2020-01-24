// https://stripe.github.io/stripe-ios/docs/Classes/STPPaymentCardTextField.html
// https://github.com/stripe/stripe-ios/issues/498
import UIKit
import Stripe
import CreditCardForm
import SCLAlertView

class AddNewCardVC: UIViewController {

    @IBOutlet weak var cardView : CreditCardFormView!
    @IBOutlet weak var paymentTextField : STPPaymentCardTextField!
    @IBOutlet weak var dropDownbtn : DropDownBtn!
    let cardtype = ["CREDIT","DEBIT"]
    var confirmBtn : (()->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserName { (succ) in
            if succ{
                self.setUpSTPPaymentCardTextField()
            }
            else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
       self.title = "ADD CARD"
        setDropDown()
       
        
    }
    
    @IBAction func segmentContrl(_ sender : UISegmentedControl){
        
        cardType = cardtype[sender.selectedSegmentIndex]
    }
    
    
    var Cardname : String?
    var Cardnumber : String?
    var CardexpYear : String?
    var CardexpMonth : String?
    var Cardcvv : String?
    var cardType : String? 
    
    @IBAction func addCard(_ sender : UIButton){
        
//        self.navigationController?.popViewController(animated: true)
//        if let a = confirmBtn{
//            a()
//        }
        
        if paymentTextField.isValid{
            getParam()
            if cardType == nil{
                SCLAlertView().showError("add Card Type")
                return
            }
            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
            self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            RegisterApi.addBankCard(cardname: Cardname!, cardNumber: Cardnumber!, cardExpYear: CardexpYear!, cardExpMonth: CardexpMonth!, CardCvv: Cardcvv!, cardType: cardType!) { (succ, rst,err) in
                
                hideactivityIndicator(activityIndicator: activityIndicator)
                 if !succ{
                    if err  != nil{
                        SCLAlertView().showError(err!)
                    }else{
                        SCLAlertView().showError("some error occured")
                    }
                    
                 }else{
                    SCLAlertView().showSuccess("card successfully added")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            SCLAlertView().showError("Card is not valid")
        }
        
    }
    func getUserName(completion:((Bool)->())? = nil){
        func getNameFromDB()->Bool{
            let userdetail = DBManager.sharedInstance.get_userInfo_DataFromDB()
            if userdetail.count != 0{
                self.Cardname = userdetail[0].object?.firstName.uppercased()
                if self.Cardname == nil{
                    
                    return false}
                
                return true
            }
            
            return false
        }
        
        if !getNameFromDB() {
            SomeInformationApi.get_user_info { (_, _) in
                if getNameFromDB(){
                    completion?(true)
                    return
                }
               completion?(false)
            }
        }
        else{
            completion?(true)
        }
    }
    func getParam(){
        Cardnumber = paymentTextField.cardNumber
        CardexpYear = "20" + paymentTextField.formattedExpirationYear!
        CardexpMonth = paymentTextField.formattedExpirationMonth
        Cardcvv = paymentTextField.cvc
        
    }
    func setDropDown(){
        let array = ["CREDIT", "DEBIT"]
        
        dropDownbtn.dataSource = array
        dropDownbtn.dropDownAction = {
            (str,index) in
            self.cardType = str
            self.dropDownbtn.setTitle(str, for: .normal)
        }
        
    }

}
extension AddNewCardVC : STPPaymentCardTextFieldDelegate {
    func setUpSTPPaymentCardTextField(){
        paymentTextField.borderWidth = 0
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: paymentTextField.frame.size.height - width, width:  paymentTextField     .frame.size.width, height: paymentTextField.frame.size.height)
        border.borderWidth = width
        paymentTextField.layer.addSublayer(border)
        paymentTextField.layer.masksToBounds = true
        
        
        paymentTextField.delegate = self
        cardView.cardHolderString = Cardname!
        
        
        
    }
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidChange(cardNumber: textField.cardNumber, expirationYear: textField.expirationYear, expirationMonth: textField.expirationMonth, cvc: textField.cvc)
    }
    
    func paymentCardTextFieldDidEndEditingExpiration(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingExpiration(expirationYear: textField.expirationYear)
    }
    
    func paymentCardTextFieldDidBeginEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidBeginEditingCVC()
    }
    
    func paymentCardTextFieldDidEndEditingCVC(_ textField: STPPaymentCardTextField) {
        cardView.paymentCardTextFieldDidEndEditingCVC()
    }
}
