//
//  ViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/5/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import McPicker
import GooglePlaces

class ViewController: UIViewController {
    
    var keyword = ""
    var category = ""
    var location = ""
    var locationString: String = ""
    var distance = ""
    
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mcTextField: McTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func finishKeywordEdit(_ sender: UITextField) {
        self.keyword = keywordTextField.text!
    }
    
    @IBAction func finishDistanceEdit(_ sender: UITextField) {
        self.distance = distanceTextField.text!
    }
    
    @IBAction func autocomplete(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
        print ("Location string: " + locationString)
    }
    
    @IBAction func clearBtnPress(_ sender: UIButton) {
        keywordTextField.text = ""
        distanceTextField.text = ""
        distanceTextField.placeholder = "Enter distance (default 10 miles)"
        locationTextField.text = "Your Location"
        mcTextField.text = "Default"
    }
    
    @IBAction func searchBtnPress(_ sender: UIButton) {
        print("keyword = " + keyword)
        print("category = " + category)
        print("location string = " + locationString)
        print("distance = " + distance)
    }
    
    
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
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
