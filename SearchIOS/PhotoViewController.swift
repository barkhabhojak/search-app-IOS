//
//  PhotoViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/8/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import GooglePlaces

class PhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var name = ""
    var address = ""
    var web = ""
    var placeId = ""
    var photoArr = [GMSPlacePhotoMetadata]()
    var photoArrUIImage = [UIImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var navbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("photo view controller")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.photoArr = (photos?.results)!
                
                for ph in (photos?.results)! {
                    GMSPlacesClient.shared().loadPlacePhoto(ph, callback: {
                        (photo, error) -> Void in
                        if let error = error {
                            // TODO: handle the error.
                            print("Error: \(error.localizedDescription)")
                        } else {
                            self.photoArrUIImage.append(photo!)
                        }
                    })
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        let photoType = self.photoArrUIImage[indexPath.row]
        cell.displayContent(image: photoType)
        return cell
    }

}
