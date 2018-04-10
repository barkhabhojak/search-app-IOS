//
//  ReviewViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/8/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import SafariServices

class ReviewViewController: UIViewController {
    var name = ""
    var address = ""
    var web = ""
    var googleReviewArray = [[String:Any]]()
    var yelpReviewArray = [[String:AnyObject]]()
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var orderSegment: UISegmentedControl!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    @IBOutlet weak var reviewSegment: UISegmentedControl!
    @IBOutlet weak var navbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("review view controller")
        self.reviewTable.tableFooterView = UIView(frame: CGRect.zero)
        reviewTable.rowHeight = 150
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reviewSegmentChange(_ sender: Any) {
        if self.reviewSegment.selectedSegmentIndex == 0 {
            if self.googleReviewArray.count == 0 {
                self.reviewTable.reloadData()
                errorMessage(str: "no results")
            }
            else {
                self.reviewTable.reloadData()
            }
        }
        else {
            if self.yelpReviewArray.count == 0 {
                self.reviewTable.reloadData()
                errorMessage(str: "no results")
            }
            else {
                self.reviewTable.reloadData()
            }
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
        self.reviewTable.backgroundView = messageLabel;
        self.reviewTable.separatorStyle = .none;
    }
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reviewSegment.selectedSegmentIndex == 0 {
            return googleReviewArray.count
        }
        else if reviewSegment.selectedSegmentIndex == 1 {
            return yelpReviewArray.count
        }
        else {
            return 0;
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell") as! ReviewCustomTableViewCell
        if reviewSegment.selectedSegmentIndex == 0 {
            var dict = googleReviewArray[(indexPath as NSIndexPath).row]
            cell.urlOfReview = (dict["author_url"] as? String)!
            cell.name.text = (dict["author_name"] as? String)!
            cell.reviewText.text = (dict["text"] as? String)!
            cell.starsView.rating = (dict["rating"] as? Double)!
            var day = Date(timeIntervalSince1970: (dict["time"] as? Double)!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from:day as Date)
            cell.dateTime.text = dateString
            let temp = (dict["profile_photo_url"] as? String)!
            if let data = try? Data(contentsOf: URL(string: temp)!)
            {
                let image: UIImage = UIImage(data: data)!
                cell.profileImage.image = image
            }
        }
        else {
            var dict = yelpReviewArray[(indexPath as NSIndexPath).row]
            cell.urlOfReview = (dict["url"] as? String)!
            cell.name.text = (dict["user"]!["name"] as? String)!
            cell.reviewText.text = (dict["text"] as? String)!
            cell.starsView.rating = (dict["rating"] as? Double)!
            cell.dateTime.text = (dict["time_created"] as? String)!
            let temp = dict["user"]!["image_url"] as? String
            if temp != nil {
                if let data = try? Data(contentsOf: URL(string: temp!)!)
                {
                    let image: UIImage = UIImage(data: data)!
                    cell.profileImage.image = image
                }
            }
            else {
                cell.profileImage.image = nil
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ReviewCustomTableViewCell
        let link = cell.urlOfReview
        let svc = SFSafariViewController(url: URL(string: link)!)
        present(svc, animated: true, completion: nil)
    }

}


