//
//  Public Functions.swift
//  TiffinApp
//
//  Created by yuvraj kakkar on 02/05/18.
//  Copyright © 2018 YAY. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

//MARK: - SEGUES
public func mainSBVC(_ identifier : String)-> UIViewController{
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
}
public func secondSBVC(_ identifier : String)-> UIViewController{
    return UIStoryboard(name: "Second", bundle: nil).instantiateViewController(withIdentifier: identifier)
}

//MARK: - VALIDATING EMAIL
func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}


//MARK: - LOADER
func loader(at view : UIView, active type: NVActivityIndicatorType) -> NVActivityIndicatorView{
    //NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 45, height: 45)
    //NVActivityIndicatorPresenter.sharedInstance.startAnimating(FaqViewController.activityData)
    var activityIndicator : NVActivityIndicatorView!
    let xAxis = view.center.x // or use (view.frame.size.width / 2) // or use (faqWebView.frame.size.width / 2)
    let yAxis = view.center.y // or use (view.frame.size.height / 2) // or use (faqWebView.frame.size.height / 2)
//
//    let xAxis = (view.frame.size.width / 2) // or use (view.frame.size.width / 2) // or use (faqWebView.frame.size.width / 2)
//    let yAxis = (view.frame.size.height / 2) // or use (view.frame.size.height / 2) // or use (faqWebView.frame.size.height / 2)
    
    
//    let frame = CGRect(x: (xAxis - 50), y: (yAxis - 50), width: 45, height: 45)
    
    
    let frame = CGRect(x: (xAxis - 20), y: (yAxis ), width: 45, height: 45)
    activityIndicator = NVActivityIndicatorView(frame: frame)
    activityIndicator.type = type // add your type
    
    activityIndicator.color = UIColor.MyTheme.marooncolor // add your color
    
    return activityIndicator

}

func hideactivityIndicator(activityIndicator: NVActivityIndicatorView)
{

    activityIndicator.stopAnimating()
    activityIndicator.removeFromSuperview()
}

// //MARK: -  for converting currency
func cleanDollars(_ value: String?) -> String {
    guard value != nil else { return "$0.00" }
    let doubleValue = Double(value!) ?? 0.0
    let formatter = NumberFormatter()
    let defaultSymbol = "$"
    let defaultValue =  defaultSymbol + String(format: "%.2f", doubleValue);
    
    if  DBManager.sharedInstance.get_currency_DataFromDB().count != 0 {}else {return defaultValue}
    let curn  = DBManager.sharedInstance.get_currency_DataFromDB()[0] as CurrencyModel
    if  curn.data.count != 0 {}else {return defaultValue}
    formatter.currencyCode = curn.data[0].name
    formatter.currencySymbol = curn.data[0].symbol
    formatter.minimumFractionDigits = (value!.contains(".00")) ? 0 : curn.data[0].fxRateAfterDecimalDigit
    formatter.maximumFractionDigits = curn.data[0].fxRateAfterDecimalDigit
    formatter.numberStyle = .currencyAccounting
    let val = formatter.string(from: NSNumber(value: doubleValue)) ?? "\(curn.data[0].symbol)\(doubleValue)"
    return val
}


