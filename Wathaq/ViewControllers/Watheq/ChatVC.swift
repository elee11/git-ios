//  MIT License

//  Copyright (c) 2017 Satish Babariya

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit
import Photos
import Firebase
import CoreLocation

class ChatVC: UIViewController, UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
    
    //MARK: Properties
    var OrderObj : Orderdata!
    var MoawtheqObj : MowatheqData!
    @IBOutlet var inputBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var custmoizeBackButton : Bool!

    override var inputAccessoryView: UIView? {
        get {
            self.inputBar.frame.size.height = self.barHeight
            self.inputBar.clipsToBounds = true
            return self.inputBar
        }
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    let locationManager = CLLocationManager()
    var items = [Message]()
    let imagePicker = UIImagePickerController()
    let barHeight: CGFloat = 50
    var currentUser: User?
    var canSendLocation = true
    
    //MARK: Methods
    func customization() {
        self.imagePicker.delegate = self
        self.tableView.estimatedRowHeight = self.barHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset.bottom = self.barHeight
        self.tableView.scrollIndicatorInsets.bottom = self.barHeight
        self.locationManager.delegate = self
        if custmoizeBackButton == true
        {
            self.navigationItem.setHidesBackButton(true, animated: false)
            
            
            var strIconName :String!
            var lang = Language.getCurrentLanguage()

            if lang.contains("en")
            {
                strIconName = "ic_arrow_r"
            }
            else
            {
                strIconName = "ic_arrow_l"

            }
            
            let icon = UIImage.init(named: strIconName)?.withRenderingMode(.alwaysOriginal)
            let backButton = UIBarButtonItem.init(image: icon!, style: .plain, target: self, action: #selector(self.dismissSelf))
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    
    //Hides current viewcontroller
    @objc func dismissSelf() {
        if let navController = self.navigationController {
            self.navigationController!.popToRootViewController(animated: true)
        }
    }
    
  
    
    //Downloads messages
    func fetchData() {
        Message.downloadAllMessages(toID: "\(MoawtheqObj.id! as! Int)", orderId: "\(OrderObj.id! as! Int)", completion: {
            [weak weakSelf = self] (message) in
            weakSelf?.items.append(message)
            weakSelf?.items.sort{ $0.timestamp < $1.timestamp }
            DispatchQueue.main.async {
                if let state = weakSelf?.items.isEmpty, state == false {
                    weakSelf?.tableView.reloadData()
                    weakSelf?.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: false)
                }
            }
        })
    }
    

    
    func composeMessage(type: MessageType, content: Any)  {
        
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User
        let message = Message.init(from:"\(userObj!.userID as! Int)" , to:"\(MoawtheqObj.id! as! Int)"    , body:content as! String, timestamp: Int(Date().timeIntervalSince1970), dayTimestamp: 123333333)
        Message.send(message: message, toID:"\(MoawtheqObj.id! as! Int)", orderId:"\(OrderObj.id! as! Int)"   , completion: {(_) in
        })
    }
    
    
    func animateExtraButtons(toHide: Bool)  {
        switch toHide {
        case true:
            self.bottomConstraint.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        default:
            self.bottomConstraint.constant = -50
            UIView.animate(withDuration: 0.3) {
                self.inputBar.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func showMessage(_ sender: Any) {
        self.animateExtraButtons(toHide: true)
    }
    


    
   
    
    @IBAction func sendMessage(_ sender: Any) {
        if let text = self.inputTextField.text {
            if text.characters.count > 0 {
                self.composeMessage(type: .text, content: self.inputTextField.text!)
                self.inputTextField.text = ""
            }
        }
    }
    
    

    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            if self.items.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    //MARK: Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let userObj:User? = UserDefaults.standard.rm_customObject(forKey: Constants.keys.KeyUser) as? User

        
        if  (self.items[indexPath.row].from == "\(userObj?.userID as! Int)")
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Sender", for: indexPath) as! SenderCell
            cell.clearCellData()
            // cell.profilePic.image = self.userObj?.profilePic
            cell.message.text = self.items[indexPath.row].body as! String

            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Receiver", for: indexPath) as! ReceiverCell
            cell.clearCellData()
            cell.message.text = self.items[indexPath.row].body as! String

            return cell
        }
        
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {

    }


    //MARK: ViewController lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        self.view.layoutIfNeeded()
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func configureTitleView() {
        
        
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customization()
        self.fetchData()
        self.configureTitleView()
    }
}



