//
//  ChooseMaazonLocationViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/1/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import TransitionButton


class ChooseMaazonLocationViewController: UIViewController,ToastAlertProtocol{
    
    var viewModel: OrderViewModel!
    var CatObj : Category!

    var IsMovingPrgressBarDrawn = false
    var TotalCost : Int!
    var NumOfSteps : Int!
    
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
        TotalCost = CatObj.cost
        lblServiceTotalPrice.text = "\(TotalCost as Int) \(NSLocalizedString("SR", comment: "") as String)"
        OrderDataDic = NSMutableDictionary ()
        OrderDataDic.setValue(CatObj.id, forKey: "categoryId")
        ConfirmButton.setTitle(NSLocalizedString("nextStep", comment: ""), for: .normal)
        self.title = NSLocalizedString("Document marriage contract", comment: "")
        configureTitleView()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        
        //To Avoid Drawing moving progress bar every time loads view
        if IsMovingPrgressBarDrawn == false {
            viewMovingProgressBar.alpha = 0
            viewMovingProgressBar.width = viewTotalProgressBar.frame.size.width / CGFloat(2)
            viewMovingProgressBar.x = -viewMovingProgressBar.width
            viewMovingProgressBar.alpha = 1
            viewTotalProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
            viewMovingProgressBar.roundCorners([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 5)
            
            UIView.animate(withDuration: 2.0, animations: {
                self.viewMovingProgressBar.x = 0
            }, completion: { (true) in
                self.IsMovingPrgressBarDrawn = true
                
            })
            
        }
        
        
        
    }

    
    func configureTitleView() {
        
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @IBAction func nextStep (_ sender : Any)
    {
        if  (OrderDataDic.value(forKey: "delivery") != nil)
        {
        self.performSegue(withIdentifier: "S_MaazonLocation_MaazonData", sender: OrderDataDic)
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("ChooseDeliveryLocation"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_MaazonLocation_MaazonData"  {
            let OrderDic = sender as!  NSMutableDictionary
            let maazonDataView = segue.destination as! MaazonDataViewController
            maazonDataView.OrderDataDic = OrderDic
            maazonDataView.TotalCost = self.TotalCost
        }
    }

}

extension ChooseMaazonLocationViewController: UITableViewDataSource {
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
            cellWatheqCat.lblCatName.text = NSLocalizedString("MaazonLocation", comment: "" )
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
            cellWatheqCat.lblCatName.text = NSLocalizedString("ClientLocation", comment:"" )
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

extension ChooseMaazonLocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.24
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            OrderDataDic.setValue("office", forKey: "delivery")
            
        }
        else
        {
            OrderDataDic.setValue("home", forKey: "delivery")
        }
        self.tbl_DeliveryLocation.reloadData()
    }
}
