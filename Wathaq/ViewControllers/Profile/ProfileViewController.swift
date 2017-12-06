//
//  ProfileViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import MXParallaxHeader
import Kingfisher



class ProfileViewController: UIViewController,MXParallaxHeaderDelegate {
    @IBOutlet weak var tbl_Orders: UITableView!
    var viewModel: UserViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()

        self.title = NSLocalizedString("profile", comment: "")
//        if #available(iOS 11.0, *) {
//            self.navigationController?.navigationBar.prefersLargeTitles = true
//            let attributes = [
//                NSAttributedStringKey.foregroundColor : UIColor.deepBlue,
//                NSAttributedStringKey.font :  UIFont(name: Constants.FONTS.FONT_PARALLAX_AR, size: 30)
//                ]
//            
//            navigationController?.navigationBar.largeTitleTextAttributes = attributes
//        }
        self.addHeaderData()
    }
    
    override  func viewDidLayoutSubviews() {
       
    }
    
   func addHeaderData()
   {
    let MainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
    let ProfileHeader:ProfileHeaderView = MainStoryBoard.instantiateViewController(withIdentifier: "ProfileHeaderView") as! ProfileHeaderView
    ProfileHeader.view.frame = CGRect(x: 0, y: 0, width: self.view.width, height: 300)
    tbl_Orders.parallaxHeader.view = ProfileHeader.view // You can set the parallax header view from the floating view
    tbl_Orders.parallaxHeader.height = 300
    tbl_Orders.parallaxHeader.mode = MXParallaxHeaderMode.fill
    tbl_Orders.parallaxHeader.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tbl_Orders.parallaxHeader.minimumHeight = topLayoutGuide.length
    }
    
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        NSLog("progress %f", parallaxHeader.progress)
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
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellSettings:SettingsTableCell = tableView.dequeueReusableCell(withIdentifier:"SettingsTableCell") as UITableViewCell! as! SettingsTableCell
        
        
        return cellSettings
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.08
    }
    
}

