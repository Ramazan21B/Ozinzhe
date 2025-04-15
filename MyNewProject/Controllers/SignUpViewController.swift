//
//  SignUpViewController.swift
//  MyNewProject
//
//  Created by Aitzhan Ramazan on 20.03.2025.
//

import UIKit
import SDWebImage
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SignUpViewController: UIViewController {

   
    @IBOutlet weak var signUpEmailTextField: TextFieldWithPadding!
    @IBOutlet weak var signUpPassword: TextFieldWithPadding!
    @IBOutlet weak var repeatSignUpPassword: TextFieldWithPadding!
    @IBOutlet weak var signUpButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        hideKeyboardWhenTappedAround()
        
       signUpPassword.textContentType = .newPassword
       repeatSignUpPassword.textContentType = .newPassword

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func configureView(){
        signUpEmailTextField.layer.cornerRadius = 12
        signUpEmailTextField.layer.borderWidth = 1
        signUpEmailTextField.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        
        signUpPassword.layer.cornerRadius = 12
        signUpPassword.layer.borderWidth = 1
        signUpPassword.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        repeatSignUpPassword.layer.cornerRadius = 12
        repeatSignUpPassword.layer.borderWidth = 1
        repeatSignUpPassword.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
        
        signUpButton.layer.cornerRadius = 12
        signUpButton.tintColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00)
        
    }
    
    func hideKeyboardWhenTappedAround(){
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
        
    }
    
    @IBAction func TextFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.59, green: 0.33, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func TextFieldEditingDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 0.90, green: 0.92, blue: 0.94, alpha: 1.00).cgColor
    }
    
    @IBAction func showPassword(_ sender: Any) {
        signUpPassword.isSecureTextEntry = !signUpPassword.isSecureTextEntry
    }
    
    @IBAction func repeatShowPassword(_ sender: Any){
        repeatSignUpPassword.isSecureTextEntry = !repeatSignUpPassword.isSecureTextEntry
    }
    @IBAction func signInButton(_ sender: Any) {
        let signInVC = storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
        self.navigationController?.pushViewController(signInVC!, animated: true)
    }
    
    @IBAction func signUp(_ sender: Any) {
        let email = signUpEmailTextField.text!
        let password = signUpPassword.text!
        let repeatSignUpPassword = repeatSignUpPassword.text!
        
        if password == repeatSignUpPassword{
            SVProgressHUD.show()
            
            let parameters = ["email": email, "password": password]
            
            AF.request(Urls.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                
                SVProgressHUD.dismiss()
                var resultString = ""
                if let data = response.data {
                    resultString = String(data: data, encoding: .utf8)!
                    print(resultString)
                }
                
                if response.response?.statusCode == 200 {
                    let json = JSON(response.data!)
                    print("JSON: \(json)")
                    
                    if let token = json["accessToken"].string {
                        Storage.sharedInstance.accessToken = token
                        UserDefaults.standard.set(token, forKey: "accessToken")
                        self.startApp()
                    } else {
                        SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                    }
                } else {
                    var ErrorString = "CONNECTION_ERROR".localized()
                        if let sCode = response.response?.statusCode {
                            ErrorString = ErrorString + "\(sCode)"
                        }
                        ErrorString = ErrorString + "\(resultString)"
                        SVProgressHUD.showError(withStatus: "\(ErrorString)")
                    }
                }
            print("Registration was successful")
        }else{
            print("Try again")
        }
    }
    
    func startApp(){
        let tabViewController = self.storyboard?.instantiateViewController(identifier: "TabBarController")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
}
