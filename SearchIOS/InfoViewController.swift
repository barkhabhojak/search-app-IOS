//
//  InfoViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/7/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    var placeId = ""
    var url = ""
    var name = ""
    
    @IBOutlet weak var navbar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbar.title = name
        print("in info view controller " + placeId)
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
    }
    
}
