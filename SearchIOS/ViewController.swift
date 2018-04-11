//
//  ViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/5/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import McPicker
import EasyToast

class ViewController: UIViewController {
    
    var keyword = "pizza"
    var category = "Default"
    var location = ""
    var locationString = "Your Location"
    var distance = "10"
    var url = ""
    var latitude = ""
    var longitude = ""
    var favArray = [[String:String]]()
    var selectedPID = ""
    var nameSelect = ""
    var addSelect = ""
    var iconString = ""
    
    //for favorites you need name,address,icon,placeID
    
    @IBOutlet weak var favTableView: UITableView!
    @IBOutlet weak var segSearchFav: UISegmentedControl!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var favView: UIView!
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mcTextField: McTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkFav()
        favView.isHidden = true
        self.favTableView.rowHeight = 73
        navbar.title = "Place Search"
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        currentLocation = locManager.location
        longitude = String(format:"%f", currentLocation.coordinate.longitude)
        latitude = String(format:"%f", currentLocation.coordinate.latitude)
        
        let data: [[String]] = [["Default", "Airport","Amusement Park", "Aquarium", "Art Gallery", "Bakery", "Bar", "Beauty Salon", "Bowling Alley", "Bus Station", "Cafe", "Campground", "Car Rental", "Casino", "Lodging", "Movie Theater", "Museum", "Night Club", "Park", "Parking", "Restaurant", "Shopping Mall", "Stadium", "Subway Station", "Taxi Stand", "Train Station", "Transit Agency", "Zoo"]]
        let mcInputView = McPicker(data: data)
        mcTextField.inputViewMcPicker = mcInputView
        mcTextField.doneHandler = { [weak mcTextField] (selections) in
            mcTextField?.text = selections[0]!
            self.category = (mcTextField?.text)!
            //do something if user selects an option and taps done
        }
            mcTextField.cancelHandler = { [weak mcTextField] in
                //do something if user cancels
            }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func autocomplete(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        print ("Location string: " + locationString)
    }
    
