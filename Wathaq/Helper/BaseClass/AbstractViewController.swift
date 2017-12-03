//
//  AbstractViewController.swift
//  TrainiGate_iOS
//
//  Created by Zak on 5/29/17.
//  Copyright © 2017 ibtikar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwifterSwift
import SwiftMessages




class AbstractViewController: UIViewController,NVActivityIndicatorViewable,UIGestureRecognizerDelegate {
   
    //KeyBoard Dismissing
    var TapGesture = UITapGestureRecognizer ()
    var KbSize = CGSize ()
    //Loading Indicator
    var ActivityIndicatorView : NVActivityIndicatorView? = nil
    var ViewDim : UIView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.dismissKeyBoardWithGesture()
    }
    
    
//MARK: DismissKeyBoard
//    func dismissKeyBoardWithGesture() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name:.UIKeyboardDidShow , object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name:.UIKeyboardWillHide , object: nil)
//        TapGesture = UITapGestureRecognizer (target: self, action:#selector(endEditingandDismissKeyboard))
//        TapGesture.delegate = self
//    }
//    @objc func keyboardWasShown(_aNotification: NSNotification ) {
//        let Info : NSDictionary = _aNotification.userInfo! as NSDictionary
//       if let KbSize = Info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as? CGRect{
//            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: KbSize.height, right: 0)
//        }
//        self.view.addGestureRecognizer(TapGesture)
//    }
//    @objc func keyboardWillBeHidden(_aNotification: NSNotification ) {
//        self.view.removeGestureRecognizer(TapGesture)
//    }
//    @objc @objc func endEditingandDismissKeyboard(){
//        self.view.endEditing(true)
//    }
//
////MARK: Loading
//    func StartLoadingForAction(_IsAction : Bool)  {
//        if _IsAction {
//            ActivityIndicatorView = NVActivityIndicatorView (frame:CGRect(x: self.view.frame.midX-20, y: self.view.frame.midY-20, width: 40, height: 40), type:NVActivityIndicatorType.ballScaleRippleMultiple, color: .white, padding: 0)
//            ViewDim = UIView(frame: CGRect(x: self.view.frame.midX-30, y: self.view.frame.midY-30, width: 60, height: 60))
//            ViewDim?.backgroundColor = Colors.CL_Yellow_Topaz_Alpha
//            ViewDim?.roundCorners([UIRectCorner.topLeft , UIRectCorner.bottomLeft , UIRectCorner.topRight , UIRectCorner.bottomRight], radius: 4);
//            self.view.addSubview(ViewDim!)
//            self.view.addSubview(ActivityIndicatorView!)
//        }
//        else
//        {
//            ActivityIndicatorView = NVActivityIndicatorView (frame:CGRect(x: self.view.frame.midX-20, y: self.view.frame.midY-20, width: 40, height: 40), type:NVActivityIndicatorType.ballScaleRippleMultiple, color:Colors.CL_Yellow_Topaz , padding: 0)
//            self.view.addSubview(ActivityIndicatorView!)
//        }
//        ActivityIndicatorView?.startAnimating()
//    }
//
//    func stopLoading() {
//        ViewDim?.removeFromSuperview()
//        ActivityIndicatorView?.stopAnimating()
//    }
    
  
    
    //MARK: load storyboard
    func loadStoryBoardWithStoryboardName(_StoryboardName : NSString) -> UIStoryboard {
        let AppStoryBoard  = UIStoryboard (name: _StoryboardName as String, bundle: nil)
        return AppStoryBoard
    }
    
    //MARK: -Validate fields
    func isValidEmail(Mail:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: Mail)
    }
    
    func isValidPassword(Password :String) -> Bool {
        let PasswordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!$%@#£€*?&]{6,}$"
        let PasswordTest = NSPredicate(format:"SELF MATCHES %@", PasswordRegEx)
        return PasswordTest.evaluate(with: Password)
    }
    
   override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
