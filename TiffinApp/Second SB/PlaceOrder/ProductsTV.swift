
import Foundation
import UIKit
import Alamofire
import SCLAlertView

class ProductsTV : UITableView , UITableViewDelegate, UITableViewDataSource{
    var viewController = UIViewController()
    var tvdataSource = [ItemsObjectOrdersData](){
        didSet{
            self.reloadData()
        }
    }
    @objc func
        deleteitemBtn(at index:Int){
        
        print("items", tvdataSource)
        if index >= tvdataSource.count{
            return
        }
        if tvdataSource.count == 1{
            deleteWholeCart()
            return
        }
        let itemid = tvdataSource[index].item_id
        
        let activityIndicator = loader(at: self.viewController.view, active: .circleStrokeSpin)
        self.viewController.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        print("deleteitemBtn press")
        
        ProductsApi.delete_item_from_cart(item_id: itemid) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            print("deleteitemBtn api response")
            if success{
                
                let obj = self.tvdataSource.remove(at: index)
              
                
                print("obj is ", obj)
                
            }
            else{
                if result == nil{
                    SCLAlertView().showError("error", subTitle: "") // Error
                }else{
                    SCLAlertView().showError("error", subTitle: "") // Error
                }
            }
            print("all object", self.tvdataSource)
            self.visibilityThings()
        }
    }
    
    
    func deleteWholeCart(){
        let activityIndicator = loader(at: self.viewController.view, active: .circleStrokeSpin)
        self.viewController.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        ProductsApi.delete_cart { (success, result) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                self.tvdataSource.removeAll()
                DBManager.sharedInstance.deleteBucketId()
                ProductsApi.detail_Cart_Info(callback: { (_, _,_) in
                    
                })
            }
            else{
                SCLAlertView().showError("error", subTitle: "") // Error
            }
            self.visibilityThings()
        }
    }
    func visibilityThings(){
        if self.tvdataSource.count == 0{
            self.viewController.navigationController?.popViewController(animated: true)
        }
        if self.tvdataSource.count != 0{
          
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvdataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CheckOutTVC
        cell.datasource = tvdataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let Manually = UITableViewRowAction(style: .default, title: "Delete") { (action:UITableViewRowAction, indexPath:IndexPath) in
            print("Manually at:\(indexPath)")
            
            let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "YES", style: .destructive) { (action:UIAlertAction) in
                self.deleteitemBtn(at: indexPath.row)
            }
            
            let action2 = UIAlertAction(title: "NO", style: .cancel) { (action:UIAlertAction) in
                
            }
            alertController.addAction(action1)
            alertController.addAction(action2)
            self.viewController.present(alertController, animated: true, completion: nil)
            
        }
        Manually.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        
        return [Manually]
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commoninit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commoninit()
    }
    func commoninit(){
        self.delegate = self
        self.dataSource = self
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewContainingController()?.updateViewConstraints()
    }
}
