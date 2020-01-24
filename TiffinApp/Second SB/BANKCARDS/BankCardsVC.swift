

import UIKit
import SCLAlertView

class BankCardsVC: UIViewController {

    @IBOutlet weak var tableV :  UITableView!
    var tvdataSource : [ObjectBankCardModel] = [ObjectBankCardModel](){
        didSet{
            
            self.tableV.isHidden = (tvdataSource.count == 0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateTableView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "PAYMENT METHODS"
    }
    func populateTableView (){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        RegisterApi.getBankCards { (succ, rst) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            let data  = DBManager.sharedInstance.database.objects(BankCards.self)
            if data.count>0{
                let obj = data[0].object
                self.tvdataSource = Array(obj)
                self.tableV.reloadData()
            }
        }
    }
    @IBAction func menuBtn(_ sender: Any) {
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
    }
    @IBAction func plusBtn(_ sender: Any) {
        
        let vc = secondSBVC("AddNewCardVC") as! AddNewCardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BankCardsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvdataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("HomeTVC", owner: self, options: nil)?[9] as! BankCardViewTVC
        cell.dataSource = tvdataSource[indexPath.row]
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let alertView = SCLAlertView()
            alertView.addButton("DELETE"){
                self.deleteCard(index: indexPath.row)
            }
            
            alertView.showWarning("Confirmation", subTitle: "Are you sure you want to delete this card?",closeButtonTitle: "CANCEL")
        }
    }
    func deleteCard(index : Int){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        RegisterApi.deleteBankCard(card_id: tvdataSource[index].cardId) { (succ, _, err) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            if succ{                
                
                try! DBManager.sharedInstance.database.write {
                    let obj = self.tvdataSource[index]
                    self.tvdataSource.remove(at: index)
                    self.tableV.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableView.RowAnimation.automatic)

                    DBManager.sharedInstance.database.delete(obj)
                }
//                self.tvdataSource.remove(at: index)
                
//                self.tableV.reloadData()
//                self.populateTableView()
                
            }else{
                SCLAlertView().showError(err ?? "server error")
            }
        }
    }
}
