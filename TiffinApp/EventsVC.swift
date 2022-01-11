//
//  EventsVC.swift
//  TiffinApp
//
//  Created by NMX MacBook on 10/12/19.
//  Copyright © 2019 YAY. All rights reserved.
//

import UIKit
import Alamofire

class EventsVC: UIViewController {

    var eventsArr = NSArray()
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var noEventLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

       
        getEvents()
        eventsTableView.dataSource = self
        eventsTableView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)

//         navigationController?.navigationBar.isHidden = false
//         navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func menubtnAction(_ sender: Any) {
        //        self.sideMenuController?.toggle()
        sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
    }
    @IBAction func backk(_ sender: Any) {

        if self.navigationController?.viewControllers.count != 1{
        self.navigationController?.popViewController(animated: true)
        }
        else{
            sideMenuController?.performSegue(withIdentifier: "toHome", sender: nil)
        }
    }
   

    func getEvents() {
        
          let access_token = UserDefaults.standard.value(forKey: userdefaultKeys().merchant_access_token) as? String ?? ""
        
        
        let email = UserDefaults.standard.value(forKey: usercredential().email)
        let m_idd = UserDefaults.standard.value(forKey: "m_idd") as? String
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
    
        let headers:HTTPHeaders = [
            "Content-Type": "application/json",
            "authorization" : "Bearer " + access_token
        ]
        let parameters: [String: Any] = [
            "user_id" : email ?? ""
            
            ]
        print("parameters==========\(parameters)")
        
        var apiUrl = URLComponents(string: ApiKeys.merchantapibaseevents)
        apiUrl?.queryItems = [URLQueryItem(name: "mid", value: m_idd as? String) ]
        print("yesssss",apiUrl)
        Alamofire.request(apiUrl!,method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            let result = respose.result.value as? NSDictionary
            let data = result?.value(forKey: "data") as! NSArray
            let object = result?.value(forKey: "object") as? NSDictionary
            let message = result?.value(forKey: "message") as? String
            let error = object?.value(forKey: "error") as? String
            
            activityIndicator.stopAnimating()
            
            switch (respose.result) {
                
            case .success:
                if message == nil {
//                    let token = object.value(forKey: "token") as? String
//                    UserDefaults.standard.setValue("token", forKey: "resetToken")
//                    let alert = UIAlertController(title: "\(message ?? "")", message: "",         preferredStyle: UIAlertController.Style.alert)
//
//                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
//                        let loginvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
//                        self.navigationController?.pushViewController(loginvc, animated: true)
//                    }))
                
                    print(data)
                          
                    self.eventsArr = data
                    if self.eventsArr.count == 0{
                        self.noEventLbl.isHidden = false
                    }
                    else{
                        self.noEventLbl.isHidden = true

                    }
                    self.eventsTableView.reloadData()
                    
//                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.showAlert(msg: message!)
                }
                break
            case .failure:
                
                self.showAlert(msg: error!)
                break
            }
        }
    }
    
    @objc func oneTapped(_ sender: UIButton?) {
        
        let dic:NSDictionary = eventsArr[sender!.tag] as! NSDictionary
        let uvc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC
        
        let image = dic.value(forKey: "image") as! String
        let namec = dic.value(forKey: "name") as! String
        let descc = dic.value(forKey: "description") as! String
        let startTime = dic.value(forKey: "start_time") as! String
        let endTime = dic.value(forKey: "end_time") as! String
        uvc.imagge = image
        uvc.descc = descc
        uvc.name = namec
        uvc.datee = startTime
        uvc.enddate = endTime
        
        
        self.navigationController?.pushViewController(uvc, animated: true)
        print("Tapped")
    }
    
    func showAlert(msg:String) {
        let  alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        
        let okAcction = UIAlertAction(title: "OK", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(okAcction)
        alert.view.tintColor = UIColor.MyTheme.marooncolor
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
extension EventsVC : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("Events", owner: Any?.self, options: nil)?.first as! Events
        
        let dic:NSDictionary = eventsArr[indexPath.row] as! NSDictionary
        cell.moreinfoBtn.tag = indexPath.row;
        cell.moreinfoBtn.addTarget(self, action: #selector(oneTapped(_:)), for: .touchUpInside)
        cell.nameLbl.text =  dic.value(forKey: "name") as? String
        
        cell.descLbl.text = (dic.value(forKey: "description") as? String)
        let startTime =  (dic.value(forKey: "start_time") as? String ?? "")
        let endTime = "End Time : " + (dic.value(forKey: "end_time") as? String ?? "")
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MMM dd,YYYY HH:mm:ss aa"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd \nMMM"

        if let date = dateFormatterGet.date(from: startTime) {
            print(dateFormatterPrint.string(from: date))
            let formatStartdate = dateFormatterPrint.string(from: date)
            
            cell.startTimeLbl.text = formatStartdate

        }
    
        
        else {
            print("There was an error decoding the string")
        }
        
        
        let selfstr = (dic.value(forKey: "image") as! String)
        
        if selfstr == "" {
            cell.eventImage.image = UIImage(named:"placeholder img")!
            
        } else {
            
            let imageUrl = URL(string: selfstr )
            cell.eventImage!.sd_setImage(with: imageUrl!, placeholderImage: UIImage(named: "placeholder img"))
            
            //  }
        }
        
        return cell
    }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
            if editingStyle == .delete {
    
                let dic:NSDictionary = eventsArr[indexPath.row] as! NSDictionary
                print(dic)
                let event_id = dic.value(forKey: "event_id") as! String
    
                let alert = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete this event ?",         preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { _ in
                    self.deleteEvent(event_idd: event_id)
                }))
                alert.addAction(UIAlertAction(title: "No",
                                              style: UIAlertAction.Style.default,
                                              handler: {(_: UIAlertAction!) in
                                              self.dismiss(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                
                
                
    
            } else if editingStyle == .insert {
                // Not used in our example, but if you were adding a new row, this is where you would do it.
            }
        }
    
    
    
    func deleteEvent(event_idd : String){

        let access_token = UserDefaults.standard.value(forKey: userdefaultKeys().merchant_access_token) as? String ?? ""
        
        let email = UserDefaults.standard.value(forKey: usercredential().email)
//        let m_idd = UserDefaults.standard.value(forKey: "m_idd") as? String
        let activityIndicator = loader(at: self.view, active: .circleStrokeSpin)
        self.view.addSubview(activityIndicator) // or use  webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
//        appDel_ref.startProgressHuddAnimating()
        let headers: HTTPHeaders = [
            "Accept": "application/json", "authorization" : "bearer " + access_token
        ]
        let parameters: [String: Any] = [

            :]
        var apiUrl = URLComponents(string: ApiKeys.merchantapibaseEventDelete)
        apiUrl?.queryItems = [URLQueryItem(name: "user_id", value: email as? String),URLQueryItem(name: "event_id", value: event_idd as? String)]
        print("yesssssdelete",apiUrl)

        Alamofire.request(apiUrl!,method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (respose) in
            
            let result = respose.result.value as? NSDictionary
//            let data = result?.value(forKey: "data") as! NSArray
            let object = result?.value(forKey: "object") as? NSDictionary
            let message = result?.value(forKey: "message") as? String
            let error = object?.value(forKey: "error") as? String
            
            activityIndicator.stopAnimating()
            
            switch (respose.result) {
                
            case .success:
                if message == nil {
                  
                    
//                    self.eventsArr = data
                    self.getEvents()
                    self.eventsTableView.reloadData()
                    
                    //                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    self.showAlert(msg: message!)
                }
                break
            case .failure:
                
                self.showAlert(msg: error!)
                break
            }
            
            
        }
    }
//
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let uvc = UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: "EventDetailVC") as! EventDetailVC

        let dic:NSDictionary = eventsArr[indexPath.row] as! NSDictionary
        //        category_id
        let image = dic.value(forKey: "image") as! String
        let namec = dic.value(forKey: "name") as! String
        let descc = dic.value(forKey: "description") as! String
        let startTime = dic.value(forKey: "start_time") as! String
         let endTime = dic.value(forKey: "end_time") as! String
        uvc.imagge = image
        uvc.descc = descc
        uvc.name = namec
        uvc.datee = startTime
        uvc.enddate = endTime
        
        
        self.navigationController?.pushViewController(uvc, animated: true)
    }
//
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
}
