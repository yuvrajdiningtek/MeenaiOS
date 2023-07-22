

import UIKit

extension StrechHomeVC: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,CustomStepperDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("cccccccccccc",categories.count)

        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = productArr[categories[section]]?.count else {
            return 0
        }
        
        print("oooooooooooooo")
        
        
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
        
        //stepperValues.removeAll()
        let productArrCat = productArr[categories[indexPath.section]]!
        let selectedProduct = productArrCat[indexPath.row - 1]
        
        print(selectedProduct,"ssssss",cartproductIDS)
        
        if selectedProduct.available_for_sale == 1{
            cell.addBtn.alpha = 1
            cell.addBtn.setTitle("Add +", for: .normal)
            cell.addBtn.backgroundColor = #colorLiteral(red: 0.9381040543, green: 0.9381040543, blue: 0.9381040543, alpha: 1)
            cell.custom_stepperV.isHidden = true
            cell.addBtn.isHidden = false
            cell.addBtn.setTitleColor(UIColor.init(named: "MaroonTheme"), for: .normal)
            
        
            
            if cartproductIDS.contains(selectedProduct.productId) == false {
               // stepperValues.append("")
            }
            else{
                cell.custom_stepperV.isHidden = false
                cell.addBtn.isHidden = true

//                stepperValues.append(contentsOf: cartitemIDS)
              //  stepperValues.append(selectedProduct.productId)

                print("--------",selectedProduct.productId,stepperValues)
                let qty = cartproductQTY
                
                    for j in 0...cartproductQTY.count - 1{
                        if selectedProduct.productId == cartproductIDS[j]{
                   // cell.addBtn.setTitle("Added \(cartproductQTY[j])", for: .normal)
                    
                            // stepper view
                            cell.custom_stepperV.value = CGFloat(cartproductQTY[j])
                            cell.custom_stepperV.delegate = self
                            cell.custom_stepperV.tag = indexPath.row
                            cell.custom_stepperV.step = 1
//                            cell.custom_stepperV.currentValue_lbl.text = cartitemIDS[j]
//                            cell.custom_stepperV. = cartitemIDS[j]
                            cell.custom_stepperV.contentV.toolbarPlaceholder = cartitemIDS[j]
                            let (min,max) = ProductsDetailViewModel(vc: self).get_stepper_min_max_value()
                            cell.custom_stepperV.minValue = CGFloat(min)
                            cell.custom_stepperV.maxValue = CGFloat(max)
                            
                    }
                    }
                
             //   cell.addBtn.setTitle("Added \(qty[indexPath.row - 1])", for: .normal)
             //   cell.addBtn.backgroundColor = #colorLiteral(red: 0.000837795319, green: 0.6709827241, blue: 0.00129979241, alpha: 1)
                cell.addBtn.setTitleColor(.white, for: .normal)

            }
            
        }
        else{
            cell.custom_stepperV.isHidden = true
            cell.addBtn.isHidden = false

            cell.addBtn.alpha = 0.4
            cell.addBtn.setTitle("Add +", for: .normal)
            cell.addBtn.backgroundColor = #colorLiteral(red: 0.9381040543, green: 0.9381040543, blue: 0.9381040543, alpha: 1)
            cell.addBtn.setTitleColor(UIColor.init(named: "MaroonTheme"), for: .normal)

        }
        let key = categories[indexPath.section]
        cell.dataSet = productArr[key]?[indexPath.row-1]
        cell.categoryLbl.text = categories[indexPath.section]
        return cell

    }
    func valueDidChange(current value: CGFloat, sender: CustomStepper, increment: Bool, decrement: Bool) {
        sender.isUserInteractionEnabled = true
        
        
    
    //productArr[categories[section]]?.count
//        print("YESSSSSQQQQQ",self.items[sender.tag].item_id,value,items.count,sender.tag)

//        if sender.tag
        
      //  if sender.tag < cartproductIDS.count || sender.tag == cartproductIDS.count - 1{
          //  hideactivityIndicator(activityIndicator: activityIndicator)
          //  print("YESSSSSQQQQQ",self.productArr[categories[0]]?[sender.tag].productId ?? "",value,self.productArr[categories[0]]?.count,sender.tag)
       // print("steee",stepperValues[8],value,sender.tag,stepperValues.count,"----",sender.contentV.toolbarPlaceholder)
        present_action_sheet(itemid: sender.contentV.toolbarPlaceholder ?? "", qty: String(describing: value)) { (update) in
                if !update{
                    if increment{
                        sender.value = value - 1
                        
                    }else if decrement{
                        sender.value = value + 1
                    }
                    
                }else{
                    
                    try? DBManager.sharedInstance.database.write {
                        if self.stepperValues.count != 0{
                        self.items[sender.tag].qty = Double(value)
                        }
                        print("yess")
                    }
                    
                    self.collectionView.reloadItems(at: [IndexPath(row:sender.tag,section:0)])
                }
            }
//        }
//        else{
//            sender.isUserInteractionEnabled = false
////            let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
////            self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
////            activityIndicator.startAnimating()
////            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////                hideactivityIndicator(activityIndicator: activityIndicator)
////            }
//        }
        
    }
    func present_action_sheet(itemid:String,qty:String,callback:@escaping ((Bool)->())){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        print("YESSSSSSSSSAAAAA",itemid,qty)
        let update_action = UIAlertAction(title: "Update item", style: .default) { (_) in
            self.submitThe_qty(bucketItemId: itemid, quantity: qty, completion: {
                (success) in
                if success{
                    callback(true)
                }else{
                    callback(false)
                }
            })
            
        }
        
        
        let cancle_action = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            callback(false)
        }
        actionSheet.view.tintColor = UIColor.MyTheme.marooncolor
        actionSheet.addAction(update_action)
        actionSheet.addAction(cancle_action)
        
        
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = self.view //to set the source of your alert
            
            
            //            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0) // you can set this as per your requirement.
            popoverController.permittedArrowDirections = [] //to hide the arrow of any particular direction
          //  popoverController.sourceRect = chkOutBtn.frame
        }
        
        self.present(actionSheet, animated: true) {
            
        }
        
    }
    func submitThe_qty(bucketItemId: String , quantity: String, completion: @escaping (Bool)->()){
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        print("YESSSSSSSSS")
        SubmissionAPIs.update_quantity_of_product(bucketItemId: bucketItemId, quantity: quantity) { (success, _) in
            
            hideactivityIndicator(activityIndicator: activityIndicator)
            if success{
                
                self.getAlOredrs(completion: {(_, _) in
                    completion(true)
                })
                
                
            }else{
            //    SCLAlertView().showError("some error occured")
                completion(false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row != 0{
            let productArrCat = productArr[categories[indexPath.section]]!
            let selectedProduct = productArrCat[indexPath.row - 1]

            print("\n\n\n\n\nn\\n\nn\\n",selectedProduct,"\n\n\n\\n\n\n\\n\n\\n",cartproductIDS.count)
//            if orderData.object != nil{
//
//          if orderData.object?.items.count != 0{
//            for i in 0...(((self.orderData.object?.items.count)!)) - 1{
//                cartproductIDS.append((self.orderData.object?.items[i].product_id)!)
//          }
//          }
//            }
        
            if selectedProduct.available_for_sale == 1{
            
//                if cartproductIDS.contains(selectedProduct.productId) == false{
                
            let vc = secondSBVC("ProductsDetailVC") as! ProductsDetailVC
        
    
            vc.productsArr = productArr[categories[indexPath.section]]!
            vc.selectedProduct = productArrCat[indexPath.row - 1]
            vc.selected_cell_index  = IndexPath(row: indexPath.row-1, section: 0)
            print("iiiiii",IndexPath(row: indexPath.row-1, section: 0),"iiiiii")
            vc.navigationController?.hero.isEnabled = true
            self.present(vc, animated: true)
//                }
//                else{
//                    Message.showErrorMessage(style: .bottom, message: "This item already exists in your cart", title: "")
//
//                }
//            self.navigationController?.pushViewController(vc, animated: true)
            }
            else{
                 Message.showErrorMessage(style: .bottom, message: "Out of Stock", title: "")

            }
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
        let h  : CGFloat = 160
        if indexPath.row == 0{
            return CGSize(width: collectionView.frame.width, height: 40)
        }
        return CGSize(width: collectionView.frame.width, height: h)
    }
    func setcollectionViewiewDataSet(){
        GetData().getAllProductsList { (allProd, categories) in
            self.productArr = allProd
            self.categories = categories
            print(allProd.count,categories.count,"llllllllllllll")

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
