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
import Alamofire
import AlamofireSwiftyJSON

class MapsViewController: UIViewController {
    var name = ""
    var address = ""
    var fromName = ""
    var fromAdd = ""
    var web = ""
    var destLat : Double = 0.0
    var destLong : Double = 0.0
    var modeOfTravel = "driving"
    
    @IBOutlet weak var mapArea: UIView!
    @IBOutlet weak var fromInputTextField: UITextField!
    @IBOutlet weak var navbar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("map view controller")
    }

    func formMap() {
        print("latitude is \(self.destLat) and longitude is \(self.destLong)")
        let camera = GMSCameraPosition.camera(withLatitude: self.destLat, longitude: self.destLong, zoom: 15.0)
        print("check or \(self.view.frame.origin.x) \(self.view.frame.origin.y)")
        var mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 8, width: 340, height: 400), camera: camera)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: self.destLat, longitude: self.destLong)
        marker.map = mapView
        //view = mapView
        //mapArea = mapView
        //mapView.center = self.view.center
        self.mapArea.addSubview(mapView)
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
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes = json["routes"] as? [Any]
                        let overview_polyline = routes?[0] as?[String:Any]
                        let polyString = overview_polyline?["points"] as?String
                        
                        //Call this method to draw path on map
                        self.showPath(polyStr: polyString!)
                    }
                    
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = mapArea.subviews[0] as! GMSMapView
    }
    
    func getGooglePath() {
        print("get path")
        var from = self.fromAdd.replacingOccurrences(of: " ", with: "+")
        from = from.replacingOccurrences(of: ",", with: "")
        from = from.replacingOccurrences(of: "'", with: "")
        var destCoord = String(self.destLat) + "," + String(self.destLong)
        var tempU = "http://iosappserver-env.us-east-2.elasticbeanstalk.com/googlepath?origin=" + from + "&destination=" + destCoord + "&mode=" + self.modeOfTravel
        Alamofire.request(tempU).responseSwiftyJSON { response in
            let places = response.result.value
            let routes = places!["routes"] as? [Any]
            let overview_polyline = routes?[0] as?[String:Any]
            let polyString = overview_polyline?["points"] as?String
            
            self.showPath(polyStr: polyString!)
        }
        
    }
}


extension MapsViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.fromName = place.name
        self.fromAdd = place.formattedAddress!
        fromInputTextField.text = place.formattedAddress!
        dismiss(animated: true, completion: nil)
        getGooglePath()
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
