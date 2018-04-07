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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("url found 123 = " + url);
        getResults();
        //SwiftSpinner.show("Searching")
        //SwiftSpinner.hide()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getResults() {
        SwiftSpinner.show("Searching")
        Alamofire.request(url).responseSwiftyJSON { response in
            let json = response.result.value //A JSON object
            print (json)
//            let isSuccess = response.result.isSuccess
//            if (isSuccess && (json != nil)) {
//                //do something
//            }
            SwiftSpinner.hide()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
