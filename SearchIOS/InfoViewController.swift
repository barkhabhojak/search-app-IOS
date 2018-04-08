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
import SafariServices
import Alamofire
import AlamofireSwiftyJSON

class InfoViewController: UIViewController {

    var placeId = ""
    var url = ""
    var name = ""
    var address = ""
    var web = ""
    let placesClient = GMSPlacesClient()
    let apiKey = "AIzaSyAU5hyg6Ky-pOHejxe2u8trKteehGkSNrk"
    
    @IBOutlet weak var navbar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbar.title = name
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
        var tempU = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + self.placeId + "&key=" + self.apiKey
        Alamofire.request(tempU).responseSwiftyJSON { response in
            let places = response.result.value
            if places!["status"] == "OK" {
                var resData = places!["result"]
                self.name = resData["name"].string!
                self.address =  resData["formatted_address"].string!
                if (resData["website"].string) != nil {
                    self.web = resData["website"].string!
                }
                else {
                    self.web = resData["url"].string!
                }
            }
            SwiftSpinner.hide()
        }
    }
    
    @IBAction func backBtnClick(_ sender: UIButton) {
        performSegue(withIdentifier: "backToTable", sender: nil)
    }
    
    @IBAction func shareTwitterClick(_ sender: UIButton) {
        var text = "Check out \(self.name) located at \(self.address). Website: "
        text = text.replacingOccurrences(of: " ", with: "+")
        var link = "https://twitter.com/intent/tweet?text=\(text)&url=\(self.web)";
        let svc = SFSafariViewController(url: URL(string: link)!)
        present(svc, animated: true, completion: nil)
    }
    
    
    func apiClient() {
        placesClient.lookUpPlaceID(self.placeId, callback: { (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }

            guard let place = place else {
                print("No place details for \(self.placeId)")
                return
            }
            self.address = place.formattedAddress!
            print(place)
        })
    }
    
}
