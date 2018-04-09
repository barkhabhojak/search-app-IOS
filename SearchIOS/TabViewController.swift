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
import SafariServices

class TabViewController: UITabBarController {
    
    var url = ""
    var placeId = ""
    var name = ""
    var address = ""
    var web = ""
    var infoDetails = [String:Any]()
    var favSelect = false
    let apiKey = "AIzaSyAU5hyg6Ky-pOHejxe2u8trKteehGkSNrk"

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.viewControllers?.count)
        print("tab url = \(url)" )
        getDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setValuesOfControl() {

    }
    
    func getDetails() {
        SwiftSpinner.show("Loading..")
        var tempU = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + self.placeId + "&key=" + self.apiKey
        print("temp url = \(tempU)")
        Alamofire.request(tempU).responseSwiftyJSON { response in
            let places = response.result.value
            //print(places)
            if places!["status"] == "OK" {
                var resData = places!["result"]
                self.name = resData["name"].string!
                self.address =  resData["formatted_address"].string!
                if (resData["website"].string) != nil {
                    self.web = resData["website"].string!
                    self.infoDetails["website"] = resData["website"].string!
                }
                else {
                    self.web = resData["url"].string!
                    self.infoDetails["website"] = ""
                }
                self.infoDetails["name"] = self.name
                self.infoDetails["address"] = self.address
                self.infoDetails["rating"] = String(describing: resData["rating"])
                self.infoDetails["number"] = String(describing: resData["international_phone_number"])
                self.infoDetails["price"] = String(describing: resData["price_level"])
                self.infoDetails["url"] = resData["url"].string!
                var svc = self.viewControllers![0] as! InfoViewController
                svc.infoDetails = self.infoDetails
                svc.addLabelsToPage()
                var svc1 = self.viewControllers![1] as! PhotoViewController
                svc1.name = self.name
                svc1.address = self.address
                svc1.web = self.web
                svc1.placeId = self.placeId
                svc1.loadPhotoForPlace(placeID: self.placeId)
                var svc2 = self.viewControllers![2] as! MapsViewController
                svc2.name = self.name
                svc2.address = self.address
                svc2.web = self.web
                var svc3 = self.viewControllers![3] as! ReviewViewController
                svc3.name = self.name
                svc3.address = self.address
                svc3.web = self.web
                //self.setValuesOfControl()
                self.setNav()
            }
            SwiftSpinner.hide()
        }
    }
    
    func setNav() {
        self.title = self.name
        let backItem = UIBarButtonItem()
        backItem.title = ""
        self.navigationItem.backBarButtonItem = backItem
        let share = UIBarButtonItem(image: UIImage(named: "forward-arrow"),
                                    style: UIBarButtonItemStyle.plain ,
                                    target: self, action: #selector(onShareClick))
        var fav = UIBarButtonItem()
        if !self.favSelect {
            fav = UIBarButtonItem(image: UIImage(named: "favorite-empty"),
                                      style: UIBarButtonItemStyle.plain ,
                                      target: self, action: #selector(favToggle))
        }
        else {
            fav = UIBarButtonItem(image: UIImage(named: "favorite-filled"),
                                      style: UIBarButtonItemStyle.plain ,
                                      target: self, action: Selector(("removeFromFav:")))
        }
        self.navigationItem.rightBarButtonItems = [fav,share]
    }
    
    @objc func onShareClick() {
        var text = "Check out \(self.name) located at \(self.address). Website: "
        text = text.replacingOccurrences(of: " ", with: "+")
        let link = "https://twitter.com/intent/tweet?text=\(text)&url=\(self.web)";
        let svc = SFSafariViewController(url: URL(string: link)!)
        present(svc, animated: true, completion: nil)
    }
    
    
    @objc func favToggle() {
        if self.favSelect {
            self.favSelect = false
            var btnFav = UIBarButtonItem(image: UIImage(named: "favorite-empty"),
                                  style: UIBarButtonItemStyle.plain ,
                                  target: self, action: #selector(favToggle))
            self.navigationItem.rightBarButtonItems![0] = btnFav

        }
        else {
            self.favSelect = true
            var btnFav = UIBarButtonItem(image: UIImage(named: "favorite-filled"),
                                         style: UIBarButtonItemStyle.plain ,
                                         target: self, action: #selector(favToggle))
            self.navigationItem.rightBarButtonItems![0] = btnFav
        }
    }
}
