//
//  ProfileViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import SwifterSwift
import Kingfisher
import DZNEmptyDataSet
import ESPullToRefresh



class ProfileViewController: UIViewController,ToastAlertProtocol {
    @IBOutlet weak var tbl_Orders: UITableView!
    var ClosedPageNum : Int!
    var IsClosedOrderDataFirstLoading : Bool!
    var ArrClosedOrdersCat :[Orderdata]!
    var ErrorStr : String!
    
    var viewModel: UserViewModel!
    var OrderModel: OrderViewModel!
    var StopLoadMore = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        OrderModel = OrderViewModel()
        ArrClosedOrdersCat = [Orderdata]()
        IsClosedOrderDataFirstLoading = true
        self.addInfiniteScrolling()
        ClosedPageNum = 1
        self.getClosedOrdersWithPageNum(ClosedPageNum)
        
        self.ErrorStr = ""
        
        self.title = NSLocalizedString("profile", comment: "")
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
        
    }
    
    func addInfiniteScrolling(){
        self.tbl_Orders.es.addInfiniteScrolling {
            [unowned self] in
            if self.StopLoadMore == false
            {
                self.ClosedPageNum = self.ClosedPageNum + 1
                self.getClosedOrdersWithPageNum(self.ClosedPageNum)
            }
            else
            {
                self.tbl_Orders.es.removeRefreshFooter()
                
            }
        }
    }
    
    func getClosedOrdersWithPageNum (_ PageNum : Int)
    {
        OrderModel.getClosedOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ErrorStr = ""
                
                self.IsClosedOrderDataFirstLoading = false
                
                
                if self.ClosedPageNum == 1
                {
                    self.ArrClosedOrdersCat = OrderObj?.data
                    if self.ArrClosedOrdersCat == nil
                    {
                        self.ArrClosedOrdersCat = [Orderdata]()
                    }
                }
                else
                {
                    if let  ArrMoreClosedRequests = OrderObj?.data
                    {
                        self.ArrClosedOrdersCat = self.ArrClosedOrdersCat + ArrMoreClosedRequests
                    }
                    else
                    {
                        self.tbl_Orders.es.stopLoadingMore()
                        self.StopLoadMore = true
                        
                    }
                }
                
                self.tbl_Orders.reloadData()
                self.tbl_Orders.es.stopLoadingMore()
                
                
            } else{
                self.ErrorStr = errorMsg
                self.IsClosedOrderDataFirstLoading = false
                self.tbl_Orders.reloadData()
                self.tbl_Orders.es.stopLoadingMore()
                
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }

    
    override  func viewDidLayoutSubviews() {
       
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITableViewDataSource {
    // table view data source methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if IsClosedOrderDataFirstLoading == true
        {
            return 5
        }
        else
        {
            return  ArrClosedOrdersCat.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if IsClosedOrderDataFirstLoading == true
        {
            let cellLoader:MyOrderPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderPlaceHolderTableViewCell") as UITableViewCell! as! MyOrderPlaceHolderTableViewCell
            
            cellLoader.gradientLayers.forEach { gradientLayer in
                let baseColor = cellLoader.lblLawerName.backgroundColor!
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
            
            let ObjOrder =  self.ArrClosedOrdersCat[indexPath.row]
            
            cellOrderCell.lblLawerName.text = ObjOrder.lawyer?.name
            cellOrderCell.lblOrderStatus.text = ObjOrder.category?.discription
            cellOrderCell.lblServiceNum.text = "\(NSLocalizedString("OrderNumber", comment: "") as String) \(ObjOrder.id as! Int)"
            
            let date = Date(unixTimestamp: Double(ObjOrder.createdAt!))
            
            if Int(Date().daysSince(date))  > 0
            {
                cellOrderCell.LblOrderTime.text = "\(Int(Date().daysSince(date))) \(NSLocalizedString("DaysAgo", comment: ""))"
                
            }
            else
            {
                cellOrderCell.LblOrderTime.text = "\(Int(Date().hoursSince (date))) \(NSLocalizedString("Hoursago", comment: ""))"
                
            }
            if let url = ObjOrder.lawyer?.image
            {
                let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
                cellOrderCell.imgLawyer.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            else
            {
                cellOrderCell.imgLawyer.kf.setImage(with: nil, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            return cellOrderCell
            
        }
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 300
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cellHeader:ProfileHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"ProfileHeaderTableViewCell") as UITableViewCell! as! ProfileHeaderTableViewCell
        viewModel = UserViewModel()
        let UserModel = viewModel.getUser()
        if let name = UserModel?.name
        {
            cellHeader.lblUserName.text = name
        }
        if let url = UserModel?.image
        {
            let imgUrl =  URL(string: Constants.ApiConstants.BaseUrl+url)
            cellHeader.imgUserImg.kf.setImage(with:imgUrl, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        else
        {
            cellHeader.imgUserImg.kf.setImage(with: nil, placeholder: UIImage.init(named: "avatar2"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        cellHeader.lblNumOfServices.text = "\(ArrClosedOrdersCat.count as Int)"
        cellHeader.lblTitleNumOfServices.text = NSLocalizedString("NumofEndedServices", comment: "")
        
        return cellHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
}

extension ProfileViewController:DZNEmptyDataSetSource
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
            
            myMutableString1 = NSMutableAttributedString(string: NSLocalizedString("No Orders", comment: ""))
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
            return UIImage(named:"EmptyData_OrdersEmpty")
            
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
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        
        return 150
        
    }
    
    
    
}

extension ProfileViewController:DZNEmptyDataSetDelegate
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
        ClosedPageNum = 1
        self.getClosedOrdersWithPageNum(ClosedPageNum)
    }
    
}

