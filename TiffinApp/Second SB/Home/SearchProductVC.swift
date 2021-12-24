
import UIKit

class SearchProductVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.set_allData()
        self.customizeSearchBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        let nib = UINib(nibName: "CollectionVXibs", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "HomeCVC")
    }
    
    var filteredItems : [Products] = [Products]()
    var allData : [Products] = [Products]()
}


extension SearchProductVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath)  as! HomeCVC
        cell.dataSet = filteredItems[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = secondSBVC("ProductsDetailVC") as! ProductsDetailVC
        self.view.endEditing(true)
        vc.productsArr = [filteredItems[indexPath.row]]
        if let nv = presentingViewController as? UINavigationController{
            vc.navigationController?.hero.isEnabled = true
            vc.selected_cell_index = IndexPath(row: 0, section: 0)
            
            nv.pushViewController(vc, animated: true)
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = collectionView.frame.width/2 - 10
        let h  : CGFloat = 200
        
        return CGSize(width: collectionView.frame.width, height: h)
    }
}


extension SearchProductVC : UISearchBarDelegate{
    func set_allData(){
        let ds = DBManager.sharedInstance.get_productCat_DataFromDB().first
        guard let data = ds?.data else {
            return
        }
        allData.removeAll()
        for i in data{
            let products = Array(i.products)
            allData = allData + products
        }
    }
    func customizeSearchBar(){
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)
//        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
//        textFieldInsideSearchBar?.textColor = UIColor.black
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredItems.removeAll()
        searchBar.endEditing(true)
        self.collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.filteredItems.removeAll()
        }else{
            self.view.backgroundColor = UIColor.white
            self.filteredItems = self.allData.filter { (product) -> Bool in
                return product.name.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView.reloadData()
    }
}
