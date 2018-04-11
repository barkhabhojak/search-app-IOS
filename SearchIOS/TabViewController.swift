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
    var rowCell = 0
    var iconString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.viewControllers?.count)
        print("tab url = \(url)" )
        //print(self.navigationController!.viewControllers.first)
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
        var lat = ""
        var long = ""
        var strAd = ""
        Alamofire.request(tempU).responseSwiftyJSON { response in
            let places = response.result.value
            //print(places)
            if places!["status"] == "OK" {
                var resData = places!["result"]
                strAd = resData["adr_address"].string!
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
                let svc = self.viewControllers![0] as! InfoViewController
                svc.infoDetails = self.infoDetails
                svc.addLabelsToPage()
                let svc1 = self.viewControllers![1] as! PhotoViewController
                svc1.name = self.name
                svc1.address = self.address
                svc1.web = self.web
                svc1.placeId = self.placeId
                svc1.loadPhotoForPlace(placeID: self.placeId)
                let svc2 = self.viewControllers![2] as! MapsViewController
                svc2.name = self.name
                svc2.address = self.address
                svc2.web = self.web
                svc2.destLat = resData["geometry"]["location"]["lat"].doubleValue
                svc2.destLong = resData["geometry"]["location"]["lng"].doubleValue
                lat = String(format:"%f", resData["geometry"]["location"]["lat"].doubleValue)
                long = String(format:"%f", resData["geometry"]["location"]["lng"].doubleValue)
                svc2.formMap()
                let svc3 = self.viewControllers![3] as! ReviewViewController
                svc3.name = self.name
                svc3.address = self.address
                svc3.web = self.web
                svc3.googleReviewArray = resData["reviews"].arrayObject as! [[String:Any]]
                svc3.googleReviewArraySort = resData["reviews"].arrayObject as! [[String:Any]]
                //self.setValuesOfControl()
                self.setNav()
            }
            
            //name = self.name,address = self.address,city,state,postal code,latitude = lat,longitude = long
            let postalCode = strAd.components(separatedBy: "postal-code\">")[1].components(separatedBy: "<")[0]
            let city = strAd.components(separatedBy: "locality\">")[1].components(separatedBy: "<")[0].replacingOccurrences(of: " ", with: "+")
            let state = strAd.components(separatedBy: "region\">")[1].components(separatedBy: "<")[0]
            var n = self.name.replacingOccurrences(of: " ", with: "+")
            var a = self.name.replacingOccurrences(of: " ", with: "+")
            a = a.replacingOccurrences(of: "'", with: "")
            a = a.replacingOccurrences(of: "#", with: "")
            n = n.replacingOccurrences(of: "'", with: "")
            var yelpURL = "http://iosappserver-env.us-east-2.elasticbeanstalk.com/yelp?name=" + n + "&address="
            yelpURL += a + "&city=" + city + "&state="
            yelpURL += state + "&postal_code=" + postalCode
            yelpURL += "&latitude=" + lat + "&longitude=" + long
            print("yelp url \(yelpURL)")
            Alamofire.request(yelpURL).responseSwiftyJSON { response in
                let yelp = response.result.value
                if (yelp!["status"] != "No match found") {
                    let s = self.viewControllers![3] as! ReviewViewController
                    s.yelpReviewArray = yelp!["reviews"].arrayObject as! [[String:AnyObject]]
                    s.yelpReviewArraySort = yelp!["reviews"].arrayObject as! [[String:AnyObject]]
                }
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
                                      target: self, action: #selector(favToggle))
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
            let btnFav = UIBarButtonItem(image: UIImage(named: "favorite-empty"),
                                  style: UIBarButtonItemStyle.plain ,
                                  target: self, action: #selector(favToggle))
            self.navigationItem.rightBarButtonItems![0] = btnFav
            if let cntrl = self.navigationController?.viewControllers[(viewControllers?.count)!-3] as? TableViewController {
                print("tablecntrl")
                let cell = cntrl.tblJSON.cellForRow(at: IndexPath.init(row: self.rowCell, section: 0)) as! CustomTableViewCell
                cell.fav = false
                cell.favorites.setImage(UIImage(named: "favorite-empty"), for: [])
                cntrl.addRemoveFavWithPID(rowInd: self.rowCell)
            }
            else if let cntrl = self.navigationController!.viewControllers.first as? ViewController {
                var temp = [String:String]()
                temp["name"] = self.name
                temp["address"] = self.address
                temp["placeId"] = self.placeId
                temp["iconString"] = self.iconString
                cntrl.updateFav(favAr: temp, add: false)
            }
        }
        else {
            self.favSelect = true
            let btnFav = UIBarButtonItem(image: UIImage(named: "favorite-filled"),
                                         style: UIBarButtonItemStyle.plain ,
                                         target: self, action: #selector(favToggle))
            self.navigationItem.rightBarButtonItems![0] = btnFav
            if let cntrl = self.navigationController?.viewControllers[(viewControllers?.count)!-3] as? TableViewController {
                print("tablecntrl")
                let cell = cntrl.tblJSON.cellForRow(at: IndexPath.init(row: self.rowCell, section: 0)) as! CustomTableViewCell
                cell.fav = false
                cell.favorites.setImage(UIImage(named: "favorite-filled"), for: [])
                cntrl.addRemoveFavWithPID(rowInd: self.rowCell)
            }
            else if let cntrl = self.navigationController!.viewControllers.first as? ViewController {
                var temp = [String:String]()
                temp["name"] = self.name
                temp["address"] = self.address
                temp["placeId"] = self.placeId
                temp["iconString"] = self.iconString
                cntrl.updateFav(favAr: temp, add: true)
            }
        }
    }
}
