//
//  PhoneVerificationController.swift
//  FirebasePhone
//
//  Created by Ranjith Kumar on 9/2/17.
//  Copyright © 2017 Ranjith Kumar. All rights reserved.
//

import UIKit
import Firebase
import CountdownLabel


class PhoneVerificationController: UIViewController {
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton! {
        didSet {
            verifyButton.applyBorderProperties()
        }
    }
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var viewContainerPhoneTextFields: UIView!
        {
        didSet {
            viewContainerPhoneTextFields.applyviewBorderProperties()
        }
    }
    @IBOutlet weak var viewContainerVerificationTextFields: UIView!
        {
        didSet {
            viewContainerVerificationTextFields.applyviewBorderProperties()
        }
    }
    
    @IBAction func closeview (_ sender :Any)
    {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
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
    @IBOutlet weak var lbl_Timer: CountdownLabel!
    @IBOutlet weak var btnResendVerificationCode: UIButton!
    

    
    var verificationID:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Enter your 6 digit code"
        view.addTapToDismissKeyboard()
        self.addTimerLable()
    }
    
    func addTimerLable()
    {
        lbl_Timer.setCountDownTime(minutes: 300)
        lbl_Timer.animationType = .Sparkle
        lbl_Timer.countdownDelegate = self
        lbl_Timer.start() { [unowned self] in
    }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verificationCodeTextField.becomeFirstResponder()
    }
    
    //MARK: - Private Functions
    private func addLocaleCountryCode() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            localeCountry = countries.list.filter {($0.iso2Cc == countryCode)}.first
            countryCodeTextField.text = (localeCountry?.iso2Cc!)! + " " + "(+" + (localeCountry?.e164Cc!)! + ")"
        }
    }
   
    @IBAction func didTapVerifyFourDigitCode(_ sender: Any) {
        if verificationCodeTextField.text?.isEmpty == true {
            debugPrint("Enter your verification code!")
            return
        }
        view.endEditing(true)
        if let verificationCode = verificationCodeTextField.text {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }else {
                    debugPrint("Verified successfully")
                    //Once you have verified your phone number kill the firebase session.
                    try? Auth.auth().signOut()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

extension PhoneVerificationController: CountdownLabelDelegate {
    func countdownFinished() {
        debugPrint("countdownFinished at delegate.")
        UIView.animate(withDuration: 0.5, animations: {

            self.btnResendVerificationCode.alpha = 1
            self.lbl_Timer.alpha = 0


        })
    }

    func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {
        debugPrint("time counted at delegate=\(timeCounted)")
        debugPrint("time remaining at delegate=\(timeRemaining)")
    }

}

