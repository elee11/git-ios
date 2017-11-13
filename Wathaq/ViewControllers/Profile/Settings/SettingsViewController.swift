//
//  SettingsViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 11/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,RefreshAppProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
     @IBAction func changeLanguage(_ sender: Any) {
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
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
