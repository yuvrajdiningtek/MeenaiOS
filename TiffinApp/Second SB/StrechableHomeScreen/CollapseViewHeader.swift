
import Foundation
import UIKit
import HTHorizontalSelectionList
import Hero
class CollapseViewHeader: UIView {
    
    @IBOutlet weak var contentV : UIView!
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var locationBubble : UIImageView!
    @IBOutlet weak var middleV : UIView!
    @IBOutlet weak var middleVWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var lableLeadingConstraint : NSLayoutConstraint!
    @IBOutlet weak var timeimgLeadingConstraint : NSLayoutConstraint!

    @IBOutlet weak var selectionList : HTHorizontalSelectionList!
    @IBOutlet weak var locationBubbleWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var locatonBubbleyConstraint : NSLayoutConstraint!
    @IBOutlet weak var innerViewTopConstraint : NSLayoutConstraint!

    
    @IBOutlet weak var timingLbl : UILabel!
    @IBOutlet weak var ratingLbl : UILabel!
   
    private var selectionListTitle = [String]()
    private var achievingY : CGFloat{
        return (CollapsablePublicTerms.topSafeAreaMargin ?? 20) + 4
    }
    var selectCategory : ((String,Int)->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        
    }
    func setWidth(constant : CGFloat){
        middleVWidthConstraint.constant = constant
        let leading = (2.5*constant)+16
        lableLeadingConstraint.constant = leading
        timeimgLeadingConstraint.constant = leading
        locationBubbleWidthConstraint.constant = -constant
//        innerViewTopConstraint.constant = CollapsablePublicTerms.topSafeAreaMargin ?? 20
//        locatonBubbleyConstraint.constant = constant1 // between 0-18 value of y goes 0 to -1.5 so for change of one "constant" , y will be (1.5/18) and for x == (1.5/18)*x
        
//        if constant <= 4{
//            locationBubble.alpha = 1
//            return
//        }
//        else if constant >= 17{
//            locationBubble.alpha = 0
//            return
//        }
        let fixwidth = self.frame.width/1.05
        if middleVWidthConstraint.constant == fixwidth{
            locationBubble.alpha = 1
        }else{
            locationBubble.alpha = 0
        }
//        locationBubble.alpha = -(1/constant).magnitude
        
       
    }
}

extension CollapseViewHeader{
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        print("layout change",self.frame.minY)
    }
    func commonInit(){
        
        Bundle.main.loadNibNamed("CollapseViewHeader", owner: self, options: nil)
        addSubview(contentV)
        contentV.frame = self.bounds
        contentV.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.setSelectionView()
        self.setImgView()
        self.setUI()
        
    }
    func setSelectionView(){
        selectionList.delegate = self
        selectionList.dataSource = self
        selectionList.bottomTrimHidden = true
        selectionList.centerOnSelection = false
        selectionList.selectionIndicatorColor = UIColor.MyTheme.marooncolor
        
        selectionList.setTitleFont(UIFont(name: "GlacialIndifference-Regular", size: 16)!, for: .normal)
        selectionList.setTitleColor(UIColor.gray, for: .normal)
        selectionList.setTitleColor(UIColor.MyTheme.marooncolor, for: .selected)
        selectionList.backgroundColor = .clear
        selectionList.buttonInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
        self.setdataSource()
    }
    func setdataSource(){
        
        GetData().getAllProductsList { (_, cat) in
            self.selectionListTitle = cat
            self.selectionList.reloadData()
        }        
    }

    func setUI(){
        self.timingLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.timingLbl.numberOfLines = 0
//        GetData.getTimingOfRestrauntV2 { (_, tupleArr) in
//            self.timingLbl.text = ""
//            for i in tupleArr{
//                self.timingLbl.text?.append(i.0+" "+i.1+"\n")
//                           }
//        }
//        GetData.getTodaysTimingOfRestraunt { (_, str) in
//            if str != nil{
//                self.timingLbl.text = str
//            }
//        }
        
    }

    // MARK : - IMAGE VIEW
    func setImgView(){
        let tapg = UITapGestureRecognizer(target: self, action: #selector(slidingImages))
        imageView.addGestureRecognizer(tapg)
        imageView.hero.id = "galleryImages"
        imageView.isUserInteractionEnabled = true
        
        let arrst = GetData.getImagesFromDataBase()
        if let first = arrst.first{
             let url = URL(string: first.html2String)
                imageView.sd_setImage(with: url, placeholderImage: GlobalVariables.placeholderImg)
            
        }
    }
    
    @objc func slidingImages(_ sender : UITapGestureRecognizer){
        
        let vc = secondSBVC("SlidingDataVC")
        vc.hero.isEnabled = true
//        self.viewContainingController()?.present(vc, animated: true, completion: nil)
        self.viewContainingController()?.navigationController?.pushViewController(vc, animated: true)

    }
}
extension CollapseViewHeader :  HTHorizontalSelectionListDelegate , HTHorizontalSelectionListDataSource{
    func selectionList(_ selectionList: HTHorizontalSelectionList, didSelectButtonWith index: Int) {
        self.selectCategory?(selectionListTitle[index],index)
    }
    
    func numberOfItems(in selectionList: HTHorizontalSelectionList) -> Int {
        return  selectionListTitle.count
    }
    func selectionList(_ selectionList: HTHorizontalSelectionList, titleForItemWith index: Int) -> String? {
        return selectionListTitle[index]
    }
    
}
