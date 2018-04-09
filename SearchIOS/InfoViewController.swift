//
//  InfoViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/7/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import Cosmos

class InfoViewController: UIViewController {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var phoneLabel: UITextView!
    @IBOutlet weak var websiteLabel: UITextView!
    @IBOutlet weak var gPageLabel: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addLabel: UILabel!
    @IBOutlet weak var navbar: UINavigationItem!
    var infoDetails = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addLabelsToPage() {
        print("info view controller")
        addLabel.text = (self.infoDetails["address"] as! String)
        phoneLabel.text = (self.infoDetails["number"] as! String)
        var price = Int((self.infoDetails["price"] as! String))
        var priceText = "Free"
        if price != nil && price! > 0 {
            priceText = String(repeating: "$", count: price!)
        }
        var rat = Double((self.infoDetails["rating"] as! String))
        if rat != nil {
            cosmosView.rating = Double((self.infoDetails["rating"] as! String))!
        }
        else {
            cosmosView.rating = 0
        }
        priceLabel.text = priceText
        websiteLabel.text = (self.infoDetails["website"] as! String)
        gPageLabel.text = (self.infoDetails["url"] as! String)
        phoneLabel.font = UIFont(name: (phoneLabel.font?.fontName)!, size: 15)
        websiteLabel.font = UIFont(name: (websiteLabel.font?.fontName)!, size: 14)
        gPageLabel.font = UIFont(name: (gPageLabel.font?.fontName)!, size: 14)
        priceLabel.font = UIFont(name: (priceLabel.font?.fontName)!, size: 15)

    }
 
}

/**    func apiClient() {
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
 */
