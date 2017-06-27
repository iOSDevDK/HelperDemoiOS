//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    var dictLoginData = [String:String]()
    var strLoginType = "Coach"
    
    @IBOutlet weak var vwScroll : UIScrollView!
    
    @IBOutlet weak var vwContainer : UIView!
    
    @IBOutlet weak var lblTitle : UILabel!
    
    @IBOutlet weak var txtEmail : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    
    @IBOutlet weak var btnSignUp : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        /*
        if UserDefaults.standard.integer(forKey: "kUserType") == 1 {
            txtEmail.text = "eghrmcxp@sharklasers.com"
            txtPassword.text = "sachin@123"
        } else {
            txtEmail.text = "johnxs@gmail.com"//"test306user@gmail.com"
            txtPassword.text = "qwerty"//"8989551149"
        }*/
        
        //if strLoginType == "Coach"
        self.navigationItem.title = strLoginType
        //else
        if UserDefaults.standard.integer(forKey: "kUserType") == 1 {
            btnSignUp.isHidden = false
        } else {
            btnSignUp.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//------------------------------------------------------------------
// MARK: - LoginVC UI Methods
//------------------------------------------------------------------

extension LoginVC {
    
    func setUpLoginView() {
        txtEmail.borderStyle = .bezel
        txtEmail.backgroundColor = .white
        txtEmail.layer.borderColor = UIColor.white.cgColor
        txtEmail.layer.borderWidth = 2
        txtEmail.layer.shadowOffset = CGSize.zero
        
        txtPassword.borderStyle = .bezel
        txtPassword.backgroundColor = .white
        txtPassword.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderWidth = 2
        txtPassword.layer.shadowOffset = CGSize.zero
    }
    
}

//------------------------------------------------------------------
// MARK: - Custom Methods
//------------------------------------------------------------------

extension LoginVC {
    
    func displayAlertMessage(strMessage: String) {
        let alertController = UIAlertController(title: kAppName, message: strMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkLoginValidation() -> Bool {
        var isValid : Bool = true
        
        if txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            if validataEmail(strEmail: txtEmail.text) {
                txtEmail.layer.borderColor = UIColor.white.cgColor
            } else {
                txtEmail.layer.borderColor = UIColor.red.cgColor
                isValid = false
                displayAlertMessage(strMessage: "Please Enter Valid Email.")
            }
        } else {
            txtEmail.layer.borderColor = UIColor.red.cgColor
            isValid = false
            displayAlertMessage(strMessage: "Please Enter Email.")
        }
        
        if txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            if validataPasswordLength(strPassword: txtPassword.text) {
                txtPassword.layer.borderColor = UIColor.white.cgColor
            } else {
                txtPassword.layer.borderColor = UIColor.red.cgColor
                if isValid == true {
                    isValid = false
                    displayAlertMessage(strMessage: "Please Enter Password.")
                }
            }
        } else {
            txtPassword.layer.borderColor = UIColor.red.cgColor
            if isValid == true {
                isValid = false
                displayAlertMessage(strMessage: "Please Enter Password.")
            }
        }
        
        return isValid
    }
}

//------------------------------------------------------------------
// MARK: - Action Methods
//------------------------------------------------------------------

extension LoginVC {
    
    @IBAction func btnBackTapped(_ sender: Any) {
    //func btnBackTapped() {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnSignInTapped(_ sender: Any) {
        let isValidData = checkLoginValidation()
        print("isValidData :: ",isValidData)
        // device_type: "1-iOS" & "2-Android"
        if isValidData == true {
            let deviceToken = getDefaultsValueForKey("keyDeviceToken") //"\(UserDefaults.standard.object(forKey: "keyDeviceToken"))"
            let strUserType = (UserDefaults.standard.integer(forKey: "kUserType") == 1 ? "1":"2")
            
            let dictRegisterData = ["email":"\(txtEmail.text!)","password":"\(txtPassword.text!)","device_token":deviceToken,"device_type":"1","login_type":"\("\(strUserType)")"]
            
            //UserDefaults.standard.set("\(txtPassword.text!)", forKey: "user_Password")
            //UserDefaults.standard.synchronize()
            
            emailLogin(dictParams: dictRegisterData)
        }
         
    }
    
    @IBAction func btnSignUpTapped(_ sender: Any) {
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: Any) {
        let alertCreateCategory = UIAlertController(title: kAppName, message: "Forgot Password?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            
            let firstTextField = alertCreateCategory.textFields![0] as UITextField
            
            print("firstTextField = ", firstTextField.text as Any)
            DispatchQueue.main.async {
                let strUserType = (UserDefaults.standard.integer(forKey: "kUserType") == 1 ? "1":"2")
                if firstTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
                    self.forgotPassword(dictParams: ["email":"\(firstTextField.text!)","login_type":"\("\(strUserType)")"])
                } else {
                    self.displayAlertMessage(strMessage: "Please Enter Email.")
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertCreateCategory.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Email Id"
            textField.keyboardType = .emailAddress
        }
        
        alertCreateCategory.addAction(saveAction)
        alertCreateCategory.addAction(cancelAction)
        self.present(alertCreateCategory, animated: true, completion: nil)
    }
}

//------------------------------------------------------------------
// MARK: - UITextField Delegate Methods
//------------------------------------------------------------------

extension LoginVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.placeholder == "Email" {
            textField.keyboardType = .emailAddress
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            textField.spellCheckingType = .no
        }
        txtEmail.layer.borderColor = UIColor.white.cgColor
        txtPassword.layer.borderColor = UIColor.white.cgColor
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag == 10 {
            print(textField.text!)
        } else {
            print(textField.text!)
        }
        return true
    }
    
}

