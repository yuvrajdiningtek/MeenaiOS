// https://www.sitepoint.com/self-sizing-cells-uitableview-auto-layout/

import UIKit
protocol SelectedVariationsDelegate {
    
    func selectedvariation(variationId : String,variationKey : String,variationname:String ,variationPrice : Double)
    func selectedAddOns (addOns : [AddOnForAddToCart])
    // if user apply the adon and then go to back screen and agaain come back to adon screen then the previous selected adons will be display
    func alreadySelectedAdons()->[AddOnForAddToCart]?
   // func selectedvariation(variationId : String,variationKey : String,variationname:String ,variationPrice : Double)
}

class VariationsVC: UIViewController {

    @IBOutlet weak var table_v : UITableView!
    @IBOutlet weak var header_lbl : UILabel!
    @IBAction func backBtnn(_ sender: Any) {
        dismiss(animated: true) {
            
        }
    }
    
    var productIDis = "e62b7119c5738d5799d11425ba22a48e"
    var product : Products?
    var delegate : SelectedVariationsDelegate?
    var tableData : [[(String,String,String,Double)]] = [[(String,String,String,Double)]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if DBManager.sharedInstance.database.objects(Products.self).filter("productId == %a",productIDis).count > 0{
            product = DBManager.sharedInstance.database.objects(Products.self).filter("productId == %a",productIDis) [0]
            self.title = product?.name.uppercased()
            self.header_lbl.text = product?.name.uppercased()
        }
        self.addtabledata()
        
        self.table_v.rowHeight = UITableView.automaticDimension
        self.table_v.estimatedRowHeight = 50; //Set this to any value that works for you.
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)

    }
    func addtabledata(){
        guard let product = product else{return }
        for i in product.variations{
            var d : (String,String,String,Double) = ("","","",0.0)
            guard let varianceAttribute = i.varianceAttribute else{return }
            guard let Group = varianceAttribute.Group else{return }
            let cat = Group.Category
            var ds = [(String,String,String,Double)]()
            for j in cat{
                let key = j.category_key
                var value = j.value.first ?? ""
                // assuming only one value in array
                for i in 0..<j.value.count{
                    if i > 0{
                        let v = j.value[i]
                        value.append(" "+v+",")
                    }
                    
                }
                d = (i.productVariationId,key,value,i.price)
                ds.append(d)
            }
            tableData.append(ds)
        }
        
    }
   
}


extension VariationsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VariationsTVC
        
        
        
        guard let product = product else{return cell}

        guard let varianceAttribute = product.variations[indexPath.row].varianceAttribute else{return cell}
        guard let _ = varianceAttribute.Group else{return cell}
        
        let intialv = 0
        cell.variation_lbl.text = ""
        
        var str = ""
        for i in tableData[indexPath.row]{
            let a =  i.1 + " : " + i.2 + "\n"
            str.append(a)
        }
        
        cell.variation_lbl.text = str
        
        let price = String(describing: (product.variations[indexPath.row].price))
        cell.price_lbl?.text = cleanDollars(price)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let product = product else{return}
        let variationid = product.variations[indexPath.row].productVariationId
        let price = product.variations[indexPath.row].price
        let name = product.variations[indexPath.row].name
        
        let data = tableData[indexPath.row]
        var str = ""
        for i in data{
        
            str.append(i.1 + " : " + i.2)
            str.append("\n")
        }
        
        delegate?.selectedvariation(variationId: variationid, variationKey: tableData[indexPath.row].first!.1, variationname: str, variationPrice: price)
        
        
        self.dismiss(animated: true) {
            
        }
    }
}

class VariationsTVC : UITableViewCell{
    
    @IBOutlet weak var variation_lbl : UILabel!
    @IBOutlet weak var price_lbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
