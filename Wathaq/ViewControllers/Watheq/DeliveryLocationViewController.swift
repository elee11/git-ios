//
//  DeliveryLocationViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton

class DeliveryLocationViewController: UIViewController ,ToastAlertProtocol{
   
    var viewModel: OrderViewModel!

    @IBOutlet weak var tbl_DeliveryLocation: UITableView!
    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }
    var OrderDataDic : NSMutableDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderViewModel()

        ConfirmButton.setTitle(NSLocalizedString("CreatOrder", comment: ""), for: .normal)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Home_Location"  {
            let OrderDic = sender as!  NSMutableDictionary
            let CurrentLocationView = segue.destination as! CurrentLocationViewController
            CurrentLocationView.OrderDataDic = OrderDic
        }
    }
    

    @IBAction func CreateOrder (_ sender :Any)
    {
        
        if OrderDataDic.value(forKey: "delivery") != nil {
            ConfirmButton.startAnimation()
            self.view.isUserInteractionEnabled = false
            if OrderDataDic.value(forKey: "longitude") == nil && OrderDataDic.value(forKey: "latitude") == nil{
                OrderDataDic.setValue(0, forKey: "longitude")
                OrderDataDic.setValue(0, forKey: "latitude")
            }
            
             if OrderDataDic.value(forKey: "clientName") == nil
             {
                OrderDataDic.setValue("", forKey: "clientName")
                OrderDataDic.setValue("", forKey: "clientNationalID")
                
                OrderDataDic.setValue("", forKey: "representativeName")
                OrderDataDic.setValue("", forKey: "representativeNationalID")
             }
            
            
            viewModel.CreateOrder(OrderDic: OrderDataDic, completion: { (OrderObj, errorMsg) in
                if errorMsg == nil {
                
                self.ConfirmButton.stopAnimation()
                self.view.isUserInteractionEnabled = true
                    
                    self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.performSegue(withIdentifier: "S_Request_SearchingLawyer", sender:nil)
                            
                } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                self.ConfirmButton.stopAnimation()
                self.view.isUserInteractionEnabled = true
                }
                })

            
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("pleaseChooseDeliveryLocation"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            
        }
        
    
        
    }
    

}

extension DeliveryLocationViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cellWatheqCat:WatheqTableViewCell = tableView.dequeueReusableCell(withIdentifier:"WatheqTableViewCell") as UITableViewCell! as! WatheqTableViewCell
        
        if indexPath.row == 0
        {
            cellWatheqCat.lblCatName.text = NSLocalizedString("office", comment: "" )
            cellWatheqCat.imgCatIcon.image = UIImage.init(named: "ic_office")
            if let DeliveryLocation : String =  OrderDataDic.value(forKey: "delivery") as? String
            {
               if DeliveryLocation == "office"
               {
                cellWatheqCat.viewContainer.backgroundColor = UIColor.deepBlue
                cellWatheqCat.imgCatIcon.image = UIImage.init(named: "ic_office_active")
                cellWatheqCat.lblCatName.textColor = UIColor.white

               }
                else
               {
                cellWatheqCat.viewContainer.backgroundColor = UIColor.white
                cellWatheqCat.lblCatName.textColor = UIColor.deepBlue


                }
                
            }
        }
        else
        {
            cellWatheqCat.lblCatName.text = NSLocalizedString("home", comment:"" )
            cellWatheqCat.imgCatIcon.image = UIImage.init(named: "ic_home")
            if let DeliveryLocation : String =  OrderDataDic.value(forKey: "delivery") as? String
            {
                if DeliveryLocation == "home"
                {
                    cellWatheqCat.viewContainer.backgroundColor = UIColor.deepBlue
                    cellWatheqCat.imgCatIcon.image = UIImage.init(named: "ic_home_active")
                    cellWatheqCat.lblCatName.textColor = UIColor.white

                }
                else
                {
                    cellWatheqCat.viewContainer.backgroundColor = UIColor.white
                    cellWatheqCat.lblCatName.textColor = UIColor.deepBlue

                }
            }

        }

        return cellWatheqCat
    }
    
}

extension DeliveryLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.24
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            OrderDataDic.setValue("office", forKey: "delivery")
            self.performSegue(withIdentifier: "S_Home_Location", sender: OrderDataDic)

        }
        else
        {
            OrderDataDic.setValue("home", forKey: "delivery")
            self.performSegue(withIdentifier: "S_Home_Location", sender: OrderDataDic)
        }
        self.tbl_DeliveryLocation.reloadData()
        
    }
    
    
}

