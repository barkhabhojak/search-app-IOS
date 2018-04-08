//
//  InfoViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/7/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import SafariServices

class InfoViewController: UIViewController {

    @IBOutlet weak var navbar: UINavigationItem!
    var placeId = ""
    var url = ""
    var name = ""
    var address = ""
    var web = ""
    //let placesClient = GMSPlacesClient()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("info view controller")
        navbar.title = self.name
        //getDetails()
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
    
    
//    func apiClient() {
//        placesClient.lookUpPlaceID(self.placeId, callback: { (place, error) -> Void in
//            if let error = error {
//                print("lookup place id query error: \(error.localizedDescription)")
//                return
//            }
//
//            guard let place = place else {
//                print("No place details for \(self.placeId)")
//                return
//            }
//            self.address = place.formattedAddress!
//            print(place)
//        })
//    }
    
}
