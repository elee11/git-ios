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
import TransitionButton


class PhoneVerificationController: UIViewController,ToastAlertProtocol {
 
    
    var viewModel: UserViewModel!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var lblLoginMsg: UILabel!
    @IBOutlet weak var lblaskingAboutNotarizedMsg: UILabel!
    @IBOutlet weak var btnDowndlowadNotarizedApp: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var verificationCodeTextField: UITextField!
    @IBOutlet weak var verifyButton: TransitionButton! {
        didSet {
            verifyButton.applyBorderProperties()
        }
    }
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var viewContainerPhoneTextFields: UIView!
        {
        didSet {
            viewContainerPhoneTextFields.applyDimmviewBorderProperties()
        }
    }
    @IBOutlet weak var viewContainerVerificationTextFields: UIView!
        {
        didSet {
            viewContainerVerificationTextFields.applyDimmviewBorderProperties()
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
    var PhoneNumber:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserViewModel()

        title = "Enter your 6 digit code"
        view.addTapToDismissKeyboard()
        self.addTimerLable()
    }
    
    func addTimerLable()
    {
        viewContainerPhoneTextFields.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            
            self.btnResendVerificationCode.alpha = 0
            self.lbl_Timer.alpha = 1
            
            
        })
        
        lbl_Timer.setCountDownTime(minutes: 300)
        lbl_Timer.animationType = .Sparkle
        lbl_Timer.countdownDelegate = self
        lbl_Timer.start() { [unowned self] in
    }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        verificationCodeTextField.becomeFirstResponder()
        lblLogin.text = NSLocalizedString("login", comment: "")
        lblLoginMsg.text = NSLocalizedString("LoginMsg", comment: "")
        lblaskingAboutNotarizedMsg.text = NSLocalizedString("areyoulegalized", comment: "")
        btnDowndlowadNotarizedApp.setTitle(NSLocalizedString("Download the Notaries application from here", comment: ""), for: .normal)
        phoneTextField.placeholder = NSLocalizedString("PhoneNum", comment: "")
        phoneTextField.text = PhoneNumber
        verificationCodeTextField.placeholder = NSLocalizedString("VerificationCode", comment: "")
        verifyButton.setTitle(NSLocalizedString("sendVerificationCode", comment: ""), for: .normal)
        btnResendVerificationCode.setTitle(NSLocalizedString("ResendVerificationCode", comment: ""), for: .normal)
        btnClose.setTitle(NSLocalizedString("close", comment: ""), for: .normal)
        btnDowndlowadNotarizedApp.titleLabel?.textAlignment = .center
        

    }
    
    //MARK: - Private Functions
    private func addLocaleCountryCode() {
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            localeCountry = countries.list.filter {($0.iso2Cc == countryCode)}.first
            countryCodeTextField.text = (localeCountry?.iso2Cc!)! + " " + "(+" + (localeCountry?.e164Cc!)! + ")"
        }
    }
    
    @IBAction func resendVerificationCode(_ sender: Any) {
        view.endEditing(true)
        if phoneTextField.text?.characters.count == 0 {
            self.showToastMessage(title: NSLocalizedString("Enter Phone number", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            
            return
        }
        verifyButton.startAnimation()
        self.view.isUserInteractionEnabled = false
        let phoneNumber = "+" + (localeCountry?.e164Cc!)! + phoneTextField.text!
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber) { (verificationTagID, error) in
            if let error = error {
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    switch errorCode {
                    case .invalidPhoneNumber:
                        self.showToastMessage(title: NSLocalizedString("Enter avalid Phone number", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                        break
                    case .networkError:
                        self.showToastMessage(title: NSLocalizedString("No_Internet", comment: ""), isBottom: true, isWindowNeeded: false, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                        break
                    default:
                        print("There is an error")
                    }
                }
                self.verifyButton.stopAnimation()
                self.view.isUserInteractionEnabled = true
                return
            }
            self.verifyButton.stopAnimation()
            self.view.isUserInteractionEnabled = true

            guard let verificationTagID = verificationTagID else { return }
            self.verificationID = verificationTagID
            self.showToastMessage(title: NSLocalizedString("Verification Code sent succussfully", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
            self.addTimerLable()
            
        }
    }

   
    @IBAction func didTapVerifyFourDigitCode(_ sender: Any) {
        view.endEditing(true)

        if verificationCodeTextField.text?.isEmpty == true {
            self.showToastMessage(title: NSLocalizedString(("Enter your verification code"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            return
        }
        verifyButton.startAnimation()
        self.view.isUserInteractionEnabled = false
        if let verificationCode = verificationCodeTextField.text {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                   
                    if let errorCode = AuthErrorCode(rawValue: error._code) {
                        switch errorCode {
                        case .invalidVerificationCode:
                            self.showToastMessage(title: NSLocalizedString("Enter avalid verification number", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                            break
                        case .networkError:
                            self.showToastMessage(title: NSLocalizedString("No_Internet", comment: ""), isBottom: true, isWindowNeeded: false, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                            break
                        case .sessionExpired:
                            self.showToastMessage(title: NSLocalizedString("Session Expired", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                            break
                        case .userDisabled:
                            self.showToastMessage(title: NSLocalizedString("User Disabled", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                            break
                        default:
                            print("There is an error")
                        }
                    }
                    self.verifyButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true

                }else {
                    //Once you have verified your phone number kill the firebase session.
                    try? Auth.auth().signOut()
                    self.showToastMessage(title: NSLocalizedString("Your Phone verified successfully", comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    self.performSegue(withIdentifier:"S_VerifyNumber_CompleteProfile", sender: nil
                    )
                    self.loginUserWithPhoneNumber ()


                }
            }
        }
    }
    
    func loginUserWithPhoneNumber ()
    {
        let phoneNumber = "+" + (localeCountry?.e164Cc!)! + phoneTextField.text!

        var phoneDict = [String:String]()
        phoneDict ["phone"] = phoneNumber
        
        viewModel.loginUser(Phone: phoneDict, completion: { (userObj, errorMsg) in
            if errorMsg == nil {

            } else{
                self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            }
        })

    }
}

extension PhoneVerificationController: CountdownLabelDelegate {
    func countdownFinished() {
        debugPrint("countdownFinished at delegate.")
        viewContainerPhoneTextFields.isUserInteractionEnabled = true

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

extension PhoneVerificationController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == verificationCodeTextField {
            viewContainerVerificationTextFields.applyActiveviewBorderProperties()
            viewContainerPhoneTextFields.applyDimmviewBorderProperties()

        }
        else
        {
            viewContainerPhoneTextFields.applyActiveviewBorderProperties()
            viewContainerVerificationTextFields.applyDimmviewBorderProperties()


        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == verificationCodeTextField {
            viewContainerVerificationTextFields.applyDimmviewBorderProperties()
        }
        else
        {
            viewContainerPhoneTextFields.applyDimmviewBorderProperties()

        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == verificationCodeTextField {
        if(range.length + range.location > (textField.text?.length)!)
                {
                    return false
                }
                let  newLength = (textField.text?.length)! + string.length - range.length;
                return newLength <= 6;
            }
    else
    {
    return true

    }
}
}