    func errorMessage(str: String) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        if str == "no results" {
            messageLabel.text = "No favorites."
        }
        else {
            messageLabel.text = "Error in retrieving details."
        }
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        self.favTableView.backgroundView = messageLabel;
        self.favTableView.separatorStyle = .none;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.favTableView.reloadData()
    }
    
    @IBAction func distanceEdit(_ sender: Any) {
        self.distance = distanceTextField.text!
    }


    @IBAction func keywordEdit(_ sender: Any) {
        self.keyword = keywordTextField.text!
    }

    @IBAction func clearBtnPress(_ sender: UIButton) {
        keywordTextField.text = ""
        distanceTextField.text = ""
        distanceTextField.placeholder = "Enter distance (default 10 miles)"
        locationTextField.text = "Your Location"
        mcTextField.text = "Default"
        self.keyword = ""
        self.category = "Default"
        self.location = ""
        self.locationString = "Your location"
        self.distance = "10"
    }
    
    @IBAction func searchBtnPress(_ sender: UIButton) {
        if keyword.replacingOccurrences(of: " ", with: "").isEmpty {
            print("key")
            self.view.showToast("Keyword cannot be empty", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
        }

        else if locationString.replacingOccurrences(of: " ", with: "").isEmpty {
            print("loc")
            self.view.showToast("Location cannot be empty", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
        }

        else if !distance.isNumeric {
            print("dist")
            self.view.showToast("Distance must be a number", position: .bottom, popTime: 3, dismissOnTap: false, bgColor: UIColor.black, textColor: UIColor.white, font: UIFont.boldSystemFont(ofSize: 19))
        }

        else if !keyword.replacingOccurrences(of: " ", with: "").isEmpty && !category.replacingOccurrences(of: " ", with: "").isEmpty && !distance.replacingOccurrences(of: " ", with: "").isEmpty && !locationString.replacingOccurrences(of: " ", with: "").isEmpty && distance.isNumeric {
            
            if locationString.lowercased() == "your location" || locationString.lowercased() == "my location" {
                url = "http://iosappserver-env.us-east-2.elasticbeanstalk.com/result?keyw=" + replaceString(str: keyword) + "&category=" + replaceString(str: category) + "&distance=" + replaceString(str: distance) + "&locOpt=curr-loc-" + latitude + "%2C" + longitude
            }
            else {
                url = "http://iosappserver-env.us-east-2.elasticbeanstalk.com/result?keyw=" + replaceString(str: keyword) + "&category=" + replaceString(str: category) + "&distance=" + replaceString(str: distance) + "&locOpt=other-loc&loc=" + replaceString(str: locationString)
            }
            //http://iosappserver-env.us-east-2.elasticbeanstalk.com/result?keyw=pizza&category=Default&distance=15&locOpt=curr-loc-34.0266%2C-118.2831"
            //http://iosappserver-env.us-east-2.elasticbeanstalk.com/result?keyw=pizza&category=Default&distance=25&locOpt=other-loc&loc=North+Alameda+Street%2C+Los+Angeles%2C+CA%2C+USA
            performSegue(withIdentifier: "search", sender: nil)
            
//            print("keyword = " + keyword)
//            print("category = " + category)
//            print("location string = " + locationString)
//            print("distance = " + distance)

        }
        
    }
    
    func replaceString(str: String) -> String {
        var newStr = ""
        newStr = str.replacingOccurrences(of: "'", with: "")
        newStr = newStr.replacingOccurrences(of: ",", with: "")
        newStr = newStr.replacingOccurrences(of: " ", with: "+")
        return newStr
    }
    
    @IBAction func changeSeg(_ sender: Any) {
        if self.segSearchFav.selectedSegmentIndex == 0 {
            //favView.alpha = 0
            searchView.isHidden = false
            favView.isHidden = true
            //searchView.alpha = 1
        }
        else {
            //searchView.alpha = 0
            favView.isHidden = false
            searchView.isHidden = true
            //favView.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navbar.backBarButtonItem = backItem
        if segue.destination is TableViewController
        {
            let vc = segue.destination as? TableViewController
            vc?.url = self.url
        }
        if segue.destination is TabViewController
        {
            let vc = segue.destination as? TabViewController
            vc?.placeId = self.selectedPID
            vc?.favSelect = true
            vc?.iconString = self.iconString
            vc?.name = self.nameSelect
            vc?.address = self.addSelect
        }
    }
    
    func checkFav() {
        print("check fav")
        if self.favArray.count == 0 {
            errorMessage(str: "no results")
        }
        else {
            self.favTableView.backgroundView = UIView();
            self.favTableView.tableFooterView = UIView(frame: CGRect.zero)
            self.favTableView.separatorStyle = .singleLine;
            self.favTableView.reloadData()
        }
    }
    
    func updateFav(favAr: [String:String], add: Bool) {
        if add {
            let f = foundInArr(placeID: favAr["placeId"]!)
            if f == -10 {
                self.favArray.append(favAr)
            }
        }
        else {
            let f = foundInArr(placeID: favAr["placeId"]!)
            self.favArray.remove(at: f)
        }
        if self.favArray.count == 0 {
            errorMessage(str: "no results")
        }
        else {
            self.favTableView.backgroundView = UIView();
            self.favTableView.tableFooterView = UIView(frame: CGRect.zero)
            self.favTableView.separatorStyle = .singleLine;
            self.favTableView.reloadData()
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

extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        location = place.name
        locationString = place.name + ", " + place.formattedAddress!
        locationTextField.text = locationString
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favArray.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.favArray.remove(at: indexPath.row)
            let range = NSMakeRange(0, tableView.numberOfSections)
            let sections = NSIndexSet(indexesIn: range)
            self.favTableView.reloadSections(sections as IndexSet, with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! CustomTableViewCell
        var dict = favArray[(indexPath as NSIndexPath).row]
        
        cell.favName.text = dict["name"] as! String
        cell.favAdd.text = dict["address"] as! String
        cell.placeId = dict["placeId"] as! String
        let url = URL(string:dict["iconString"] as! String)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data)!
            cell.favIcon.image = image
        }
        cell.fav = true
        cell.tag = indexPath.row
//        cell.addTarget(self, action: #selector(selectCell(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        print("fav selected")
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
        self.selectedPID = cell.placeId
        self.nameSelect = cell.favName.text!
        self.addSelect = cell.favAdd.text!
        self.iconString = cell.iconString
        performSegue(withIdentifier: "favDetails", sender: nil)
    }

}
