//
//  PlayerViewController.swift
//  PERS
//
//  Created by Buzzware Tech on 10/06/2021.
//

import UIKit

class PlayerViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var RelatedVideoTableView: UICollectionView!
    //MARK: VARIABLE'S
    private let spacingIphone:CGFloat = 0.0
    private let spacingIpad:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionViewSetup()
    }
}

extension PlayerViewController{
    // Setup Collection View
//    func collectionViewSetup() {
//
//        let layout = UICollectionViewFlowLayout()
//        if UIDevice.current.userInterfaceIdiom == .phone{
//            layout.sectionInset = UIEdgeInsets(top: spacingIphone, left: spacingIphone, bottom: spacingIphone, right: spacingIphone)
//            layout.minimumLineSpacing = spacingIphone
//            layout.minimumInteritemSpacing = spacingIphone
//        }
//        else{
//            layout.sectionInset = UIEdgeInsets(top: spacingIpad, left: spacingIpad, bottom: spacingIpad, right: spacingIpad)
//            layout.minimumLineSpacing = spacingIpad
//            layout.minimumInteritemSpacing = spacingIpad
//        }
//
//        self.RelatedVideoTableView?.collectionViewLayout = layout
//    }
}


extension PlayerViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideosCell", for: indexPath) as! HomeCollectionViewCell
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let numberOfItemsPerRow:CGFloat = 1
//        let spacingBetweenCellsIphone:CGFloat = 10
//        let spacingBetweenCellsIpad:CGFloat = 20
//
//        if UIDevice.current.userInterfaceIdiom == .phone{
//            let totalSpacing = (2 * self.spacingIphone) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIphone) //Amount of total spacing in a row
//
//            if let collection = self.RelatedVideoTableView{
//                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//                return CGSize(width: width , height: (width/4)*3)
//            }else{
//                return CGSize(width: 0, height: 0)
//            }
//        }
//        else{
//            let totalSpacing = (2 * self.spacingIpad) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIpad) //Amount of total spacing in a row
//
//            if let collection = self.RelatedVideoTableView{
//                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
//                return CGSize(width: width , height: width + spacingBetweenCellsIpad * 2)
//            }else{
//                return CGSize(width: 0, height: 0)
//            }
//        }
//    }
}
