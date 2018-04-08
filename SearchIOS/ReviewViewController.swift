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
    
    @IBOutlet weak var navbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("review view controller")
        navbar.title = self.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareTwitterClick(_ sender: UIButton) {
        var text = "Check out \(self.name) located at \(self.address). Website: "
        text = text.replacingOccurrences(of: " ", with: "+")
        var link = "https://twitter.com/intent/tweet?text=\(text)&url=\(self.web)";
        let svc = SFSafariViewController(url: URL(string: link)!)
        present(svc, animated: true, completion: nil)
    }

}