extension Dictionary {
    
    /// An immutable version of update. Returns a new dictionary containing self's values and the key/value passed in.
    func updatedValue(_ value: Value, forKey key: Key) -> Dictionary<Key, Value> {
        var result = self
        result[key] = value
        return result
    }
    
    var nullsRemoved: [Key: Value] {
        let tup = filter { !($0.1 is NSNull) }
        print("tup == ",tup)
        return tup.reduce([Key: Value]()) { $0.0.updatedValue($0.1.value, forKey: $0.1.key) }
    }
    
}

//------------------------------------------------------------------
// MARK: - WebService Methods
//------------------------------------------------------------------

extension LoginVC {
    
    func emailLogin(dictParams: [String : String]) {
        print("dictParams = ",dictParams)
        appDel.showProgress()
        WebService.callPostWebService(strAPI: "login", requestParams: dictParams, successCompletionHandler: { (dictResponse) in

            DispatchQueue.main.async {
                appDel.hideProgress()
            }
            if "\(dictResponse["status"]!)" != "0" {
                DispatchQueue.main.async {
                    let window = appDel.window
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    // User is logged In.
                    
                    let dictUserData = dictResponse["result"]! as! [AnyObject]
                    print("dictUserData == ",dictUserData[0] as! [String:AnyObject])
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(dictUserData[0] as! [String:AnyObject], forKey: "CoachData")
                    UserDefaults.standard.synchronize()
                    
                    if UserDefaults.standard.integer(forKey: "kUserType") == 1 {
                        let objNavHome = mainStoryBoard.instantiateViewController(withIdentifier: kNavHomeVCIdentifier) as! UINavigationController
                        
                        UIView .transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            window?.rootViewController = objNavHome
                            window?.makeKeyAndVisible()
                        }, completion: nil)
                    } else {
                        let objNavHome = mainStoryBoard.instantiateViewController(withIdentifier: kTabHomeIdentifier) as! UITabBarController
                        
                        UIView .transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                            window?.rootViewController = objNavHome
                            window?.makeKeyAndVisible()
                        }, completion: nil)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.displayAlertMessage(strMessage: "\(dictResponse["message"]!)")
                }
            }
        }, messageCallBackHandler: { (dictResponse) in
            print(dictResponse)
        }) { (error) in
            print(error)
            DispatchQueue.main.async {
                appDel.hideProgress()
                                //if error._code == NSURLErrorTimedOut {
                //if error == NSURLErrorDomain || error._code == NSURLErrorTimedOut {
                    self.displayAlertMessage(strMessage: "Network Error Please try again.")
                //}
            }
        }
    }
    
    func forgotPassword(dictParams: [String : String]) {
        
        if validataEmail(strEmail: "\(dictParams["email"]!)") {
            print("dictParams = ",dictParams)
            appDel.showProgress()
            WebService.callPostWebService(strAPI: "forgotPassword", requestParams: dictParams, successCompletionHandler: { (dictResponse) in
                
                DispatchQueue.main.async {
                    appDel.hideProgress()
                }
                if "\(dictResponse["status"]!)" != "0" {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            self.displayAlertMessage(strMessage: "\(dictResponse["message"]!)")
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.displayAlertMessage(strMessage: "\(dictResponse["message"]!)")
                    }
                }
            }, messageCallBackHandler: { (dictResponse) in
                print(dictResponse)
            }) { (error) in
                print(error)
            }
        } else {
            displayAlertMessage(strMessage: "Please Enter Valid Email.")
        }
    }
}

