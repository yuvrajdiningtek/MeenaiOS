

import UIKit

extension StrechHomeVC: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = productArr[categories[section]]?.count else {
            return 0
        }
        
        return (count + 1)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sectionCell", for: indexPath)
            let lbl = cell.viewWithTag(1) as! UILabel
            lbl.text = categories[indexPath.section]
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC", for: indexPath)  as! HomeCVC
        let key = categories[indexPath.section]
        cell.dataSet = productArr[key]?[indexPath.row-1]
        cell.categoryLbl.text = categories[indexPath.section]
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            let vc = secondSBVC("ProductsDetailVC") as! ProductsDetailVC
            let productArrCat = productArr[categories[indexPath.section]]!
            
            vc.productsArr = productArr[categories[indexPath.section]]!
            vc.selectedProduct = productArrCat[indexPath.row - 1]
            vc.selected_cell_index  = IndexPath(row: indexPath.row-1, section: 0)
            print("iiiiii",IndexPath(row: indexPath.row-1, section: 0),"iiiiii")
            vc.navigationController?.hero.isEnabled = true
            self.present(vc, animated: true)
//            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let yy = collectionView.bounds.width / 2.2
//        let yh = yy * 1.2
//
//        return CGSize(width: yy, height: yh)
        let w = collectionView.frame.width/2 - 0
        let h  : CGFloat = 150
        if indexPath.row == 0{
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        return CGSize(width: collectionView.frame.width, height: h)
    }
    func setcollectionViewiewDataSet(){
        GetData().getAllProductsList { (allProd, categories) in
            self.productArr = allProd
            self.categories = categories
            self.collectionView.reloadData()
        }
    }
   
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if collapseCntrl != nil{
            collapseCntrl.scrollViewDidScroll(scrollView)
        }
        
        

        // following code not working
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
//        let visiblePoint = CGPoint(x: visibleRect.midX-50, y: visibleRect.midY-(CollapsablePublicTerms().hederViewHeight))
        let visiblePoint = CGPoint(x: visibleRect.midX-50, y: (visibleRect.minY+CollapsablePublicTerms().hederViewHeight))
        
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        
        self.selecttitleIndex = indexPath.section
    }
    
}
