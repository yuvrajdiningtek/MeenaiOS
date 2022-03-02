//
//  OrderAheadCalenderVC.swift
//  TiffinApp
//
//  Created by NMX MacBook on 16/02/22.
//  Copyright © 2022 YAY. All rights reserved.
//

import UIKit
import FSCalendar
import SCLAlertView
import DropDown

class OrderAheadCalenderVC: UIViewController,FSCalendarDelegateAppearance ,FSCalendarDelegate,FSCalendarDataSource{

    let ORDER_AHEAD_DAYS = UserDefaults.standard.value(forKey: "ORDER_AHEAD_DAYS") as? [String]
    
    var minTimeFinal = String()
    var maxTimeFinal = String()
    
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var timeBtnText: UIButton!

    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var countLbl: UILabel!

    @IBOutlet weak var datesTv: UITextView!
//    @IBOutlet weak var selectDstePicker: UIDatePicker!
    var startTime = String()
    var array: [String] = []
    var sortedArray: [String] = []

//    @IBOutlet weak var startTimeLbl: UILabel!
    var dateStringg = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownView.isHidden = true
//        self.selectDstePicker.minuteInterval = 30
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm"
//
//
//       // self.startTimeLbl.text = dateFormatter.string(from: selectDstePicker.date)
//        self.startTime = dateFormatter.string(from: selectDstePicker.date)
//        datesTv.text = "Selected Date: \(dateStringg), Selected Time: \(startTime))"

        submitBtn.layer.cornerRadius = 10
        submitBtn.setTitle("Reset", for: .normal)
        calender.layer.cornerRadius = 10
        calender.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        calender.layer.borderWidth = 1
        
        dropDownView.layer.cornerRadius = 10
        dropDownView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dropDownView.layer.borderWidth = 1
        
//        selectDstePicker.layer.cornerRadius = 10
//        selectDstePicker.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        selectDstePicker.layer.borderWidth = 1
        
        calender.dataSource = self
        calender.delegate = self
        print(ORDER_AHEAD_DAYS,"-------")
        countLbl.text = "(\(ORDER_AHEAD_DAYS?.count ?? 0) Days)"
        datesTv.isHidden = true
        submitBtn.isHidden = true
        
        let selectedDate = UserDefaults.standard.value(forKey: "selectedDate") as? String ?? ""
        let selectedTime = UserDefaults.standard.value(forKey: "selectedTime") as? String ?? ""
        
        if selectedTime != ""{
            datesTv.isHidden = false
            dropDownView.isHidden = false
            timeBtnText.setTitle("  \(selectedTime)", for: .normal)
            datesTv.text = "Selected Date: \(selectedDate), Selected Time: \(selectedTime)"
            submitBtn.isHidden = false

        }
        
      //  selectDstePicker.isHidden = true

//        datesTv.text = ORDER_AHEAD_DAYS?.joined(separator: "\n•")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    @IBAction func timePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.dateFormat = "hh:mm"
        self.startTime = dateFormatter.string(from: sender.date)

//            self.startTimeLbl.text = dateFormatter.string(from: sender.date)
        datesTv.text = "Selected Date: \(dateStringg), Selected Time: \(dateFormatter.string(from: sender.date))"

        
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print(date)
        let weekday = getTodayWeekDay(date: date).uppercased()
        array.removeAll()
        sortedArray.removeAll()

        let dateFormatter3 = DateFormatter()
          dateFormatter3.dateFormat = "dd/MM/yyyy"
          let dateString = dateFormatter3.string(from: date)
        submitBtn.isHidden = true

