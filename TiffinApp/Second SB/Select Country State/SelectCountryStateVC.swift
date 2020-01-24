

import UIKit

protocol CountryStateDelegate {
    var countryId : Int? { get set}
    func selected_country_state( id country: Int?, name Country: String?,  Id State : Int?,  Name state:String?)
}



class SelectCountryStateVC: UIViewController , UISearchBarDelegate{

    
    @IBOutlet weak var table_v: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!

    
    var tableData = [(Int,String)]()
    
    var countryId = ""
    var iso : String?
    var CS_delegate : CountryStateDelegate?
    var filtered_data = [(Int,String)]() // id,name
    var issearching = false
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        searchbar.showsCancelButton = true
        
        for ob: UIView in ((searchbar.subviews[0] )).subviews {
            
            if let z = ob as? UIButton {
                let btn: UIButton = z
                btn.setTitleColor(UIColor.white, for: .normal)
                
            }
        }
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)
        
        
        if CS_delegate?.countryId == nil{
            getCountry()
        }else{
            getState(country: String((CS_delegate?.countryId!)!), completion: {
                self.table_v.reloadData()
            })
        }
    }
    
    
    
    func getCountry(){
        
        if DBManager.sharedInstance.get_countries_DataFromDB().count != 0{
            let CM = DBManager.sharedInstance.get_countries_DataFromDB()[0] as CountryModel
            let data = CM.data
            for d in data{
                var onedata : (Int,String)
                let id = d.id
                let name = d.name
                onedata = (id,name)
                if self.iso != nil{
                    if d.iso.lowercased() == self.iso!.lowercased(){
                        tableData.append(onedata)
                    }
                }
                else{
                    tableData.append(onedata)
                }
                
            }
            self.filtered_data = self.tableData
        }
        else{
            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            SomeInformationApi.get_country { (success, result) in
                hideactivityIndicator(activityIndicator: activityIndicator)
                if success{
                    if let data = (result as! NSDictionary).value(forKey: "data") as? [NSDictionary]{
                        for d in data{
                            var onedata : (Int,String)
                            let id = d.value(forKey: "id") as? Int ?? 0
                            let name = d.value(forKey: "name") as? String ?? ""
                            let iso = d.value(forKey: "iso") as? String ?? ""
                            onedata = (id,name)
                            if self.iso != nil{
                                if iso.lowercased() == self.iso!.lowercased(){
                                    self.tableData.append(onedata)
                                }
                            }
                            else{
                                self.tableData.append(onedata)
                            }
                        }
                    }
                    self.filtered_data = self.tableData
                    self.table_v.reloadData()
                }
                else{
                    if result == nil{
                        
                    }else{
                        
                    }
                }
            }
        }
    }
    
    func getState(country id:String, completion : @escaping ()->()){
        
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        SomeInformationApi.get_state(countryid: id) { (success, result) in
            hideactivityIndicator(activityIndicator: activityIndicator)
            
            if success{
                if let data = (result as! NSDictionary).value(forKey: "data") as? [NSDictionary]{
                    for d in data{
                        var onedata : (Int,String)
                        let id = d.value(forKey: "id") as? Int ?? 0
                        
                        let name = d.value(forKey: "name") as? String ?? ""
                        onedata = (id,name)
                        self.tableData.append(onedata)
                    }
                    self.filtered_data = self.tableData
                    completion()
                }
            }else{
                if result == nil{
                    
                }else{
                    
                }
                completion()
            }
        }
    }
    //********************************* MARK: - search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text == ""{
            issearching = false
            
            tableData = filtered_data
            
        }else{
            
            issearching = true
//            filteredData = lottoGetArray.filter({( lottryParameters: lottryParameters ) -> Bool in
//                return lottryParameters.draw_lottoname.lowercased().contains(searchBar.text!.lowercased())
//            })
            tableData = filtered_data.filter({ (id,name) -> Bool in
                if name.lowercased().contains(searchBar.text!.lowercased()){
                    return true
                }
                return false
            })
            
        }
        self.table_v.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        view.endEditing(true)
    }
    
}

extension SelectCountryStateVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].1
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = tableData[indexPath.row].0
        let name = tableData[indexPath.row].1
        if CS_delegate?.countryId == nil{
            CS_delegate?.selected_country_state(id: id, name: name, Id: nil, Name: nil)
        }
        else{
            CS_delegate?.selected_country_state(id: nil, name: nil, Id: id, Name: name)
        }
        
        navigationController?.popViewController(animated: true)
        
    }
}


