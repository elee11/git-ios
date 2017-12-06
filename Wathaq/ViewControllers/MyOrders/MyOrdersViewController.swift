//
//  MyOrdersViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {

    @IBOutlet weak var sendCodeButton: UIButton!
    @IBOutlet weak var view_bg: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
          self.navigationController?.isHeroEnabled = true
         self.isHeroEnabled = true
        view.heroModifiers = [.useLayerRenderSnapshot]
        self.title = NSLocalizedString("myOrders", comment: "")
     

        NotificationCenter.default.addObserver(self, selector: #selector(self.NWConnectivityDidChangeCalled) , name: .NWConnectivityDidChange, object: nil)

    }
    
    
    
    override  func viewDidLayoutSubviews() {
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            let attributes = [
                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
            ]
            
            navigationController?.navigationBar.largeTitleTextAttributes = attributes
        }

        
        self.tabBarItem.title = NSLocalizedString("myOrders", comment: "")

    }
    
    @objc func NWConnectivityDidChangeCalled() {
        print("=========================")
        print("network connectivity changed")
        print("=========================")
        
        if NWConnectivity.sharedInstance.isConnectedToInternet() {
            print("========================= Connected ")
        }
    }
    
    @IBAction func didTapSendCode(_ sender: Any) {
        
        
        self.view_bg.heroModifiers = [.fade, .translate(x:0, y:-250), .rotate(x:-1.6), .scale(1.5)]

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
