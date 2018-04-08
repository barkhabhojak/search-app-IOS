//
//  InfoViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/7/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import GooglePlaces
import SwiftSpinner

class InfoViewController: UIViewController {

    var placeId = ""
    var url = ""
    var name = ""
    let placesClient = GMSPlacesClient()
    
    @IBOutlet weak var navbar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbar.title = name
        print("in info view controller " + placeId)
        getDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is TableViewController
        {
            let vc = segue.destination as? TableViewController
            vc?.url = self.url
        }
    }
    
    func getDetails() {
        SwiftSpinner.show("Loading..")
        placesClient.lookUpPlaceID(self.placeId, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = place else {
                print("No place details for \(self.placeId)")
                return
            }
            print(place)
            SwiftSpinner.hide()
        })
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "backToTable", sender: nil)
    }
    
    @IBAction func shareTwitterClick(_ sender: UIButton) {
    }
    
}
