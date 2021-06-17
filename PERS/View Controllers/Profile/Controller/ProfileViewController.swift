//
//  ProfileViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit
import SDWebImage
import Firebase

class ProfileViewController: UIViewController {
    //MARK: IBOUTLET'S
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserEmailLabel: UILabel!
    @IBOutlet weak var FullNameLabel: UILabel!
    @IBOutlet weak var EmailAddressLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var PasswordLabel: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var FriendListTableView: UITableView!
    //MARK: VARIABLE'S
    var mAuth = Auth.auth()
    var ref: DatabaseReference!
    var friendList = [LoginModel]()
    var allUser = [LoginModel]()
    let image = UIImagePickerController()
    var isImageUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.setupUI()
        self.getAllUsersRecord()
    }
    
    @IBAction func AddFriendsBtnAction(_ sender: Any) {
        let friendListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "AddFriendVC") as! AddFriendsViewController
        self.navigationController?.pushViewController(friendListVC, animated: true)
    }
    
    @IBAction func SignoutBtnAction(_ sender: Any) {
        //Remove user data from cache
        CommonHelper.removeCachedUserData()
        //Change root view
        PopupHelper.changeRootViewController(storyboardName: "Main", ViewControllerId: "LoginVC")
    }
    @IBAction func UpdateProfileImageBtnAction(_ sender: Any) {
        if isImageUpdate{
            
        }else{
            PopupHelper.alertWithOk(title: "Image Not Selected", message: "Please capture image from camera or select from gallery to update image", controler: self)
        }
    }
    @IBAction func CaptureImageBtnAction(_ sender: Any) {
        self.CameraBottomSheet()
    }
}

//MARK:- HELPING METHO'D EXTENSION
extension ProfileViewController{
    // SETUP USER INTERFACE WITH SOME MODIFICATION
    func setupUI() {
        if let userData = CommonHelper.getCachedUserData(){
            UserNameLabel.text = userData.name
            UserEmailLabel.text = userData.email
            FullNameLabel.text = userData.name
            EmailAddressLabel.text = userData.email
            LocationLabel.text = userData.location
            PasswordLabel.text = userData.password
            self.ProfileImage.sd_setImage(with: URL(string: userData.imageURL), placeholderImage: #imageLiteral(resourceName: "Clip"))
        }
    }
    //THIS METHOD WILL COMPARE THE FRIEND ID TO ALL USER RECORDS TO FETCH WHICH USER IS IN FRIEND LIST
    func compareRecord(friendArray:[FriendModel]) {
        print(friendArray.count)
        print(allUser.count)
        for friend in friendArray{
            for user in self.allUser{
                if user.id == friend.id{
                    self.friendList.append(user)
                }
            }//End friend loop
        }//End user loop
        self.FriendListTableView.reloadData()
    }
}

//MARK:- FIREBASE METHOD'S EXTENSION
extension ProfileViewController{
    //GET ALL USERS RECORD FROM FIREBASE DATABASE
    func getAllUsersRecord() {
        if Connectivity.isConnectedToNetwork(){
            showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
                hud.show(in: self.view, animated: true)
                if let userID = self.mAuth.currentUser?.uid{
                    self.ref.child("Users").observeSingleEvent(of: .value) { (snapshot) in
                        print(snapshot)
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
                        self.getFavoritesFromFirebase()
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
    
    // GET ALL FAVORITES VIDEOS FROM FIREBASE DATABASE
    func getFavoritesFromFirebase() {
        if Connectivity.isConnectedToNetwork(){
            showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
                hud.show(in: self.view, animated: true)
                var friends = [FriendModel]()
                if let userID = self.mAuth.currentUser?.uid{
                    self.ref.child("Friends").child(userID).observeSingleEvent(of: .value) { (snapshot) in
                        print(snapshot)
                        if(snapshot.exists()) {
                            let array:NSArray = snapshot.children.allObjects as NSArray
                            print(array.count)
                            for obj in array {
                                let snapshot:DataSnapshot = obj as! DataSnapshot
                                if var childSnapshot = snapshot.value as? [String : AnyObject]{
                                    childSnapshot[Constant.id] = snapshot.key as String as AnyObject
                                    let favData = FriendModel(dic: childSnapshot as NSDictionary)
                                    if let fav = favData{
                                        friends.append(fav)
                                    }
                                    print(childSnapshot)
                                }
                            }// End For loop
                            hud.dismiss()
                        }// End Snapshot if else statement
                        self.compareRecord(friendArray: friends)
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
extension ProfileViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! NotificationTableViewCell
        cell.Title.text = self.friendList[indexPath.row].name
        cell.Description.text = self.friendList[indexPath.row].location
        cell.UserImage.sd_setImage(with: URL(string: self.friendList[indexPath.row].imageURL), placeholderImage: #imageLiteral(resourceName: "Logo"))
        return cell
    }
}

//MARK:- CAMERA METHIO'S EXTENSION
extension ProfileViewController {
    //BOTTOM SHEET WHICH WILL SHOW TWO OPTION [CAMERA AND GALLERY]
    func CameraBottomSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.Selected_choise(choise: "Camera")
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.Selected_choise(choise: "gallery")
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    // THIS METHOD IS USE FOR CHOICE WHICH IS SELECTED BY USER
    func Selected_choise(choise:String){
        if choise == "gallery"{
            self.openGallery()
        }else{
            self.openCamera()
        }
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    //THIS METHODS WILL OPEN GALLERY FOR IMAGE SELECTION
    func openGallery() {
        image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.mediaTypes = ["public.image", "public.movie"]
    }
    // THIS METHOD WILL OPEN CAMERA FOR CAPTURING IMAGE
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Your device not supporting camera", forViewController: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            self.ProfileImage.image = editedImage
            isImageUpdate = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.ProfileImage.image = originalImage
            isImageUpdate = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
