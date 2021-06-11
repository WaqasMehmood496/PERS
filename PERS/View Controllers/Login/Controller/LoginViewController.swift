//
//  LoginViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 09/06/2021.
//

import UIKit
import JGProgressHUD
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: IBOUTLET'S
    @IBOutlet weak var EmailAddressTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    // MARK: VARIABLE'S
    var ref: DatabaseReference!
    var mAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        setupUI()
    }
    
    // MARK: ACTION'S
    @IBAction func LoginBtnAction(_ sender: Any) {
        //PopupHelper.changeRootView(storyboardName: "Main", ViewControllerId: "Tabbar")
        let email = EmailAddressTF.text!
        let password = PasswordTF.text!
        self.signInUser(email: email, password: password)
    }
    @IBAction func SignUpBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    @IBAction func ForgotPasswordBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
    
}

//MARK:- FUNCTION'S EXTENSION
extension LoginViewController{
    func setupUI() {
        EmailAddressTF.setLeftPaddingPoints(8)
        PasswordTF.setLeftPaddingPoints(8)
        EmailAddressTF.setRightPaddingPoints(8)
        PasswordTF.setRightPaddingPoints(8)
        guard let darkColor = UIColor(named: "Gradient Dark Color")?.cgColor else{return}
        guard let lightColor = UIColor(named: "Gradient Light Color")?.cgColor else{return}
        LoginButton.setGradient(colors: [darkColor,lightColor])
        LoginButton.clipsToBounds = true
    }
    
    
    func signInUser(email:String,password:String){
        if email != "" && password != ""{
            showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
                hud.show(in: self.view, animated: true)
                self.mAuth.signIn(withEmail: email, password: password) { user, error in
                    if let error = error,user == nil{
                        hud.dismiss()
                        print(error.localizedDescription)
                        print("SignInFailed")
                    }
                    else{
                        if let userID = self.mAuth.currentUser?.uid{
                            print(userID)
                            self.ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                                print(snapshot)
                                let value = snapshot.value as? NSDictionary
                                let user = LoginModel(dic: value as! NSDictionary)
                                guard let data = user else{return}
                                CommonHelper.saveCachedUserData(data)
                                hud.dismiss()
                                PopupHelper.changeRootView(storyboardName: "Main", ViewControllerId: "Tabbar")
                            }){
                                (error) in
                                print(error.localizedDescription)
                                hud.dismiss()
                            }
                        }
                        else{
                            PopupHelper.alertWithOk(title: "Login Fail", message: "User not found", controler: self)
                            hud.dismiss()
                        }// End user id condition
                    }//End Error statement
                }// End Authorization
            }//End JGProgress Hud
        }// End email and password check condition
    }// End function statement
}
