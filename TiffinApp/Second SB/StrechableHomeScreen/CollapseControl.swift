
import Foundation
import UIKit

protocol CollapseControlDelegate {
    func collapseFully()
    func strechProportionally()
}

class CollapseControl: NSObject  {
    
    var tableView : UITableView!
    var collapseV : CollapseViewHeader!
    var delegate : CollapseControlDelegate?
    private var widthconstraint : NSLayoutConstraint!
    
    
    private var intialWidthOfMiddleView : CGFloat = 0
    private var acheiveWidthOFMV : CGFloat = 0
    private var headerViewHeight : CGFloat = 0
    private var imgV : UIImageView!
    private let cpt = CollapsablePublicTerms()
    
     init(tableview : UITableView, collapseV :CollapseViewHeader ) {
        self.tableView = tableview
        self.collapseV = collapseV
    }
    init( collapseV :CollapseViewHeader ) {
        
        self.collapseV = collapseV
    }
    func setUp(frame : CGRect){
        
        headerViewHeight = cpt.hederViewHeight
        intialWidthOfMiddleView = (frame.width/1.05)
        acheiveWidthOFMV = (frame.width)
        widthconstraint = collapseV.middleVWidthConstraint
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let fixHeight : CGFloat = CGFloat(headerViewHeight)/2.5
        let maxH =  headerViewHeight
        let y =  -(scrollView.contentOffset.y)
        let height = min(max(y, fixHeight), 400)
        
        if collapseV == nil{return}
        if height == fixHeight{
            delegate?.collapseFully()
        }
        if height <= (headerViewHeight) , height >= fixHeight{
            
            let top = CollapsablePublicTerms.topSafeAreaMargin ?? 20
            let yToset = height-headerViewHeight
            if yToset == collapseV.frame.minY || yToset > -top{
                if yToset == collapseV.frame.minY{
                }
                return
            }
            // if remove this line then selection list scroll automatically with table view scrolling
            let mainScreenWidth = UIScreen.main.bounds.size.width
            collapseV.frame = CGRect(x: 0, y: yToset, width: mainScreenWidth, height: headerViewHeight)
            
            let offset = ((scrollView.contentOffset.y) + maxH)
            let diffInWidth = (acheiveWidthOFMV - intialWidthOfMiddleView)
            let x = (offset * diffInWidth)/(headerViewHeight-(fixHeight))
            
            if x.isFinite{
                collapseV.setWidth(constant: x)
            }
            delegate?.strechProportionally()
        }
        else {
            let top = CollapsablePublicTerms.topSafeAreaMargin ?? 20
            collapseV.frame = CGRect(x: 0, y: -top, width: UIScreen.main.bounds.size.width, height: height)
        }
        
    }
    
}
