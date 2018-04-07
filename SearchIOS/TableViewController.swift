//
//  TableViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/6/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import SwiftSpinner
import Alamofire
import AlamofireSwiftyJSON

class TableViewController: UIViewController,UIGestureRecognizerDelegate {
    
    var url = ""
    var currPageIndex = 0
    @IBOutlet weak var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]()
    var nextPageTokens = [String]()
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblJSON.tableFooterView = UIView(frame: CGRect.zero)
        tblJSON.rowHeight = 70
//        tblJSON.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//        tblJSON.separatorColor = UIColor.gray
        print("url = " + url);
        getResults();
    }

    func getResults() {
        SwiftSpinner.show("Searching..")
        print ("url = " + url)
        Alamofire.request(url).responseSwiftyJSON { response in
            let places = response.result.value //A JSON object
            if places!["status"] == "OK" {
                if let resData = places!["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                self.prevBtn.isEnabled = false;
                if let val = places?["next_page_token"] {
                    self.nextPageTokens.append(val.string!)
                    self.nextBtn.isEnabled = true
                }
                else {
                    self.nextBtn.isEnabled = false
                }
                self.tblJSON.reloadData()
            }
            else if places!["status"] == "ZERO_RESULTS" {
                self.view.showToast("No results", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            else {
                self.view.showToast("Error in retrieving details", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }

            SwiftSpinner.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func getNextPage(_ sender: UIButton) {
        var token = self.nextPageTokens[currPageIndex]
        var tempUrl = "http://placesearch-env.us-east-2.elasticbeanstalk.com/result?next_page_token=" + token.replacingOccurrences(of: " ", with: "")
        SwiftSpinner.show("Getting Next Page..")
        print ("next url = " + url)
        Alamofire.request(tempUrl).responseSwiftyJSON { response in
            let places = response.result.value //A JSON object
            if places!["status"] == "OK" {
                if let resData = places!["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.currPageIndex == 0 {
                    self.prevBtn.isEnabled = false;
                }
                else {
                    self.prevBtn.isEnabled = true;
                }
                if let val = places?["next_page_token"] {
                    if val != nil {
                        self.nextPageTokens.append(val.string!)
                        self.nextBtn.isEnabled = true
                    }
                    else {
                        self.nextBtn.isEnabled = false
                    }
                }
                else {
                    self.nextBtn.isEnabled = false
                }
                self.tblJSON.reloadData()
            }
            else if places!["status"] == "ZERO_RESULTS" {
                self.view.showToast("No results", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            else {
                self.view.showToast("Error in retrieving details", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            SwiftSpinner.hide()
        }
        self.currPageIndex += 1
    }
    
    @IBAction func getPrevPage(_ sender: UIButton) {
        var tempUrl = ""
        if self.currPageIndex - 2 >= 0 {
            var token = self.nextPageTokens[currPageIndex-2]
            tempUrl = "http://placesearch-env.us-east-2.elasticbeanstalk.com/result?next_page_token=" + token.replacingOccurrences(of: " ", with: "")
        }
        else {
            tempUrl = url
        }
        SwiftSpinner.show("Getting Previous Page..")
        print ("prev url = " + url)
        Alamofire.request(tempUrl).responseSwiftyJSON { response in
            let places = response.result.value //A JSON object
            if places!["status"] == "OK" {
                if let resData = places!["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.currPageIndex == 0 {
                    self.prevBtn.isEnabled = false;
                }
                else {
                    self.prevBtn.isEnabled = true;
                }
                if self.nextPageTokens.count > self.currPageIndex - 1 {
                    self.nextBtn.isEnabled = true
                }
                else {
                    self.nextBtn.isEnabled = false
                }
                self.tblJSON.reloadData()
            }
            else if places!["status"] == "ZERO_RESULTS" {
                self.view.showToast("No results", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            else {
                self.view.showToast("Error in retrieving details", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            SwiftSpinner.hide()
        }
        self.currPageIndex -= 1
    }
    
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        var dict = arrRes[(indexPath as NSIndexPath).row]
        cell.name.text = dict["name"] as? String
        cell.address.text = dict["vicinity"] as? String
        let url = URL(string:dict["icon"] as! String)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            cell.icon.image = image
        }
        cell.favorites.image = UIImage(named: "favorite-empty")
        cell.placeId = dict["place_id"] as! String
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        //print(cell.name.text as! String)
        print(cell.placeId)
    }
    
}
