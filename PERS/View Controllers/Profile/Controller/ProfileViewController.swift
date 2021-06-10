//
//  ProfileViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit

class ProfileViewController: UIViewController {
    //MARK: IBOUTLET'S
    //MARK: VARIABLE'S
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func AddFriendsBtnAction(_ sender: Any) {
        let friendListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "AddFriendVC") as! AddFriendsViewController
        self.navigationController?.pushViewController(friendListVC, animated: true)
    }
    
    @IBAction func SignoutBtnAction(_ sender: Any) {
        PopupHelper.changeRootViewController(storyboardName: "Main", ViewControllerId: "LoginVC")
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
