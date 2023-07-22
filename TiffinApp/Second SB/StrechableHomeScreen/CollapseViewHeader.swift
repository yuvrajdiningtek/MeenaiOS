
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
    @IBOutlet weak var ratingView : UIView!

    @IBOutlet weak var timingImg : UIImageView!

    @IBOutlet weak var timingLbl : UILabel!
    @IBOutlet weak var ratingLbl : UILabel!
    @IBOutlet weak var futureOrderDate : UIButton!
    @IBOutlet weak var futureOrderUnderLineLbl : UILabel!

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
//        lableLeadingConstraint.constant = leading
//        timeimgLeadingConstraint.constant = leading
//        locationBubbleWidthConstraint.constant = -constant * 2
//        innerViewTopConstraint.constant = CollapsablePublicTerms.topSafeAreaMargin ?? 20
      //  locatonBubbleyConstraint.constant = constant1 // between 0-18 value of y goes 0 to -1.5 so for change of one "constant" , y will be (1.5/18) and for x == (1.5/18)*x
        
        if constant <= 4 {
print("locationBubble.alpha = 1")
            locationBubble.alpha = 1
            return
        }
        else if constant >= 17{
            print("locationBubble.alpha = 0")

            locationBubble.alpha = 0
            ratingView.isHidden = true
            timingImg.isHidden = true
            timingLbl.isHidden = true
            futureOrderDate.isHidden = true
            futureOrderUnderLineLbl.isHidden = true
            return
        }
        let fixwidth = self.frame.width/1.05
        if middleVWidthConstraint.constant == fixwidth{
            locationBubble.alpha = 1
            print("locationBubble.alpha = 1")

        }else{
            locationBubble.alpha = 1
            print("locationBubble.alpha = 2")
            ratingView.isHidden = false
            timingImg.isHidden = false
            timingLbl.isHidden = false
            let ENABLE_ORDER_AHEAD = UserDefaults.standard.value(forKey: "ENABLE_ORDER_AHEAD") as? Bool
            if ENABLE_ORDER_AHEAD == true{
          futureOrderDate.isHidden = false
          futureOrderUnderLineLbl.isHidden = false
            }


        }
//        locationBubble.alpha = -(1/constant).magnitude
        
       
    }
}

extension CollapseViewHeader{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("jjjjjjjjjj")
        
        let selectedDate = UserDefaults.standard.value(forKey: "selectedDate") as? String ?? ""
        let selectedTime = UserDefaults.standard.value(forKey: "selectedTime") as? String ?? ""
        if selectedTime != ""{
            futureOrderDate.setTitle("Selected Future Date/Time: \(selectedDate) \(selectedTime)", for: .normal)
        }
//        print("layout change",self.frame.minY)
    }
    
    func commonInit(){
        
        Bundle.main.loadNibNamed("CollapseViewHeader", owner: self, options: nil)
        addSubview(contentV)
        contentV.frame = self.bounds
        contentV.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        ratingView.layer.cornerRadius = 10
        self.setSelectionView()
        self.setImgView()
        self.setUI()
        
    }
    func setSelectionView(){
        selectionList.delegate = self
        selectionList.dataSource = self
        selectionList.bottomTrimHidden = true
        selectionList.centerOnSelection = false
//        selectionList.selectionIndicatorColor = #colorLiteral(red: 0.3220071793, green: 0.689510107, blue: 0.5461614132, alpha: 1) //UIColor.MyTheme.marooncolor
        selectionList.selectionIndicatorColor = UIColor.MyTheme.marooncolor
        
        selectionList.setTitleFont(UIFont(name: "GlacialIndifference-Regular", size: 16)!, for: .normal)
        selectionList.setTitleColor(UIColor.darkGray, for: .normal)
        selectionList.setTitleColor(UIColor.MyTheme.marooncolor, for: .selected)
//        selectionList.setTitleColor(#colorLiteral(red: 0.3220071793, green: 0.689510107, blue: 0.5461614132, alpha: 1), for: .selected)
        selectionList.layer.cornerRadius = 10
        selectionList.layer.borderColor = UIColor.MyTheme.marooncolor.cgColor
        selectionList.layer.borderWidth = 1

//        selectionList.backgroundColor = UIColor.red
//        selectionList.backgroundColor = UIColor(white: 1, alpha: 0.8)

//        selectionList.backgroundColor = #colorLiteral(red: 0.9521297812, green: 0.9807785153, blue: 0.9683462977, alpha: 1)
        selectionList.backgroundColor = #colorLiteral(red: 0.9521297812, green: 0.9807785153, blue: 0.9683462977, alpha: 1)

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
        
        let selectedDate = UserDefaults.standard.value(forKey: "selectedDate") as? String ?? ""
        let selectedTime = UserDefaults.standard.value(forKey: "selectedTime") as? String ?? ""
        if selectedTime != ""{
            futureOrderDate.setTitle("Selected Future Date/Time: \(selectedDate) \(selectedTime)", for: .normal)
        
        }
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
