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

class TableViewController: UIViewController {
    
    var url = ""
    var currPageIndex = 0
    @IBOutlet weak var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]()
    var nextPageTokens = [String]()
    var pid = ""
    var name = ""
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    var favArray = [[String:String]]()
    var isFav = false
    var selRow = 0
    var iconString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Results"
        self.tblJSON.tableFooterView = UIView(frame: CGRect.zero)
        tblJSON.rowHeight = 73
//        tblJSON.separatorStyle = UITableViewCellSeparatorStyle.singleLine
//        tblJSON.separatorColor = UIColor.gray
        print("table view url = " + url);
        //print(self.navigationController!.viewControllers.first)
        getResults();
    }

    func getResults() {
        SwiftSpinner.show("Searching..")
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
                self.errorMessage(str: "no results")
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            else {
                self.errorMessage(str: "error")
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }

            SwiftSpinner.hide()
        }
    }
    
    func errorMessage(str: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        if str == "no results" {
            messageLabel.text = "No results found."
        }
        else {
            messageLabel.text = "Error in retrieving details."
        }
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        self.tblJSON.backgroundView = messageLabel;
        self.tblJSON.separatorStyle = .none;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func getNextPage(_ sender: UIButton) {
        var token = self.nextPageTokens[currPageIndex]
        var tempUrl = "http://iosappserver-env.elasticbeanstalk.com/result?next_page_token=" + token.replacingOccurrences(of: " ", with: "")
        SwiftSpinner.show("Loading Next Page..")
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
                self.errorMessage(str: "no results")
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            else {
                self.errorMessage(str: "error")
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
            tempUrl = "http://iosappserver-env.us-east-2.elasticbeanstalk.com/result?next_page_token=" + token.replacingOccurrences(of: " ", with: "")
        }
        else {
            tempUrl = url
        }
        SwiftSpinner.show("Loading Previous Page..")
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
                self.errorMessage(str: "no results")
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            else {
                self.errorMessage(str: "error")
                self.prevBtn.isEnabled = false
                self.nextBtn.isEnabled = false
            }
            SwiftSpinner.hide()
        }
        self.currPageIndex -= 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.destination is TabViewController
        {
            let vc = segue.destination as? TabViewController
            vc?.placeId = self.pid
            vc?.url = self.url
            vc?.name = self.name
            vc?.favSelect = self.isFav
            vc?.rowCell = self.selRow
            vc?.iconString = self.iconString
        }
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
        cell.placeId = dict["place_id"] as! String
        let f = foundInArr(placeID: cell.placeId)
        cell.iconString = dict["icon"] as! String
        let url = URL(string:dict["icon"] as! String)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            cell.icon.image = image
        }
        let cntrl = self.navigationController!.viewControllers.first as! ViewController
        let arr = cntrl.foundInArr(placeID: cell.placeId)
        if arr != -10{
            cell.favorites.setImage(UIImage(named: "favorite-filled"), for: [])
            cell.fav = true
        }
        else {
            cell.favorites.setImage(UIImage(named: "favorite-empty"), for: [])
            cell.fav = false
        }
//        if cell.fav || f >= 0{
//            cell.favorites.setImage(UIImage(named: "favorite-filled"), for: [])
//        }
//        else if !cell.fav || f == -10 {
//            cell.favorites.setImage(UIImage(named: "favorite-empty"), for: [])
//        }
        cell.favorites.tag = indexPath.row
        cell.favorites.addTarget(self, action: #selector(addRemoveFav(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        selRow = indexPath.row
        pid = cell.placeId
        isFav = cell.fav
        name = cell.name.text!
        iconString = cell.iconString
        performSegue(withIdentifier: "details", sender: nil)
    }
    
    @objc func addRemoveFav(sender: UIButton){
        let cntrl = self.navigationController!.viewControllers.first as! ViewController
        let buttonTag = sender.tag
        let ind = IndexPath.init(row: buttonTag, section: 0)
        let cell = self.tblJSON.cellForRow(at: ind) as! CustomTableViewCell
        let f = foundInArr(placeID: cell.placeId)
        var temp = [String:String]()
        temp["name"] = cell.name.text
        temp["address"] = cell.address.text
        temp["placeId"] = cell.placeId
        temp["iconString"] = cell.iconString
        if f == -10 {
            cntrl.updateFav(favAr: temp, add: true)
            favArray.append(temp)
        }
        else {
            cntrl.updateFav(favAr: temp, add: false)
            favArray.remove(at: f)
        }
    }
    
    func addRemoveFavWithPID(rowInd: Int){
        let cntrl = self.navigationController!.viewControllers.first as! ViewController
        let ind = IndexPath.init(row: rowInd, section: 0)
        let cell = self.tblJSON.cellForRow(at: ind) as! CustomTableViewCell
        let f = foundInArr(placeID: cell.placeId)
        var temp = [String:String]()
        temp["name"] = cell.name.text
        temp["address"] = cell.address.text
        temp["placeId"] = cell.placeId
        temp["iconString"] = cell.iconString
        if f == -10 {
            cntrl.updateFav(favAr: temp, add: true)
            favArray.append(temp)
        }
        else {
            cntrl.updateFav(favAr: temp, add: false)
            favArray.remove(at: f)
        }
    }
    
    func foundInArr(placeID: String) -> Int {
        for (index,favItem) in favArray.enumerated() {
            if favItem["placeId"] == placeID {
                return index
            }
        }
        return -10
    }
}
