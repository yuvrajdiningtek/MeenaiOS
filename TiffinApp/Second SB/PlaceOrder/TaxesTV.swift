
import Foundation
import UIKit


class TaxesTV : UITableView , UITableViewDelegate, UITableViewDataSource{
    var dataset : ObjectCartData?{
        didSet{
            if dataset != nil{
                setDataSource(data: dataset!)
            }
        }
    }
    var numberOfRows : Int{
        return tvdataSource.count
    }
    private var tvdataSource = [(String,String)](){
        didSet{
            self.reloadData()
        }
    }
    func setDataSource (data : ObjectCartData){
        
        
        var ds = [(String,String)]()
        
        let taxes = Array(data.taxes)
        for i in taxes{
            let key = i.name
            let value =  cleanDollars(String(describing: i.amount))
            ds.append((key,value))
        }
//        var key = "Delivery Fee"
//        var value = cleanDollars(String(describing: data.shippment_price))
//        ds.append((key,value))
//
//        key = "Shippment Tax"
//        value = cleanDollars(String(describing: data.shippment_tax))
//        ds.append((key,value))
        self.tvdataSource = ds
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvdataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_for_feetable", for: indexPath) as! Taxes_TVC
        cell.dataSet = tvdataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
    
}

