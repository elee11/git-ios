//
//  NotficationsViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class NotficationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("notifications", comment: "")
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

extension NotficationsViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        //        let cellLoader:MyOrderPlaceHolderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderPlaceHolderTableViewCell") as UITableViewCell! as! MyOrderPlaceHolderTableViewCell
        //
        //        cellLoader.gradientLayers.forEach { gradientLayer in
        //            let baseColor = cellLoader.lblLawerName.backgroundColor!
        //            gradientLayer.colors = [baseColor.cgColor,
        //                                    baseColor.brightened(by: 0.93).cgColor,
        //                                    baseColor.cgColor]
        //            gradientLayer.slide(to: .right)
        //        }
        //        return cellLoader
        
        let cellOrderCell:MyOrderTableViewCell = tableView.dequeueReusableCell(withIdentifier:"MyOrderTableViewCell") as UITableViewCell! as! MyOrderTableViewCell
        
        return cellOrderCell
    }
    
}

extension NotficationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.24
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}
