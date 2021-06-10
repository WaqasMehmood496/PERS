//
//  SignUpViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var FullNameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var MobileNumberTF: UITextField!
    @IBOutlet weak var LocationTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    //MARK: VARIABLE'S
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
}

//MARK:- FUNCTION'S EXTENSION
extension SignUpViewController{
    func setupUI() {
        // Left padding of textfield
        FullNameTF.setLeftPaddingPoints(8)
        EmailTF.setLeftPaddingPoints(8)
        MobileNumberTF.setLeftPaddingPoints(8)
        LocationTF.setLeftPaddingPoints(8)
        PasswordTF.setLeftPaddingPoints(8)
        // Right Padding of textfield
        FullNameTF.setRightPaddingPoints(8)
        EmailTF.setRightPaddingPoints(8)
        MobileNumberTF.setRightPaddingPoints(8)
        LocationTF.setRightPaddingPoints(8)
        PasswordTF.setRightPaddingPoints(8)
        // Set Gradient on button
        guard let darkColor = UIColor(named: "Gradient Dark Color")?.cgColor else{return}
        guard let lightColor = UIColor(named: "Gradient Light Color")?.cgColor else{return}
        RegisterButton.setGradient(colors: [darkColor,lightColor])
        RegisterButton.clipsToBounds = true
    }
}
