//
//  AddFriendsViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit

class AddFriendsViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var FriendListTableView: UITableView!
    //MARK: VARIABLE'S
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK:- UITBLEVIEW DATASOURCE AND DELEGATES EXTENSION
extension AddFriendsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as! NotificationTableViewCell
        return cell
    }
}
