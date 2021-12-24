//
//  EventDetailVC.swift
//  TiffinApp
//
//  Created by NMX MacBook on 10/12/19.
//  Copyright © 2019 YAY. All rights reserved.
//

import UIKit

class EventDetailVC: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UITextView!
    @IBOutlet weak var descLbl2: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var shortdateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var eventNamedateView: UIView!
    
    var name = String()
    var descc = String()
    var datee = String()
    var startdate = String()
    var enddate = String()
    var formatdate = String()
    var timee = String()
    var imagge = String()
    var startTime = String()
    var endTime = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.isHidden = true
//        navigationController?.setNavigationBarHidden(true, animated: true)

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM dd,YYYY HH:mm:ss aa"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd \nMMM"
        
        let dateFormatterPrint2 = DateFormatter()
        dateFormatterPrint2.dateFormat = "dd MMM YYYY"
        
        let startTimeFormatter = DateFormatter()
        startTimeFormatter.dateFormat = "HH:mm"
        
        
        if let date = dateFormatterGet.date(from: datee) {
            print(dateFormatterPrint.string(from: date))
            let formatStartdate = dateFormatterPrint.string(from: date)
            let formatStartDate2 = dateFormatterPrint2.string(from: date)
            let formatStartTime = startTimeFormatter.string(from: date)
           dateLbl.text = formatStartDate2
           shortdateLbl.text = formatStartdate
          startTime = formatStartTime
        }
        if let date = dateFormatterGet.date(from: enddate) {
            print(dateFormatterPrint.string(from: date))
          
            let formatEndTime = startTimeFormatter.string(from: date)
           
            endTime = formatEndTime
        }
            
        else {
            print("There was an error decoding the string")
        }
        
        eventNamedateView.layer.cornerRadius = 20
        eventNamedateView.layer.cornerRadius = 20
        eventNamedateView.layer.cornerRadius = 10
        eventNamedateView.layer.borderWidth = 0.7
        eventNamedateView.layer.borderColor = UIColor.lightGray.cgColor
       nameLbl.text = name
       descLbl.text = descc
    descLbl2.text = descc
       timeLbl.text = startTime + " - " + endTime
       let selfstr = imagge
        
        if selfstr == "" {
            mainImageView.image = UIImage(named:"placeholder img")!
            
        } else {
            
            let imageUrl = URL(string: selfstr)
            mainImageView!.sd_setImage(with: imageUrl!, placeholderImage: UIImage(named: "placeholder img"))
            
            
        }
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
