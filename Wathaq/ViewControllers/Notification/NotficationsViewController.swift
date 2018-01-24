//
//  NotficationsViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SwifterSwift

class NotficationsViewController: UIViewController,ToastAlertProtocol {
    var viewModel: NotificationViewModel!
    var ErrorStr : String!
    var IsDataFirstLoading : Bool!
    @IBOutlet weak var tbl_Notification: UITableView!
    var ArrNotification :[NotificationData]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = NotificationViewModel()
        IsDataFirstLoading = true
        ArrNotification = [NotificationData]()
        self.ErrorStr = ""
        tbl_Notification.rowHeight = UITableViewAutomaticDimension
        
        
        self.getNotifications()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
        self.title = NSLocalizedString("notifications", comment: "")
    }
    
    func getNotifications()
    {
        viewModel.GetNotification { (NotificationData, errorMsg) in
            if errorMsg == nil {
                
                if let arrData = NotificationData?.notificationData
                {
                    self.ArrNotification = arrData
                    
                }
                self.IsDataFirstLoading = false
                
                self.tbl_Notification.reloadData()
            }
            else{
                self.ErrorStr = errorMsg
                self.IsDataFirstLoading = false
                self.tbl_Notification.reloadData()
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        }
    }
    
    override  func viewDidLayoutSubviews() {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NotficationsViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if IsDataFirstLoading == true
        {
            return 5
        }
        else
        {
            return ArrNotification.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if IsDataFirstLoading == true
        {
            let cellLoader:MyOrderPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderPlaceHolderTableViewCell") as UITableViewCell! as! MyOrderPlaceHolderTableViewCell
            
            cellLoader.gradientLayers.forEach { gradientLayer in
                let baseColor = cellLoader.lblServiceNum.backgroundColor!
                gradientLayer.colors = [baseColor.cgColor,
                                        baseColor.brightened(by: 0.93).cgColor,
                                        baseColor.cgColor]
                gradientLayer.slide(to: .right)
            }
            return cellLoader
        }
        else
        {
            let cellOrderCell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderTableViewCell") as UITableViewCell! as! MyOrderTableViewCell
            let ObjNotification =  self.ArrNotification[indexPath.row]
            cellOrderCell.lblServiceNum.text = ObjNotification.content
            //  cellOrderCell.lblLawerName.text = ObjNotification.content
            cellOrderCell.lblOrderStatus.text = ObjNotification.type
            let date = Date(unixTimestamp: Double(ObjNotification.createdAt!))
            cellOrderCell.LblOrderTime.text = date.dateString()
            if Int(Date().daysSince(date))  > 0
            {
                cellOrderCell.LblOrderTime.text = "\(Int(Date().daysSince(date))) \(NSLocalizedString("DaysAgo", comment: ""))"
            }
            else
            {
                cellOrderCell.LblOrderTime.text = "\(Int(Date().hoursSince (date))) \(NSLocalizedString("Hoursago", comment: ""))"
            }
            
            return cellOrderCell
            
            
        }
    }
    
}

extension NotficationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if IsDataFirstLoading == true
        {
            return self.view.frame.size.height * 0.2
        }
        else
        {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension NotficationsViewController:DZNEmptyDataSetSource
{
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let myMutableString = NSMutableAttributedString()
        
        if ErrorStr == NSLocalizedString("No_Internet", comment: "")
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("NoInternetConnection", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            var myMutableString2 = NSMutableAttributedString()
            myMutableString2 = NSMutableAttributedString(string: NSLocalizedString("ReconnectToInternet", comment: ""))
            myMutableString2.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor(red: 16 / 255.0, green: 16 / 255.0, blue: 16 / 255.0, alpha: 1.0)], range: NSRange(location:0,length:myMutableString2.length)) // What ever range you want to give
            
            
            myMutableString.append(myMutableString1)
            myMutableString.append(NSAttributedString(string: "\n"))
            myMutableString.append(myMutableString2)
            
            
        }
        else if ErrorStr == NSLocalizedString("SERVER_ERROR", comment: "")
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("SERVER_ERROR", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font :UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            var myMutableString2 = NSMutableAttributedString()
            
            myMutableString2 = NSMutableAttributedString(string: NSLocalizedString("TryAgainLater", comment: ""))
            myMutableString2.setAttributes([NSAttributedStringKey.font : UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor(red: 16 / 255.0, green: 16 / 255.0, blue: 16 / 255.0, alpha: 1.0)], range: NSRange(location:0,length:myMutableString2.length)) // What ever range you want to give
            
            myMutableString.append(myMutableString1)
            myMutableString.append(NSAttributedString(string: "\n"))
            myMutableString.append(myMutableString2)
            
            
        }
        else
        {
            var myMutableString1 = NSMutableAttributedString()
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No Notifications", comment: ""))
            myMutableString1.setAttributes([NSAttributedStringKey.font :UIFont(name: Constants.FONTS.FONT_AR, size: 18.0)!
                , NSAttributedStringKey.foregroundColor : UIColor.deepBlue], range: NSRange(location:0,length:myMutableString1.length)) // What ever range you want to give
            
            myMutableString.append(myMutableString1)
            
        }
        return myMutableString
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        if ErrorStr == NSLocalizedString("No_Internet", comment: "") || ErrorStr == NSLocalizedString("SERVER_ERROR", comment: "")
        {
            return UIImage(named:"EmptyData_NoInternet")
            
        }
        else
        {
            return UIImage(named:"EmptyData_NotificationEmpty")
            
        }
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation!
    {
        let animation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = NSValue(caTransform3D:CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1))
        animation.duration = 5
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.clear
    }
    
}

extension NotficationsViewController:DZNEmptyDataSetDelegate
{
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool
    {
        return true
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool
    {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool
    {
        return false
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!)
    {
        self.getNotifications()
    }
}


