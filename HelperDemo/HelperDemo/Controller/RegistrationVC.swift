//
//  Created by iOSDevDK
//  Copyright © 2017 iOSDevDKs. All rights reserved.
//

import UIKit

class RegistrationVC: UIViewController {

    var dictRegisterData = [String:String]()
    
    var vwScroll : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white //kColorRoyalBlue
        //scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    var vwContainer : UIView = {
        let container = UIView()
        container.backgroundColor = .white //kColorRoyalBlue
        return container
    }()
    
    var vwAppLogo1 : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    var lblTitle : UILabel = {
        let lbl = UILabel()
        lbl.text = "REGISTRATION"
        lbl.backgroundColor = .clear
        lbl.textColor = kColorRoyalBlue
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 18)
        return lbl
    }()
    
    var txtEmail : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Email"
        txt.autocapitalizationType = .none
        txt.autocorrectionType = .no
        txt.spellCheckingType = .no
        txt.returnKeyType = .next
        txt.keyboardType = .emailAddress
        txt.borderStyle = .bezel
        txt.backgroundColor = .white
        txt.layer.borderColor = UIColor.white.cgColor
        txt.layer.borderWidth = 2
        txt.layer.shadowOffset = CGSize.zero
        txt.tag = 11
        return txt
    }()
    
    var vwLineEmail : UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        return container
    }()
    
    var txtUserName : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Coach Name"
        //txt.keyboardType = .phonePad
        txt.borderStyle = .bezel
        txt.backgroundColor = .white
        txt.layer.borderColor = UIColor.white.cgColor
        txt.layer.borderWidth = 2
        txt.layer.shadowOffset = CGSize.zero
        txt.autocapitalizationType = .none
        txt.autocorrectionType = .no
        txt.spellCheckingType = .no
        txt.returnKeyType = .done
        txt.tag = 10
        return txt
    }()
    
    var vwLineUser : UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        return container
    }()
    
    var txtPhoneNumber : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Phone"
        txt.keyboardType = .phonePad
        txt.borderStyle = .bezel
        txt.backgroundColor = .white
        txt.layer.borderColor = UIColor.white.cgColor
        txt.layer.borderWidth = 2
        txt.layer.shadowOffset = CGSize.zero
        txt.autocapitalizationType = .none
        txt.autocorrectionType = .no
        txt.spellCheckingType = .no
        txt.returnKeyType = .done
        txt.tag = 11
        return txt
    }()

    var vwLinePhone : UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        return container
    }()
    
    var txtExperience : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Experience"
        txt.keyboardType = .numberPad
        txt.borderStyle = .bezel
        txt.backgroundColor = .white
        txt.layer.borderColor = UIColor.white.cgColor
        txt.layer.borderWidth = 2
        txt.layer.shadowOffset = CGSize.zero
        txt.autocapitalizationType = .none
        txt.autocorrectionType = .no
        txt.spellCheckingType = .no
        txt.returnKeyType = .done
        txt.tag = 11
        return txt
    }()
    
    var vwLineExp : UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        return container
    }()
    
    var txtPassword : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        txt.autocapitalizationType = .none
        txt.autocorrectionType = .no
        txt.spellCheckingType = .no
        txt.returnKeyType = .done
        txt.borderStyle = .bezel
        txt.backgroundColor = .white
        txt.layer.borderColor = UIColor.white.cgColor
        txt.layer.borderWidth = 2
        txt.layer.shadowOffset = CGSize.zero
        txt.tag = 12
        return txt
    }()
    
    var vwLinePass : UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        return container
    }()

    var txtConfirmPassword : UITextField = {
        let txt = UITextField()
        txt.placeholder = "Password Confirm"
        txt.isSecureTextEntry = true
        txt.autocapitalizationType = .none
        txt.autocorrectionType = .no
        txt.spellCheckingType = .no
        txt.returnKeyType = .done
        txt.borderStyle = .bezel
        txt.backgroundColor = .white
        txt.layer.borderColor = UIColor.white.cgColor
        txt.layer.borderWidth = 2
        txt.layer.shadowOffset = CGSize.zero
        txt.tag = 13
        return txt
    }()
    
    var vwLineCPass : UIView = {
        let container = UIView()
        container.backgroundColor = .lightGray
        return container
    }()
    
    var btnSignIn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Already have account!, Sign in now.", for: .normal)
        btn.backgroundColor = kColorRoyalBlue
        btn.setTitleColor(kColorWhite, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    var btnSignUp : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("SIGN UP", for: .normal)
        btn.backgroundColor = kColorRoyalBlue
        btn.setTitleColor(kColorWhite, for: .normal)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        let barBtnCancel =  UIBarButtonItem(image: UIImage(named: "img_Back"), style: .done, target: self, action: #selector(btnBackTapped))
        self.navigationItem.leftBarButtonItem = barBtnCancel
        
        setUpRegistrationView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

//------------------------------------------------------------------
// MARK: - RegistrationVC UI Methods
//------------------------------------------------------------------

extension RegistrationVC {
    
    func setUpRegistrationView() {
        
        view.addSubview(vwScroll)
        vwScroll.addSubview(vwContainer)
        
        vwScroll.addAnchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        vwContainer.addAnchor(top: vwScroll.topAnchor, leading: vwScroll.leadingAnchor, bottom: vwScroll.bottomAnchor, trailing: vwScroll.trailingAnchor)
        vwContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        vwContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        vwContainer.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.height - self.navigationController!.navigationBar.frame.size.height - 20).isActive = true
        
        setUpContainerLogo()
        
        setUpEmailLoginView()
        setUpPhoneLoginView()
        
    }
    
    func setUpContainerLogo() {
        vwContainer.addSubview(vwAppLogo1)
        vwContainer.addSubview(lblTitle)
        
        vwAppLogo1.addAnchorWithConstants(top: vwContainer.topAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 30, leadingConstant: 0, bottomConstant: 0, trailingConstant: 0)
        vwAppLogo1.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        lblTitle.addAnchorWithConstants(top: vwAppLogo1.bottomAnchor, leading: vwAppLogo1.leadingAnchor, bottom: nil, trailing: vwAppLogo1.trailingAnchor, topConstant: 30, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
    }
    
    func setUpEmailLoginView() {
        vwContainer.addSubview(txtUserName)
        vwContainer.addSubview(txtEmail)
        vwContainer.addSubview(vwLineUser)
        vwContainer.addSubview(vwLineEmail)
        
        
        txtUserName.addAnchorWithConstants(top: lblTitle.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 20, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        txtUserName.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        vwLineUser.addAnchorWithConstants(top: txtUserName.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 0, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        vwLineUser.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        txtEmail.addAnchorWithConstants(top: txtUserName.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 10, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        txtEmail.heightAnchor.constraint(equalToConstant: 35).isActive = true

        vwLineEmail.addAnchorWithConstants(top: txtEmail.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 0, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        vwLineEmail.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpPhoneLoginView() {
        
        vwContainer.addSubview(txtPhoneNumber)
        vwContainer.addSubview(txtExperience)
        
        vwContainer.addSubview(txtPassword)
        vwContainer.addSubview(txtConfirmPassword)
        
        vwContainer.addSubview(btnSignUp)
        vwContainer.addSubview(btnSignIn)
        
        vwContainer.addSubview(vwLinePhone)
        vwContainer.addSubview(vwLineExp)
        vwContainer.addSubview(vwLinePass)
        vwContainer.addSubview(vwLineCPass)
        
        txtPhoneNumber.addAnchorWithConstants(top: txtEmail.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 10, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        txtPhoneNumber.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        vwLinePhone.addAnchorWithConstants(top: txtPhoneNumber.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 0, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        vwLinePhone.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        txtExperience.addAnchorWithConstants(top: txtPhoneNumber.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 10, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        txtExperience.heightAnchor.constraint(equalToConstant: 35).isActive = true

        vwLineExp.addAnchorWithConstants(top: txtExperience.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 0, leadingConstant:20, bottomConstant: 0, trailingConstant: -20)
        vwLineExp.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        txtPassword.addAnchorWithConstants(top: txtExperience.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 10, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        txtPassword.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        vwLinePass.addAnchorWithConstants(top: txtPassword.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 0, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        vwLinePass.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        txtConfirmPassword.addAnchorWithConstants(top: txtPassword.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 10, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        txtConfirmPassword.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        vwLineCPass.addAnchorWithConstants(top: txtConfirmPassword.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 0, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        vwLineCPass.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        btnSignUp.addAnchorWithConstants(top: txtConfirmPassword.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 20, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        btnSignUp.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        btnSignIn.addAnchorWithConstants(top: btnSignUp.bottomAnchor, leading: vwContainer.leadingAnchor, bottom: nil, trailing: vwContainer.trailingAnchor, topConstant: 20, leadingConstant: 20, bottomConstant: 0, trailingConstant: -20)
        btnSignIn.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        btnSignUp.addTarget(self, action: #selector(btnSignUpTapped), for: .touchUpInside)
        btnSignIn.addTarget(self, action: #selector(btnSignInTapped), for: .touchUpInside)
        
    }
    
}

//------------------------------------------------------------------
// MARK: - Custom Methods
//------------------------------------------------------------------

extension RegistrationVC {
    
    func displayAlertMessage(strMessage: String) {
        let alertController = UIAlertController(title: kAppName, message: strMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkRegistrationValidation() -> Bool {
        
        var isValid : Bool = true
        
        if (txtUserName.text)!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            txtUserName.layer.borderColor = UIColor.white.cgColor
        } else {
            txtUserName.layer.borderColor = UIColor.red.cgColor
            isValid = false
            displayAlertMessage(strMessage: "Please Enter Coach Name.")
        }
        
        if (txtEmail.text)!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            if validataEmail(strEmail: txtEmail.text) {
                txtEmail.layer.borderColor = UIColor.white.cgColor
            } else {
                txtEmail.layer.borderColor = UIColor.red.cgColor
                if isValid == true {
                    isValid = false
                    displayAlertMessage(strMessage: "Please Enter Valid Email.")
                }
            }
        } else {
            txtEmail.layer.borderColor = UIColor.red.cgColor
            if isValid == true {
                isValid = false
                displayAlertMessage(strMessage: "Please Enter Email.")
            }
        }
        
        if (txtPhoneNumber.text)!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            if validataPhoneNumber(strPhone: txtPhoneNumber.text) {
                txtPhoneNumber.layer.borderColor = UIColor.white.cgColor
            } else {
                txtPhoneNumber.layer.borderColor = UIColor.red.cgColor
                if isValid == true {
                    isValid = false
                    displayAlertMessage(strMessage: "Please Enter Valid Phone.")
                }
            }
        } else {
            txtPhoneNumber.layer.borderColor = UIColor.red.cgColor
            if isValid == true {
                isValid = false
                displayAlertMessage(strMessage: "Please Enter Phone.")
            }
        }
        
        if txtExperience.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            if txtExperience.text!.isNumeric {
                if Int(txtExperience.text!.trimmingCharacters(in: .whitespacesAndNewlines))! >= 50 {
                    txtExperience.layer.borderColor = UIColor.red.cgColor
                    if isValid == true {
                        isValid = false
                        displayAlertMessage(strMessage: "Please Enter Experience.")
                    }
                } else {
                    txtExperience.layer.borderColor = UIColor.white.cgColor
                }
            } else {
                txtExperience.layer.borderColor = UIColor.red.cgColor
                if isValid == true {
                    isValid = false
                    displayAlertMessage(strMessage: "Please Enter Experience.")
                }
            }
        } else {
            txtExperience.layer.borderColor = UIColor.red.cgColor
            if isValid == true {
                isValid = false
                displayAlertMessage(strMessage: "Please Enter Experience.")
            }
        }

        if txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            if validataPasswordLength(strPassword: txtPassword.text) {
                txtPassword.layer.borderColor = UIColor.white.cgColor
            } else {
                txtPassword.layer.borderColor = UIColor.red.cgColor
                if isValid == true {
                    isValid = false
                    displayAlertMessage(strMessage: "Please Enter Valid Password. Password length must be at least 6 characters.")
                }
            }
        } else {
            txtPassword.layer.borderColor = UIColor.red.cgColor
            if isValid == true {
                isValid = false
                //displayAlertMessage(strMessage: "Please Enter Password.")
                displayAlertMessage(strMessage: "Please Enter Valid Password. Password length must be at least 6 characters.")
            }
        }
        
        if txtConfirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines).characters.count > 0 {
            if validataPasswordLength(strPassword: txtConfirmPassword.text) {
                if comparePasswordValidation(strPassword: txtPassword.text!, strConfirmPassword: txtConfirmPassword.text!) {
                    txtPassword.layer.borderColor = UIColor.white.cgColor
                    txtConfirmPassword.layer.borderColor = UIColor.white.cgColor
                } else {
                    txtPassword.layer.borderColor = UIColor.red.cgColor
                    txtConfirmPassword.layer.borderColor = UIColor.red.cgColor
                    if isValid == true {
                        isValid = false
                        //displayAlertMessage(strMessage: "Passwords does not matches.")
                        displayAlertMessage(strMessage: "Please Enter Confirm Password. Password and Confirm Password does not matches.")
                    }
                }
            } else {
                txtConfirmPassword.layer.borderColor = UIColor.red.cgColor
                if isValid == true {
                    isValid = false
                    //displayAlertMessage(strMessage: "Passwords does not matches.")
                    displayAlertMessage(strMessage: "Please Enter Confirm Password. Password and Confirm Password does not matches.")
                }
            }
        } else {
            txtConfirmPassword.layer.borderColor = UIColor.red.cgColor
            if isValid == true {
                isValid = false
                //displayAlertMessage(strMessage: "Please Enter Confirm Password.")
                displayAlertMessage(strMessage: "Please Enter Confirm Password. Password and Confirm Password does not matches.")
            }
        }
        
        return isValid
    }
}

//------------------------------------------------------------------
// MARK: - Action Methods
//------------------------------------------------------------------

extension RegistrationVC {
        
    func btnBackTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func btnSignInTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func btnSignUpTapped() {
        let isValidData = checkRegistrationValidation()
        print("isValidData :: ",isValidData)
        
        // name, email,phone,experience, password
        // device_type: "1-iOS" & "2-Android"
        if isValidData == true {
            let deviceToken = getDefaultsValueForKey("keyDeviceToken") //"\(UserDefaults.standard.object(forKey: "keyDeviceToken"))"
            let dictRegisterData = ["email":"\(txtEmail.text!)","name":"\(txtUserName.text!)",
                "password":"\(txtPassword.text!)","phone":"\(txtPhoneNumber.text!)","experience":"\(txtExperience.text!)","device_token":deviceToken,"device_type":"1"]
            registerNewUser(dictParams: dictRegisterData)
        }
    }
    
    func segGenderChanged(_ segment: UISegmentedControl) {
        print("selected Segment = ", "\(segment.titleForSegment(at: segment.selectedSegmentIndex)!)" )
    }
    
    func btnPhoneNextTapped() {
        
    }
}

//------------------------------------------------------------------
// MARK: - WebService Methods
//------------------------------------------------------------------

extension RegistrationVC {
    
    func registerNewUser(dictParams: [String : String]) {
        print("dictParams = ",dictParams)
        
        appDel.showProgress()
        WebService.callPostWebService(strAPI: "registration", requestParams: dictParams, successCompletionHandler: { (dictResponse) in
            print(dictResponse)
            DispatchQueue.main.async {
                appDel.hideProgress()
            }
            if "\(dictResponse["status"]!)" != "0" {
                DispatchQueue.main.async {
                    let window = appDel.window
                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    // User is logged In.
                    let objNavHome = mainStoryBoard.instantiateViewController(withIdentifier: kNavHomeVCIdentifier) as! UINavigationController
                    
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(dictResponse["result"]!, forKey: "CoachData")
                    UserDefaults.standard.synchronize()
                    
                    UIView .transition(with: window!, duration: 0.5, options: .transitionCrossDissolve, animations: {
                        window?.rootViewController = objNavHome
                        window?.makeKeyAndVisible()
                    }, completion: nil)
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
}
