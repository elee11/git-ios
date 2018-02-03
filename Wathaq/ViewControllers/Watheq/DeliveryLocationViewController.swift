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
   
    var TotalCost : Int!
    var NumOfSteps : Int!

    var IsMovingPrgressBarDrawn = false

    @IBOutlet weak var lblServiceTotalPrice: UILabel!
    @IBOutlet weak var viewTotalProgressBar: UIView!
    @IBOutlet weak var viewMovingProgressBar: UIView!
    
    @IBOutlet weak var tbl_DeliveryLocation: UITableView!
    @IBOutlet weak var ConfirmButton: TransitionButton! {
        didSet {
            ConfirmButton.applyBorderProperties()
        }
    }
    var OrderDataDic : NSMutableDictionary!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblServiceTotalPrice.text = "\(TotalCost as Int) \(NSLocalizedString("SR", comment: "") as String)"
        ConfirmButton.setTitle(NSLocalizedString("nextStep", comment: ""), for: .normal)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        
        if IsMovingPrgressBarDrawn == false {
            viewMovingProgressBar.alpha = 0
            viewMovingProgressBar.width = viewTotalProgressBar.frame.size.width / CGFloat(NumOfSteps)
            viewMovingProgressBar.x = -viewMovingProgressBar.width
            viewMovingProgressBar.alpha = 1
            viewTotalProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
            viewMovingProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
            
            UIView.animate(withDuration: 2.0, animations: {
                // self.viewMovingProgressBar.layer.position.x = 0
                self.viewMovingProgressBar.x = 0
            }, completion: { (true) in
                self.IsMovingPrgressBarDrawn = true
                
            })
            
        }
        
    }
    
    
    @IBAction func NextStepAction(_ sender: Any) {
        
        if  (OrderDataDic.value(forKey: "delivery") != nil)
        {
            self.performSegue(withIdentifier: "S_Home_Location", sender: OrderDataDic)
        }
        
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

