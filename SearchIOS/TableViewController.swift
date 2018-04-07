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
    @IBOutlet weak var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblJSON.tableFooterView = UIView(frame: CGRect.zero)
        tblJSON.rowHeight = 70
        print("url = " + url);
        getResults();
    }

    func getResults() {
        SwiftSpinner.show("Searching")
        print ("url = " + url)
        Alamofire.request(url).responseSwiftyJSON { response in
            let places = response.result.value //A JSON object
            if places!["status"] == "OK" {
                if let resData = places!["results"].arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                self.tblJSON.reloadData()
            }
            else if places!["status"] == "ZERO_RESULTS" {
                self.view.showToast("No results", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
            }
            else {
                self.view.showToast("Error in retrieving details", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
            }

            SwiftSpinner.hide()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
