//
//  HomeViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 09/06/2021.
//

import UIKit
import MobileCoreServices
import Firebase
import MapKit
import AVKit
import JGProgressHUD

class HomeViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var MyAreaCV: UICollectionView!
    @IBOutlet weak var RecentlyAddedCV: UICollectionView!
    //MARK: VARIABLE'S
    private let spacingIphone:CGFloat = 0.0
    private let spacingIpad:CGFloat = 0.0
    var mAuth = Auth.auth()
    var ref: DatabaseReference!
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var currentAddress = String()
    let image = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.collectionViewSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func EmergencyAlertBtnAction(_ sender: Any) {
        showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
            hud.show(in: self.view, animated: true)
            self.getLocation(hud: hud)
        }
    }
}

//MARK:- HELPING METHOD'S EXTENSION
extension HomeViewController{
    // Setup Collection View
    func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        if UIDevice.current.userInterfaceIdiom == .phone{
            layout.sectionInset = UIEdgeInsets(top: spacingIphone, left: spacingIphone, bottom: spacingIphone, right: spacingIphone)
            layout.minimumLineSpacing = spacingIphone
            layout.minimumInteritemSpacing = spacingIphone
        }
        else{
            layout.sectionInset = UIEdgeInsets(top: spacingIpad, left: spacingIpad, bottom: spacingIpad, right: spacingIpad)
            layout.minimumLineSpacing = spacingIpad
            layout.minimumInteritemSpacing = spacingIpad
        }
        
        self.RecentlyAddedCV?.collectionViewLayout = layout
    }
    
    //GET USER CURRENT LOCATION
    func getUserCurrentLocation(completion: (Bool) -> ()) {
        locManager.requestWhenInUseAuthorization()
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways {
            self.currentLocation = locManager.location
            completion(true)
        }else{
            completion(false)
        }
    }
    
    func getCurrentAddress(location:CLLocation,hud:JGProgressHUD) {
        let loc: CLLocation = CLLocation(latitude:location.coordinate.latitude, longitude: location.coordinate.longitude)
        let ceo: CLGeocoder = CLGeocoder()
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            var addressString : String = ""
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + ", "
                                            }
                                            if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }
                                            print(addressString)
                                            self.currentAddress = addressString
                                            hud.dismiss()
                                            self.CameraBottomSheet()
                                        }
                                    })
    }
    
    func getName() -> String {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyyMMddHHmmss"
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.string(from: Date())
        let name = date.appending(".mp4")
        return name
    }
}


//MARK:- FIREBASE METHOD"S EXTENSION
extension HomeViewController{
    // First get user lat,lng
    func getLocation(hud:JGProgressHUD)  {
        self.getUserCurrentLocation { (status) in
            if status{
                self.getCurrentAddress(location: self.currentLocation, hud: hud)
            }else{
                hud.dismiss()
                PopupHelper.alertWithOk(title: "Location Not Found", message: "Your location not found please enable your location from settings", controler: self)
            }
        }
    }
    
    // THIS METHOD IS USED FOR UPLOADING IMAGE INTO FIREBASE DATABASE
    func uploadVideo(_ path: URL, _ userID: String,
                     metadataEsc: @escaping (URL, StorageReference)->(),
                     progressEsc: @escaping (Progress)->(),
                     completionEsc: @escaping ()->(),
                     errorEsc: @escaping (Error)->()) {
        
        let localFile: URL = path
        let videoName = getName()
        let nameRef = Storage.storage().reference().child("/Videos").child(videoName)
        //StorageHandler.videosRef.child(userID).child(videoName)
        let matData = StorageMetadata()
        matData.contentType = "video"
        
        let uploadTask = nameRef.putFile(from: localFile, metadata: matData) { metadata, error in
            if error != nil {
                errorEsc(error!)
            } else {
                nameRef.downloadURL { (url,error) in
                    if let uRl = url{
                        self.SaveDatatoDB(videoUrl: uRl.absoluteString)
                    }
                    
                }
            }
        }
        
        _ = uploadTask.observe(.progress, handler: { snapshot in
            if let progressSnap = snapshot.progress {
                progressEsc(progressSnap)
            }
        })
        
        _ = uploadTask.observe(.success, handler: { snapshot in
            if snapshot.status == .success {
                uploadTask.removeAllObservers()
                completionEsc()
            }
        })
    }
    
    
    //UPDATE IMAGE URL INTO USER TABLE
    func SaveDatatoDB(videoUrl:String){
        guard let user = self.mAuth.currentUser?.uid else {return}
        ref.child("Videos").child(user).childByAutoId().setValue([
            "videoLatitude":"\(self.currentLocation.coordinate.latitude)",
            "videoLocation":self.currentAddress,
            "videoLongitude":"\(self.currentLocation.coordinate.longitude)",
            "videoURL":videoUrl,
        ])
        
        //        //UPDATE DATA INTO CACHE
        //        if let userData = CommonHelper.getCachedUserData(){
        //            userData.imageURL = imageurl
        //            CommonHelper.saveCachedUserData(userData)
        //        }
        
        //MARK:- Update Videos
    }
    
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideosCell", for: indexPath) as! HomeCollectionViewCell
        cell.PlayButton.addTarget(self, action: #selector(PlayVideoBtnAction(_:)), for: .touchUpInside)
        cell.PlayButton.tag = indexPath.row
        return cell
    }
    
    @objc func PlayVideoBtnAction(_ sender:UIButton){
        let friendListVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "PlayerVC") as! PlayerViewController
        self.navigationController?.pushViewController(friendListVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 1
        let spacingBetweenCellsIphone:CGFloat = 10
        let spacingBetweenCellsIpad:CGFloat = 20
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            let totalSpacing = (2 * self.spacingIphone) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIphone) //Amount of total spacing in a row
            
            if let collection = self.RecentlyAddedCV{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: (width/4)*3)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else{
            let totalSpacing = (2 * self.spacingIpad) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIpad) //Amount of total spacing in a row
            
            if let collection = self.RecentlyAddedCV{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: width + spacingBetweenCellsIpad * 2)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
    }
}

//MARK:- CAMERA METHIO'S EXTENSION
extension HomeViewController {
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
        self.present(image, animated: true)
    }
    //THIS METHODS WILL OPEN GALLERY FOR IMAGE SELECTION
    func openGallery() {
        image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.mediaTypes = ["public.movie"]
    }
    // THIS METHOD WILL OPEN CAMERA FOR CAPTURING IMAGE
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            // imagePicker.showsCameraControls = true
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Your device not supporting camera", forViewController: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let movie = info[.mediaURL] as? URL {
            //Call send video into firebase method
            self.uploadVideo(movie, "") { (url, storageRef) in
                print(url)
            } progressEsc: { (progress) in
                print(progress)
            } completionEsc: {
                print("escape")
            } errorEsc: { (error) in
                print(error.localizedDescription)
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

