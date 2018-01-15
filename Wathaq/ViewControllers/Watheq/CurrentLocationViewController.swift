//
//  CurrentLocationViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 12/12/17.
//  Copyright © 2017 Ahmed Zaky. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GoogleMaps


class CurrentLocationViewController: UIViewController,CLLocationManagerDelegate,ToastAlertProtocol {

    var TotalCost : Int!
    var NumOfSteps : Int!

    var OrderDataDic : NSMutableDictionary!
    var locationManager:CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ChooseAdreess", comment: "")

        self.setupLocationManager()
  }
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.startUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: 24.7136,
                                              longitude: 46.6753,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        let button = UIButton(frame: CGRect(x: self.view.center.x - (self.view.frame.size.width - 50)/2, y: self.view.frame.size.height - 200, width: self.view.frame.size.width - 50 , height: 60))
        button.backgroundColor = UIColor.deepBlue
        button.setTitle(NSLocalizedString("ChooseAdreess", comment: ""), for: .normal)
        button.titleLabel?.font =  UIFont(name: Constants.FONTS.FONT_AR, size: 17)
        button.roundCorners([.topLeft, .topRight, .bottomLeft ,.bottomRight], radius: 10)
        button.addTarget(self, action: #selector(ChooseAddress), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    @IBAction func ChooseAddress (_ sender : Any)
    {
        
        if OrderDataDic.value(forKey: "longitude") != nil && OrderDataDic.value(forKey: "latitude") != nil{
            
           // _ = navigationController?.popViewController(animated: true)
            self.performSegue(withIdentifier: "S_Location_WakeelTime", sender: OrderDataDic)

        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("pleaseChooseaddressFirst"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)

        }
        
    }
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if currentLocation == nil {
            currentLocation = locations.last
            locationManager?.stopMonitoringSignificantLocationChanges()
            let locationValue:CLLocationCoordinate2D = manager.location!.coordinate
            print("locations = \(locationValue)")
            locationManager?.stopUpdatingLocation()
            let camera = GMSCameraPosition.camera(withLatitude: (currentLocation?.coordinate.latitude)!,
                                                  longitude: (currentLocation?.coordinate.longitude)!,
                                                  zoom: zoomLevel)
            OrderDataDic.setValue((currentLocation?.coordinate.latitude), forKey: "latitude")
            OrderDataDic.setValue((currentLocation?.coordinate.longitude), forKey: "longitude")
            
            
            if mapView.isHidden {
                mapView.isHidden = false
                mapView.camera = camera
            } else {
                mapView.animate(to: camera)
            }
           
            
        }
    }
    // Below Mehtod will print error if not able to update location.
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
        mapView.isHidden = false

    }
    
   
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "S_Location_WakeelTime"  {
            let OrderDic = sender as!  NSMutableDictionary
            let ArrivalTimeView = segue.destination as! MoawtheqArrivalTimeViewController
            ArrivalTimeView.OrderDataDic = OrderDic
            ArrivalTimeView.TotalCost = self.TotalCost
            ArrivalTimeView.NumOfSteps = NumOfSteps - 1

        }
    }

}

extension CurrentLocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        mapView.clear() // clearing Pin before adding new
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        OrderDataDic.setValue(coordinate.latitude, forKey: "latitude")
        OrderDataDic.setValue(coordinate.longitude, forKey: "longitude")
    }

}