        if ORDER_AHEAD_DAYS!.contains(dateString){
            dateStringg = dateString
            print("yessss")
            datesTv.text = "Selected Date: \(dateString)"
            datesTv.isHidden = false
            submitBtn.isHidden = true
          //  selectDstePicker.isHidden = false
            UserDefaults.standard.setValue("", forKey: "selectedDate")
            UserDefaults.standard.setValue("", forKey: "selectedTime")
            let locale = NSLocale.current
            let formatter : String = DateFormatter.dateFormat(fromTemplate: "j", options:0, locale:locale)!

            let SHOP_TIMING = UserDefaults.standard.value(forKey: "SHOP_TIMING") as? [[String:Any]]
            if SHOP_TIMING?.count != 0{
            for i in 0...SHOP_TIMING!.count - 1{
                if weekday == SHOP_TIMING?[i]["name"] as? String{
                    let time = SHOP_TIMING?[i]["time"] as? String

                    let timee = time?.split(separator: "-")
                   let minTime = (timee?[0].description)!
                   let maxTime = (timee?[1].description)!
                    print(time,"tttttt",minTime,maxTime,weekday)
                    
                    let minTimeTrimmed = minTime.trimmingCharacters(in: .whitespaces)
                    let maxTimeTrimmed = maxTime.trimmingCharacters(in: .whitespaces)

                    if minTimeTrimmed.contains(":"){
                        let dateAsString = minTimeTrimmed
                        let dateFormatter = DateFormatter()
                        if formatter.contains("a") {

                        dateFormatter.dateFormat = "hh:mma"
                        }
                        else{
                            dateFormatter.dateFormat = "HH:mma"

                        }
                        let date = dateFormatter.date(from: dateAsString)
                        dateFormatter.dateFormat = "HH:mm"

                        let Date24minTimeTrimmed = dateFormatter.string(from: date!)
                        print("24 hour formatted minTimeTrimmed:",Date24minTimeTrimmed)
                        minTimeFinal = Date24minTimeTrimmed
                    }
                    else{
                    let dateAsString = minTimeTrimmed
                    let dateFormatter = DateFormatter()
                        if formatter.contains("a") {
                    dateFormatter.dateFormat = "ha"
                        }
                        else{
                            dateFormatter.dateFormat = "Ha"
                        }
                    let date = dateFormatter.date(from: dateAsString)
                    dateFormatter.dateFormat = "HH:mm"

                        if date != nil{
                    let Date24minTimeTrimmed = dateFormatter.string(from: date!)
                    print("24 hour formatted minTimeTrimmed:",Date24minTimeTrimmed)
                        minTimeFinal = Date24minTimeTrimmed

                    }
                    }
                    if maxTimeTrimmed.contains(":"){
                        let dateAsString = maxTimeTrimmed
                        let dateFormatter = DateFormatter()
                        if formatter.contains("a") {
                        dateFormatter.dateFormat = "hh:mma"
                        }
                        else{
                            dateFormatter.dateFormat = "HH:mma"

                        }
                        let date = dateFormatter.date(from: dateAsString)
                        dateFormatter.dateFormat = "HH:mm"

                        if date != nil{
                        let Date24maxTimeTrimmed = dateFormatter.string(from: date!)
                        print("24 hour formatted maxTimeTrimmed:",Date24maxTimeTrimmed)
                        maxTimeFinal = Date24maxTimeTrimmed
                        }
                    }
                    else{
                    let dateAsStringmaxTimeTrimmed = maxTimeTrimmed
                    let dateFormatter2 = DateFormatter()
                        if formatter.contains("a") {
                    dateFormatter2.dateFormat = "ha"
                        }
                        else{
                            dateFormatter2.dateFormat = "Ha"

                        }
                    let dateMax = dateFormatter2.date(from: dateAsStringmaxTimeTrimmed)
                    dateFormatter2.dateFormat = "HH:mm"

                        if dateMax != nil{
                    let Date24maxTimeTrimmed = dateFormatter2.string(from: dateMax!)
                    print("24 hour formatted maxTimeTrimmed:",Date24maxTimeTrimmed)
                    
                    maxTimeFinal = Date24maxTimeTrimmed
                        }}
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"

                    let formatter2 = DateFormatter()
                    formatter2.dateFormat = "HH:mm"

                    let startDate = minTimeFinal
                    let endDate = maxTimeFinal

                    let date1 = formatter.date(from: startDate)
                    let date2 = formatter.date(from: endDate)

                    var i = 1
                    while true {
                        let date = date1?.addingTimeInterval(TimeInterval(i*30*60))
                        if date == nil{
                            return
                        }
                        let string = formatter2.string(from: date!)

                        if date! >= date2! {
                            break;
                        }

                        i += 1
                        array.append(string)
                        
                    }
                    print(array,"00000--------")
                    
                    let sortedArrayy = array.sorted {$0.compare($1, options: .numeric) == .orderedAscending}
                    print(sortedArrayy)
                    print("connnnnn",sortedArrayy)
                    sortedArray = sortedArrayy
//                    let dateFormatter = DateFormatter()
////                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
////                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//                    dateFormatter.dateFormat = "HH:mm"
//
//                    let convertedArray = array
//                        .compactMap(dateFormatter.date(from:))
//                        .sorted(by: >)
//
//                    print("connnnnn",convertedArray)
                    
                    
                    dropDownView.isHidden = false
                    timeBtnText.setTitle("  Time", for: .normal)
                    
                  

                }
            }
                if array.count == 0{
                    dropDownView.isHidden = true
                    datesTv.text = "Not Available (OFF)"
                    UserDefaults.standard.setValue("", forKey: "selectedDate")
                    UserDefaults.standard.setValue("", forKey: "selectedTime")
                }
            }
          
            
        }
        else{
            UserDefaults.standard.setValue("", forKey: "selectedDate")
            UserDefaults.standard.setValue("", forKey: "selectedTime")
            print("No")
            dropDownView.isHidden = true
            timeBtnText.setTitle("  Time", for: .normal)
            datesTv.text = ""
            datesTv.isHidden = true
            submitBtn.isHidden = true
          //  selectDstePicker.isHidden = true

        }
    
    }

    @IBAction func timeBtnAction(_ sender: Any) {
        datesTv.isHidden = false
        let dropDown = DropDown()

        // The view to which the drop down will appear on
        dropDown.anchorView = dropDownView // UIView or UIBarButtonItem
//        dropDown.bottomOffset = CGPoint(x: 0, y:1000)
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = sortedArray
        dropDown.direction = .bottom
        dropDown.offsetFromWindowBottom = 10
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            timeBtnText.setTitle("  \(sortedArray[index])", for: .normal)
      datesTv.text = "Selected Date: \(dateStringg), Selected Time: \(sortedArray[index])"

            UserDefaults.standard.setValue(dateStringg, forKey: "selectedDate")
            UserDefaults.standard.setValue(sortedArray[index], forKey: "selectedTime")
            submitBtn.isHidden = false

        }
        
        dropDown.show()
        
    }
    func getTodayWeekDay(date:Date)-> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "EEEE"
           let weekDay = dateFormatter.string(from: date)
           return weekDay
     }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

     //format date according your need


        let dateFormatter3 = DateFormatter()
          dateFormatter3.dateFormat = "dd/MM/yyyy"
          let dateString = dateFormatter3.string(from: date)

     //your events date array

        if ORDER_AHEAD_DAYS!.contains(dateString) {

         return UIColor.init(named: "MaroonTheme")

     }

     return nil //add your color for default

    }
//    @IBAction func menubtnAction(_ sender: Any) {
//        //        self.sideMenuController?.toggle()
//        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
//    }
//    @IBAction func backk(_ sender: Any) {
//
////        if self.navigationController?.viewControllers.count != 1{
//        self.navigationController?.popViewController(animated: true)
////        }
////        else{
////            sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
////        }
//    }
    @IBAction func menubtnAction(_ sender: Any) {
        //        self.sideMenuController?.toggle()
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        UserDefaults.standard.setValue("", forKey: "selectedDate")
        UserDefaults.standard.setValue("", forKey: "selectedTime")
        
        dropDownView.isHidden = true
        timeBtnText.setTitle("  Time", for: .normal)
        datesTv.text = ""
        datesTv.isHidden = true
        submitBtn.isHidden = true
        
    }
    
}
