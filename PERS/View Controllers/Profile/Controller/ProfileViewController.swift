//
//  ProfileViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: IBOUTLET'S
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserEmailLabel: UILabel!
    @IBOutlet weak var FullNameLabel: UILabel!
    @IBOutlet weak var EmailAddressLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    //MARK: VARIABLE'S
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.assignDataToUI()
    }
    
    @IBAction func AddFriendsBtnAction(_ sender: Any) {
        let friendListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "AddFriendVC") as! AddFriendsViewController
        self.navigationController?.pushViewController(friendListVC, animated: true)
    }
    
    @IBAction func SignoutBtnAction(_ sender: Any) {
        PopupHelper.changeRootViewController(storyboardName: "Main", ViewControllerId: "LoginVC")
    }
    
    func assignDataToUI() {
        if let userData = CommonHelper.getCachedUserData(){
            UserNameLabel.text = userData.full_name
            UserEmailLabel.text = userData.email
            FullNameLabel.text = userData.full_name
            EmailAddressLabel.text = userData.email
            LocationLabel.text = userData.location
            PasswordLabel.text = userData.password
        }
    }
}


// MARK:- UITBLEVIEW DATASOURCE AND DELEGATES EXTENSION
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! NotificationTableViewCell
        return cell
    }
}
