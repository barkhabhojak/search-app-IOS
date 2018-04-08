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
        print("tab url = \(url)" )
        getDetails()
        var svc = self.viewControllers![0]
        var info = svc.childViewControllers[0] as! InfoViewController
        info.name = self.name
        info.url = self.url
        info.placeId = self.placeId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setValuesOfControl() {

    }
    
    func getDetails() {
        SwiftSpinner.show("Loading..")
        var tempU = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + self.placeId + "&key=" + self.apiKey
        Alamofire.request(tempU).responseSwiftyJSON { response in
            let places = response.result.value
            //print(places)
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
                var svc = self.viewControllers![0]
                var info = svc.childViewControllers[0] as! InfoViewController
                info.address = self.address
                info.web = self.web
                var svc1 = self.viewControllers![1]
                var photo = svc1.childViewControllers[0] as! PhotoViewController
                photo.name = self.name
                photo.address = self.address
                photo.web = self.web
                var svc2 = self.viewControllers![2]
                var map = svc2.childViewControllers[0] as! MapsViewController
                map.name = self.name
                map.address = self.address
                map.web = self.web
                var svc3 = self.viewControllers![3]
                var rev = svc3.childViewControllers[0] as! ReviewViewController
                rev.name = self.name
                rev.address = self.address
                rev.web = self.web
                //self.setValuesOfControl()
            }
        }
        SwiftSpinner.hide()
    }
    
}
