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
import TransitionButton


class PhoneEntryController: UIViewController,ToastAlertProtocol {
 
    
    var localeCountry:Country?

    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblLoginMsg: UILabel!
    @IBOutlet weak var lblaskingAboutNotarizedMsg: UILabel!
    @IBOutlet weak var btnDowndlowadNotarizedApp: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var viewContainerPhoneTextFields: UIView!
        {
        didSet {
            viewContainerPhoneTextFields.applyDimmviewBorderProperties()
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
    @IBOutlet weak var sendCodeButton: TransitionButton!{
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
        view.addTapToDismissKeyboard()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        phoneTextField.becomeFirstResponder()
        super.viewWillAppear(animated)
    }
    
    override  func viewDidLayoutSubviews() {
        lblLogin.text = NSLocalizedString("login", comment: "")
        lblLoginMsg.text = NSLocalizedString("LoginMsg", comment: "")
        lblaskingAboutNotarizedMsg.text = NSLocalizedString("areyoulegalized", comment: "")
        btnDowndlowadNotarizedApp.setTitle(NSLocalizedString("Download the Notaries application from here", comment: ""), for: .normal)
        phoneTextField.placeholder = NSLocalizedString("PhoneNum", comment: "")
        sendCodeButton.setTitle(NSLocalizedString("sendPhoneNumber", comment: ""), for: .normal)
//        btnClose.setTitle(NSLocalizedString("close", comment: ""), for: .normal)
        btnDowndlowadNotarizedApp.titleLabel?.textAlignment = .center
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
        view.endEditing(true)
        if phoneTextField.text?.characters.count == 0 {
            self.showToastMessage(title: NSLocalizedString("Enter Phone number", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

            return
        }
         sendCodeButton.startAnimation()
        self.view.isUserInteractionEnabled = false
        let phoneNumber = "+" + (localeCountry?.e164Cc!)! + phoneTextField.text!
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber) { (verificationID, error) in
            if let error = error {
               
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .invalidPhoneNumber:
                        self.showToastMessage(title: NSLocalizedString("Enter avalid Phone number", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                        break
                    case .networkError:
                            self.showToastMessage(title: NSLocalizedString("No_Internet", comment: ""), isBottom: true, isWindowNeeded: false, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                        break
                    case .tooManyRequests:
                        self.showToastMessage(title: NSLocalizedString("Too Many Requests", comment: ""), isBottom: true, isWindowNeeded: false, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                        break

                    default:
                        print("There is an error")
                    }
                }
                self.sendCodeButton.stopAnimation()
                self.view.isUserInteractionEnabled = true

                return
            }
            guard let verificationID = verificationID else { return }
            self.performSegue(withIdentifier: "S_PhoneEntery_PhoneVerify", sender: verificationID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                if segue.identifier == "S_PhoneEntery_PhoneVerify"  {
                    let PhoneVerificationView = segue.destination as! PhoneVerificationController
                    PhoneVerificationView.PhoneNumber = phoneTextField.text
                    PhoneVerificationView.verificationID = sender as? String
                }
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

extension PhoneEntryController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        viewContainerPhoneTextFields.applyActiveviewBorderProperties()
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewContainerPhoneTextFields.applyDimmviewBorderProperties()

        
    }
   
}



extension UIButton {
    func applyBorderProperties() {
        layer.borderWidth = 1.5
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 10.0
    }
}

extension UIView {
    func applyActiveviewBorderProperties() {
        layer.borderWidth = 1.5
        layer.borderColor = tintColor?.cgColor
        layer.cornerRadius = 10.0
    }
    
    func applyDimmviewBorderProperties() {
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 10.0
    }
}





