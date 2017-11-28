//
//  PhoneEntryController.swift
//  FirebasePhone
//
//  Created by Ranjith Kumar on 8/28/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit
import Firebase
import CountdownLabel
import Hero


class PhoneEntryController: UIViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var viewContainerPhoneTextFields: UIView!
        {
        didSet {
            viewContainerPhoneTextFields.applyviewBorderProperties()
        }
    }
    @IBOutlet weak var countryCodeTextField: UITextField! {
        didSet {
            countryCodeTextField.textColor = UIView().tintColor
            countryCodeTextField.layer.borderWidth = 1.5
            countryCodeTextField.layer.borderColor = countryCodeTextField.textColor?.cgColor
            countryCodeTextField.layer.cornerRadius = 3.0
            addLocaleCountryCode()
        }
    }
    let countries:Countries = {
        return Countries.init(countries: JSONReader.countries())
    }()
    var localeCountry:Country?
    
   
    @IBOutlet weak var sendCodeButton: UIButton!{
        didSet {
            sendCodeButton.applyBorderProperties()
        }
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
       // navigationItem.titleView = titleView()
        view.addTapToDismissKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
    }
    
    @IBAction func closeview (_ sender :Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func titleView()->UILabel {
        let label = UILabel()
        label.text = "Entry Scene\n(Watch debug console for the Errors)"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.sizeToFit()
        return label
    }
    
    //MARK: - Private Functions
    private func addLocaleCountryCode() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            localeCountry = countries.list.filter {($0.iso2Cc == countryCode)}.first
            countryCodeTextField.text = (localeCountry?.iso2Cc!)! + " " + "(+" + (localeCountry?.e164Cc!)! + ")"
        }
    }
    
    
    //MARK: - Button Actions
    @IBAction func didTapSendCode(_ sender: Any) {
        
        self.performSegue(withIdentifier: "S_PhoneEntery_PhoneVerify", sender: nil)

//        if phoneTextField.text?.characters.count == 0 {
//            debugPrint("Enter Phone number!")
//            return
//        }
//        view.endEditing(true)
//        let phoneNumber = "+" + (localeCountry?.e164Cc!)! + phoneTextField.text!
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber) { (verificationID, error) in
//            if let error = error {
//                debugPrint(error.localizedDescription)
//                return
//            }
//            guard let verificationID = verificationID else { return }
//            let verifyScene = PhoneVerificationController()
//            verifyScene.verificationID = verificationID
//            self.performSegue(withIdentifier: "S_PhoneEntery_PhoneVerify", sender: nil)
//        }
    }
    
//    @IBAction func didTapShowCountryCode(_ sender: Any) {
//        let listScene = CountryCodeListController()
//        listScene.delegate = self
//        listScene.countries = countries
//        navigationController?.pushViewController(listScene, animated: true)
//    }
    
    //MARK: - countryPickerProtocol functions
//    func didPickCountry(model: Country) {
//        localeCountry = model
//        countryCodeTextField.text = model.iso2Cc! + " " + "(+" + model.e164Cc! + ")"
//    }
    
}



extension UIButton {
    func applyBorderProperties() {
        layer.borderWidth = 1.5
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 10.0
    }
}

extension UIView {
    func applyviewBorderProperties() {
        layer.borderWidth = 1.5
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 10.0
    }
}



