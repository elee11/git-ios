//
//  SettingsViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import DAKeychain

class SettingsViewController: UIViewController,RefreshAppProtocol,ToastAlertProtocol {
    @IBOutlet weak var tbl_settings: UITableView!
    var plistArr: NSMutableArray?
    var viewModel: UserViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()
        
        self.title = NSLocalizedString("Settings", comment: "")
        self.navigationController?.isHeroEnabled = true
        plistArr = readPlistSettings()
        configureView()
    }
    
    
    
    func configureView() {
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    override  func viewDidLayoutSubviews() {
        
    }
    
    
    func Logout()
    {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to logout?",comment:""), preferredStyle: .actionSheet)
        
        let CancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
        }
        actionSheetController.addAction(CancelButton)
        
        let LogoutButton = UIAlertAction(title: NSLocalizedString("LogOut", comment: ""), style: .default) { _ in
            
            self.logoutAction()
        }
        actionSheetController.addAction(LogoutButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func logoutAction()
    {
        let UuidData : String!
        if let uuidvalue = DAKeychain.shared["uuid"]
        {
            UuidData = uuidvalue
            viewModel.logoutUser(identifier: UuidData) { (userObj, errorMsg) in
                if errorMsg == nil {
                    
                    self.viewModel.deleteUser()
                    let StoryBoard = singleToneClassValues.loadStoryBoardWithStoryboardName(_StoryboardName: "Main" as NSString)
                    let VerificationNavView = StoryBoard.instantiateViewController(withIdentifier: "PhoneEntryController")
                    UIApplication.shared.delegate?.window!?.rootViewController = VerificationNavView
                }
                else{
                    
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                }
            }
        }
        
        
    }
    
    
    func changeLanguage() {
        var selectedLanguage : String!
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Change Language",comment:""), preferredStyle: .actionSheet)
        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
        }
        actionSheetController.addAction(cancelButton)
        
        let ArabicButton = UIAlertAction(title: "العربية", style: .default) { _ in
            selectedLanguage = "ar"
            let langStr = Language.getCurrentLanguage()
            if langStr != selectedLanguage
            {
                self.refreshAppDependOnLanguage(language: selectedLanguage)
            }
        }
        actionSheetController.addAction(ArabicButton)
        
        let EnglishButton = UIAlertAction(title: "English", style: .default) { _ in
            selectedLanguage = "en"
            let langStr = Language.getCurrentLanguage()
            if langStr != selectedLanguage
            {
                self.refreshAppDependOnLanguage(language: selectedLanguage)
            }
        }
        actionSheetController.addAction(EnglishButton)
        
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func refreshAppDependOnLanguage(language: String) {
        Language.setAppLanguage(lang: language)
        if language == "ar" {
            // force RTL
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else{
            // force LTR
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        refreshAppWithAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Settings_WebView"  {
            let index = sender as!  Int
            let webView = segue.destination as! WebViewController
            if index == 0
            {
                webView.title = NSLocalizedString("Terms and Conditions", comment: "")
                webView.webPage = "http://159.89.41.54/watheq/public/terms"
            }
            else
            {
                webView.title = NSLocalizedString("Privacy Policy", comment: "")
                webView.webPage = "http://159.89.41.54/watheq/public/policy"
                
            }
            
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    // table view data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (plistArr?.object(at: section) as! NSMutableArray).count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (plistArr?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellSettings:SettingsTableCell = tableView.dequeueReusableCell(withIdentifier:"SettingsTableCell") as UITableViewCell! as! SettingsTableCell
        if let DicData: NSDictionary = (plistArr?.object(at: indexPath.section) as! NSMutableArray).object(at: indexPath.row) as? NSDictionary
        {
            var key = "Name_EN"
            if Language.getCurrentLanguage() == Constants.Language.ARABIC {
                key = "Name"
            }
            cellSettings.lblTitle.text = DicData.object(forKey:key) as? String
        }
        
        if indexPath.section == 0
        {
            //language cell
            if indexPath.row == 0
            {
                let langStr = Language.getCurrentLanguage()
                if langStr == "en"
                {
                    cellSettings.lblDetails.text = "English"
                }
                else
                {
                    cellSettings.lblDetails.text = "العربية"
                }
                cellSettings.lblDetails.isHidden = false
            }
            
            //this is login cell
            if indexPath.row == 3
            {
                cellSettings.viewSepartor.isHidden = true
            }
        }
        else if  indexPath.section == 1
        {
            if indexPath.row == 1
            {
                cellSettings.viewSepartor.isHidden = true
            }
        }
        
        return cellSettings
    }
    
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // For masking table view like ios 6 style
        if indexPath.row == 0
        {
            cell.roundCorners([.topLeft, .topRight], radius: 10)
        }
        if indexPath.section == 0
        {
            if indexPath.row == 3
            {
                cell.roundCorners([.bottomLeft, .bottomRight], radius: 10)
            }
        }
        else if  indexPath.section == 1
        {
            if indexPath.row == 1
            {
                cell.roundCorners([.bottomLeft, .bottomRight], radius: 10)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.view.frame.size.height * 0.08
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.section == 0
        {
            
            switch indexPath.row {
                
            case 0 :
                changeLanguage()
                break
            case 2 :
                self.performSegue(withIdentifier: "S_ContactUs", sender: nil)
                break
            case 3:
                Logout()
                break
            default:
                break
            }
            
        }
        else
        {
            switch indexPath.row
            {
            case 0 :
                self.performSegue(withIdentifier: "S_Settings_WebView", sender: indexPath.row)
                break
     
            case 1:
                self.performSegue(withIdentifier: "S_Settings_WebView", sender: indexPath.row)
                
                break
            default:
                break
            }
        }
        
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension SettingsViewController: PlistReaderProtocol {
    func readPlistSettings() -> NSMutableArray{
        let fileName = "SettingsList"
        let data =  (self as PlistReaderProtocol).readPlist(fileName: fileName)
        return data as! NSMutableArray
    }
}


