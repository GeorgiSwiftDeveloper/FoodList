//
//  ShareUserLocation.swift
//  HealthyPost
//
//  Created by Georgi Malkhasyan on 8/29/19.
//  Copyright © 2019 Malkhasyan. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

//MARK: Use Delegate for pass data back
protocol UserLocationDelegate {
    func getUserLocation(location: String)
}

class ShareUserLocation: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLbl: UILabel!
    private let locationManager = CLLocationManager()
    private let currentLocation = CLLocation()
    private var previousLocation: CLLocation?
    
    
        var locationDelegate: UserLocationDelegate?
    
    private let regionMeters = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled(){
            setupLocation()
            checkLocatiionAuthorization()
        }
        else{
            let alert =  AlertService.alert.alert(message: "Please turn on your Location for start show your current location")
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func  centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: CLLocationDistance(regionMeters), longitudinalMeters: CLLocationDistance(regionMeters))
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocatiionAuthorization (){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTracking()
        case .denied:
            let alert =  AlertService.alert.alert(message: "Please turn on your Location for start show your current location")
            present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .authorizedAlways:
            break
        case .restricted:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTracking(){
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getcenterLocation(for: mapView)
    }
    
    @IBAction func shareLocationBtn(_ sender: Any) {
                  self.locationDelegate?.getUserLocation(location: self.locationLbl.text ?? "")
                dismiss(animated: true, completion: nil)
    }
}
extension ShareUserLocation: CLLocationManagerDelegate  {
    
    func getcenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    //UPDATE USER LOCATION AS THEY MOVE
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: CLLocationDistance(regionMeters), longitudinalMeters: CLLocationDistance(regionMeters)  )
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocatiionAuthorization()
    }
}

extension ShareUserLocation: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getcenterLocation(for: mapView)
        let geocoder = CLGeocoder()
        
        guard self.previousLocation != nil else{ return}
        guard center.distance(from: self.previousLocation!) > 50 else {return}
        previousLocation = center
        geocoder.reverseGeocodeLocation(center) { [weak self] (placemark, error) in
            guard let self = self else {return}
            if let _ = error {
                return
            }
            guard let placemark = placemark?.first else {
                return
            }
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let country = placemark.country ?? ""
            let postalCode = placemark.postalCode ?? ""
            DispatchQueue.main.async {
                self.locationLbl.text = "\(streetName) \(streetNumber) \(country) \(postalCode) "
                
            }
        }
        
    }
}
