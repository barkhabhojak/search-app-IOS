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
    
    @IBOutlet weak var reviewTable: UITableView!
    @IBOutlet weak var orderSegment: UISegmentedControl!
    @IBOutlet weak var sortSegment: UISegmentedControl!
    @IBOutlet weak var reviewSegment: UISegmentedControl!
    @IBOutlet weak var navbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("review view controller")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
