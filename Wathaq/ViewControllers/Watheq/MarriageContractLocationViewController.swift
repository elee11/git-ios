//
//  MarriageContractLocationViewController.swift
//  Wathaq
//
//  Created by Ahmed Zaky on 1/1/18.
//  Copyright © 2018 Ahmed Zaky. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GoogleMaps
import TransitionButton

class MarriageContractLocationViewController: UIViewController,CLLocationManagerDelegate,ToastAlertProtocol {

    var OrderDataDic : NSMutableDictionary!
    var locationManager:CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    var ConfirmButton : TransitionButton!
    var viewModel: OrderViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OrderViewModel()

        self.title = NSLocalizedString("ChooseAdreess", comment: "")
        self.setupLocationManager()

        // Do any additional setup after loading the view.
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
        
        ConfirmButton = TransitionButton()
          ConfirmButton.frame  = CGRect(x: self.view.center.x - (self.view.frame.size.width - 50)/2, y: self.view.frame.size.height - 200, width: self.view.frame.size.width - 50 , height: 60)
        ConfirmButton.backgroundColor = UIColor.deepBlue
        ConfirmButton.setTitle(NSLocalizedString("CreatOrder", comment: ""), for: .normal)
        ConfirmButton.titleLabel?.font =  UIFont(name: Constants.FONTS.FONT_AR, size: 17)
        ConfirmButton.roundCorners([.topLeft, .topRight, .bottomLeft ,.bottomRight], radius: 10)
        ConfirmButton.addTarget(self, action: #selector(ChooseAddress), for: .touchUpInside)
        self.view.addSubview(ConfirmButton)
    }
    
    @IBAction func ChooseAddress (_ sender : Any)
    {
        
        if OrderDataDic.value(forKey: "longitude") != nil && OrderDataDic.value(forKey: "latitude") != nil{
        self.CreateOrder()
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("pleaseChooseaddressFirst"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            
        }
        
    }
    
    
   func CreateOrder ()
    {
        
        if OrderDataDic.value(forKey: "delivery") != nil {
            ConfirmButton.startAnimation()
            self.view.isUserInteractionEnabled = false
            if OrderDataDic.value(forKey: "longitude") == nil && OrderDataDic.value(forKey: "latitude") == nil{
                OrderDataDic.setValue(0, forKey: "longitude")
                OrderDataDic.setValue(0, forKey: "latitude")
            }
            
            if OrderDataDic.value(forKey: "clientName") == nil
            {
                OrderDataDic.setValue("", forKey: "clientName")
                OrderDataDic.setValue("", forKey: "clientNationalID")
                
                OrderDataDic.setValue("", forKey: "representativeName")
                OrderDataDic.setValue("", forKey: "representativeNationalID")
            }
            
            
            viewModel.CreateNekahOrder(OrderDic: OrderDataDic, completion: { (OrderObj, errorMsg) in
                if errorMsg == nil {
                    
                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                    
                    self.showToastMessage(title:NSLocalizedString("OrderProceeded", comment: "") , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.greenAlert, foregroundColor: UIColor.white)
                    
                    self.performSegue(withIdentifier: "S_MarriageContractLocation_SearchingLawyers", sender:OrderObj)
                    
                } else{
                    self.showToastMessage(title:errorMsg! , isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
                    self.ConfirmButton.stopAnimation()
                    self.view.isUserInteractionEnabled = true
                }
            })
            
            
        }
        else
        {
            self.showToastMessage(title: NSLocalizedString(("pleaseChooseDeliveryLocation"), comment: ""), isBottom:true , isWindowNeeded: true, BackgroundColor: UIColor.redAlert, foregroundColor: UIColor.white)
            
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
        if segue.identifier == "S_MarriageContractLocation_SearchingLawyers"  {
            let searchingView = segue.destination as! SearchingForAlawyerViewController
            searchingView.OrderObj = sender as! OrderRootClass
        }
    }
    
}

extension MarriageContractLocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        mapView.clear() // clearing Pin before adding new
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
        OrderDataDic.setValue(coordinate.latitude, forKey: "latitude")
        OrderDataDic.setValue(coordinate.longitude, forKey: "longitude")
    }
    
}


