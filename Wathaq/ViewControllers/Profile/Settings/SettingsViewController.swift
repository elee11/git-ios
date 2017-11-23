//
//  SettingsViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,RefreshAppProtocol {
    @IBOutlet weak var tbl_settings: UITableView!
    var plistArr: NSMutableArray?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Settings", comment: "")
       
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
    
    
    
    
        func changeLanguage() {
        var languagesArr = [[String: String]]()
        let keysArr = [Constants.Language.ARABIC, Constants.Language.ENGLISH]
        let valuesArr = [NSLocalizedString("Arabic", comment: "") , NSLocalizedString("English", comment: "")]
        languagesArr.append([keysArr[0] : valuesArr[0]])
        languagesArr.append([keysArr[1] : valuesArr[1]])
        let selectedLanguageIndex = keysArr.index(of: Language.getCurrentLanguage())
        var selectedLanguage : String!
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: NSLocalizedString("Change Language",comment:""), preferredStyle: .actionSheet)
        let ArabicButton = UIAlertAction(title: NSLocalizedString("Arabic", comment: ""), style: .default) { _ in
            selectedLanguage = "ar"
            self.refreshAppDependOnLanguage(language: selectedLanguage)
        }
        actionSheetController.addAction(ArabicButton)
        let EnglishButton = UIAlertAction(title: NSLocalizedString("English", comment: ""), style: .default) { _ in
            selectedLanguage = "en"
            self.refreshAppDependOnLanguage(language: selectedLanguage)
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
            //this is login cell
            if indexPath.row == 4
            {
                cellSettings.viewSepartor.isHidden = true
                
            }
            
        }
        else if  indexPath.section == 1
        {
            if indexPath.row == 2
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
            if indexPath.row == 4
            {
                cell.roundCorners([.bottomLeft, .bottomRight], radius: 10)
            }
        }
        else if  indexPath.section == 1
        {
            if indexPath.row == 2
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


