//
//  MapsViewController.swift
//  SearchIOS
//
//  Created by Barkha Bhojak on 4/8/18.
//  Copyright © 2018 Barkha Bhojak. All rights reserved.
//

import UIKit
import SafariServices
import GooglePlaces
import GoogleMaps

class MapsViewController: UIViewController {
    var name = ""
    var address = ""
    var fromName = ""
    var fromAdd = ""
    var web = ""
    var destLat : Double = 0.0
    var destLong : Double = 0.0
    
    @IBOutlet weak var fromInputTextField: UITextField!
    @IBOutlet weak var navbar: UINavigationItem!
    @IBOutlet weak var mapArea: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("map view controller")
    }

    func formMap() {
        print("latitude is \(self.destLat) and longitude is \(self.destLong)")
        let camera = GMSCameraPosition.camera(withLatitude: self.destLat, longitude: self.destLong, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.destLat, longitude: self.destLong)
        marker.map = mapView
        //view = mapView
        mapArea = mapView
    }
    
    @IBAction func autocomplete(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MapsViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.fromName = place.name
        self.fromAdd = place.formattedAddress!
        fromInputTextField.text = place.formattedAddress!
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
