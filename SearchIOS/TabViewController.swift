//
//  TabViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/7/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import AlamofireSwiftyJSON

class TabViewController: UITabBarController {
    
    var url = ""
    var placeId = ""
    var name = ""
    var address = ""
    var web = ""
    let apiKey = "AIzaSyAU5hyg6Ky-pOHejxe2u8trKteehGkSNrk"

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.viewControllers?.count)
        SwiftSpinner.show("Loading..")
        getDetails()
        var svc = self.viewControllers![0]
        var info = svc.childViewControllers[0] as! InfoViewController
        info.url = self.url
        info.placeId = self.placeId
        info.name = self.name
        info.address = self.address
        info.web = self.web
        print("tab url = \(url)" )
        SwiftSpinner.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDetails() {
        var tempU = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + self.placeId + "&key=" + self.apiKey
        Alamofire.request(tempU).responseSwiftyJSON { response in
            let places = response.result.value
            //print(places)
            if places!["status"] == "OK" {
                var resData = places!["result"]
                self.address =  resData["formatted_address"].string!
                if (resData["website"].string) != nil {
                    self.web = resData["website"].string!
                }
                else {
                    self.web = resData["url"].string!
                }
            }
        }
    }
    
}
