//
//  MyOrdersViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import SwifterSwift
import Kingfisher




class MyOrdersViewController: UIViewController,ToastAlertProtocol {

  
    @IBOutlet weak var SegmentControl: BetterSegmentedControl!
    var viewModel: OrderViewModel!
    var newPageNum : Int!
    var PendingPageNum : Int!
    var ClosedPageNum : Int!
    
    var IsNewOrderDataFirstLoading : Bool!
    var IsPendingOrderDataFirstLoading : Bool!
    var IsClosedOrderDataFirstLoading : Bool!

    var ArrNewOrdersCat :[Orderdata]!
    var ArrPendingOrdersCat :[Orderdata]!
    var ArrClosedOrdersCat :[Orderdata]!

    
    var isNewData : Bool!
    var isPendingData : Bool!
    var IsClosedData : Bool!
    
    @IBOutlet weak var tbl_Orders: UITableView!







    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArrNewOrdersCat = [Orderdata]()
        ArrPendingOrdersCat = [Orderdata]()
        ArrClosedOrdersCat = [Orderdata]()
        
        IsNewOrderDataFirstLoading = true
        IsPendingOrderDataFirstLoading = true
        IsClosedOrderDataFirstLoading = true

        
        isNewData = true
        
        viewModel = OrderViewModel()
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }
       self.title = NSLocalizedString("myOrders", comment: "")
       self.adjustSegmentControl()
        newPageNum = 1
        PendingPageNum = 1
        ClosedPageNum = 1
        self.getNewOrdersWithPageNum(newPageNum)
        }
    
    
    func adjustSegmentControl ()
    {
        SegmentControl.titles = [NSLocalizedString("new", comment: ""), NSLocalizedString("opened", comment: ""), NSLocalizedString("finished", comment: "")]
        SegmentControl.titleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
        SegmentControl.selectedTitleFont = UIFont(name: Constants.FONTS.FONT_AR, size: 16.0)!
        SegmentControl.addTarget(self, action: #selector(navigationSegmentedControlValueChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.NWConnectivityDidChangeCalled) , name: .NWConnectivityDidChange, object: nil)
    }
    
    @objc func navigationSegmentedControlValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            isNewData = true
            isPendingData = false
            IsClosedData = false
            self.getNewOrdersWithPageNum(newPageNum)
        }
        else if sender.index == 1  {
            self.getPendingOrdersWithPageNum(PendingPageNum)
            isNewData = false
            isPendingData = true
            IsClosedData = false
        }
        else
        {
            self.getClosedOrdersWithPageNum(ClosedPageNum)
            isNewData = false
            isPendingData = false
            IsClosedData = true
        }
    }
    
    
    func getNewOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getNewOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                
                self.ArrNewOrdersCat = OrderObj?.data
                self.IsNewOrderDataFirstLoading = false
                if self.ArrNewOrdersCat == nil
                {
                    self.ArrNewOrdersCat = [Orderdata]()
                    
                }
                self.tbl_Orders.reloadData()

                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    func getPendingOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getPendingOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ArrPendingOrdersCat = OrderObj?.data
                self.IsPendingOrderDataFirstLoading = false
                if self.ArrPendingOrdersCat == nil
                {
                    self.ArrPendingOrdersCat = [Orderdata]()

                }
                
                self.tbl_Orders.reloadData()

                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    func getClosedOrdersWithPageNum (_ PageNum : Int)
    {
        viewModel.getClosedOrders(orderPageNum: PageNum, completion: { (OrderObj, errorMsg) in
            if errorMsg == nil {
                self.ArrClosedOrdersCat = OrderObj?.data
                self.IsClosedOrderDataFirstLoading = false
                if self.ArrClosedOrdersCat == nil
                {
                    self.ArrClosedOrdersCat = [Orderdata]()
                    
                }
                self.tbl_Orders.reloadData()

                
            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })
    }
    
    override  func viewDidLayoutSubviews() {
      

    }
    
    @objc func NWConnectivityDidChangeCalled() {
        print("=========================")
        print("network connectivity changed")
        print("=========================")
        
        if NWConnectivity.sharedInstance.isConnectedToInternet() {
            print("========================= Connected ")
        }
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

extension MyOrdersViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isNewData == true
        {
            if IsNewOrderDataFirstLoading == true
            {
                return 5
            }
            else
            {
            return ArrNewOrdersCat.count
            }
        }
        else if isPendingData == true
        {
            if IsPendingOrderDataFirstLoading == true
            {
                return 5
            }
            else
            {
            return ArrPendingOrdersCat.count
            }
        }
        else
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
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if isNewData == true
        {
            if IsNewOrderDataFirstLoading == true
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
                
                let ObjOrder =  self.ArrNewOrdersCat[indexPath.row]

                cellOrderCell.lblLawerName.text = ObjOrder.lawyer?.name
                cellOrderCell.lblOrderStatus.text = ObjOrder.status
                cellOrderCell.lblServiceNum.text = "\(ObjOrder.id as! Int)"
                
                let date = Date(unixTimestamp: Double(ObjOrder.createdAt!))

                cellOrderCell.LblOrderTime.text = date.dateString()
                
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
        else if isPendingData == true
        {
            if IsPendingOrderDataFirstLoading == true
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
                let ObjOrder =  self.ArrPendingOrdersCat[indexPath.row]

                
                return cellOrderCell
            }
        }
        else
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

    
     return cellOrderCell
    
         }
     }
        
  }
    
}

extension MyOrdersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 160
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    
}

