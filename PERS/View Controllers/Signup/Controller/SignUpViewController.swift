//
//  SignUpViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit
import JGProgressHUD
import Firebase

class SignUpViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var FullNameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var MobileNumberTF: UITextField!
    @IBOutlet weak var LocationTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var RegisterButton: UIButton!
    
    //MARK: VARIABLE'S
    var ref: DatabaseReference!
    var mAuth = Auth.auth()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.setupUI()
    }
    @IBAction func ResisterButtonAction(_ sender: Any) {
        self.SignUpUser()
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
    // ADD NEW RECORD INTO FIREBASE DATABASE
    func SignUpUser(){
        
        let fullname = FullNameTF.text!
        let email = EmailTF.text!
        let mobilenumber = MobileNumberTF.text!
        let location = LocationTF.text!
        let password = PasswordTF.text!
        
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            if fullname != "" && email != "" && mobilenumber != "" && location != "" && password != ""
            {
                self.mAuth.createUser(withEmail: email, password: password) { result, err in
                    if let error = err {
                        print(error)
                        hud.dismiss()
                        PopupHelper.alertWithOk(title: "Alert", message: error.localizedDescription, controler: self)
                    }
                    else{
                        self.insertUsertoDataBase(fullname: fullname, email: email, mobileNumber: mobilenumber, location: location, password: password)
                        hud.dismiss()
                    }// End Error condition
                }// End Authorization (mAuth)
            }else{
                PopupHelper.alertWithOk(title: "Empty Field", message: "All fields are required", controler: self)
            }// End Feilds condition
        }//End Progress hud
    }// End functions
    
    func insertUsertoDataBase(fullname:String,email:String,mobileNumber:String,location:String,password:String){
        guard let user = mAuth.currentUser?.uid else { return }
        self.ref.child("Users").child(user).setValue([
            "email":email,
            "full_name":fullname,
            "location":location,
            "mobilenumber":mobileNumber,
            "password":password,
        ])
        // save into cache
        let currentuser = LoginModel(email: email, full_name: fullname, location: location, mobilenumber: mobileNumber, password: password)
        CommonHelper.saveCachedUserData(currentuser)
        // Change root view controller
        PopupHelper.changeRootView(storyboardName: "Main", ViewControllerId: "Tabbar")
    }
}
