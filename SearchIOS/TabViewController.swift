//
//  TabViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/7/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
    var url = ""
    var placeId = ""
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(self.viewControllers?.count)
        var svc = self.viewControllers![0]
        var info = svc.childViewControllers[0] as! InfoViewController
        info.url = self.url
        info.placeId = self.placeId
        info.name = self.name
        print("tab url = \(url)" )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("prepare for segue")
        if segue.destination is InfoViewController
        {
            let vc = segue.destination as? InfoViewController
            vc?.url = self.url
            vc?.placeId = self.placeId
            vc?.name = self.name
        }
    }
    
}
