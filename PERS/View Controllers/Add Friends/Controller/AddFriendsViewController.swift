//
//  AddFriendsViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit
import Firebase
import SDWebImage

class AddFriendsViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var FriendListTableView: UITableView!
    //MARK: VARIABLE'S
    var mAuth = Auth.auth()
    var ref: DatabaseReference!
    var allUser = [LoginModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        self.getAllUsersRecord()
    }
}

//MARK:- FIREBASE METHOD'S EXTENSION
extension AddFriendsViewController{
    func getAllUsersRecord() {
        if Connectivity.isConnectedToNetwork(){
            showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
                hud.show(in: self.view, animated: true)
                if let userID = self.mAuth.currentUser?.uid{
                    self.ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
                        if(snapshot.exists()) {
                            let array:NSArray = snapshot.children.allObjects as NSArray
                            print(array.count)
                            for obj in array {
                                let snapshot:DataSnapshot = obj as! DataSnapshot
                                if var childSnapshot = snapshot.value as? [String : AnyObject]{
                                    childSnapshot[Constant.id] = snapshot.key as String as AnyObject
                                    let users = LoginModel(dic: childSnapshot as NSDictionary)
                                    if let user = users{
                                        self.allUser.append(user)
                                    }
                                    print(childSnapshot)
                                }
                            }// End For loop
                            hud.dismiss()
                        }// End Snapshot if else statement
                        self.FriendListTableView.reloadData()
                        hud.dismiss()
                    }// End ref Child Completion Block
                }// End Firebase user id
                else{
                    hud.dismiss()
                }
            }
        }else{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Internet is unavailable please check your connection", forViewController: self)
        }//End Connectity Check Statement
    }// End get favorite method
}

// MARK:- UITBLEVIEW DATASOURCE AND DELEGATES EXTENSION
extension AddFriendsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! NotificationTableViewCell
        cell.AddFriendBtn.addTarget(self, action: #selector(AddFriendBtnAction(_:)), for: .touchUpInside)
        cell.AddFriendBtn.tag = indexPath.row
        cell.Title.text = self.allUser[indexPath.row].name
        cell.Description.text = self.allUser[indexPath.row].location
        
        if let image = self.allUser[indexPath.row].imageURL{
            cell.UserImage.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "Logo"))
        }
        return cell
    }
    @objc func AddFriendBtnAction(_ sender:UIButton){
        
    }
}
