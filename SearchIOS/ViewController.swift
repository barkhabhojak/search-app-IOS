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
    
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mcTextField: McTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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
                url = "http://placesearch-env.us-east-2.elasticbeanstalk.com/result?keyw=" + replaceString(str: keyword) + "&category=" + replaceString(str: category) + "&distance=" + replaceString(str: distance) + "&locOpt=curr-loc-" + latitude + "%2C" + longitude
            }
            else {
                url = "http://placesearch-env.us-east-2.elasticbeanstalk.com/result?keyw=" + replaceString(str: keyword) + "&category=" + replaceString(str: category) + "&distance=" + replaceString(str: distance) + "&locOpt=other-loc&loc=" + replaceString(str: locationString)
            }
            //http://placesearch-env.us-east-2.elasticbeanstalk.com/result?keyw=pizza&category=Default&distance=15&locOpt=curr-loc-34.0266%2C-118.2831"
            //http://placesearch-env.us-east-2.elasticbeanstalk.com/result?keyw=pizza&category=Default&distance=25&locOpt=other-loc&loc=North+Alameda+Street%2C+Los+Angeles%2C+CA%2C+USA
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navbar.backBarButtonItem = backItem
        if segue.destination is TableViewController
        {
            let vc = segue.destination as? TableViewController
            vc?.url = self.url
        }
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
