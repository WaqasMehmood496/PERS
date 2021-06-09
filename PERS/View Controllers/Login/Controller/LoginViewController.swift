//
//  LoginViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 09/06/2021.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: IBOUTLET'S
    
    // MARK: VARIABLE'S
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
