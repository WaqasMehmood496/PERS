//
//  LoginViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 09/06/2021.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: IBOUTLET'S
    @IBOutlet weak var EmailAddressTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    // MARK: VARIABLE'S
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: ACTION'S
    @IBAction func LoginBtnAction(_ sender: Any) {
        PopupHelper.changeRootView(storyboardName: "Main", ViewControllerId: "Tabbar")
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
}
