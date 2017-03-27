//
//  SecondViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 4/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse


class SecondViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    

    var locationManager = CLLocationManager()
    var coordinatesInfo = CLLocationCoordinate2D()
    var picInfo = [String : Any]()
    
    @IBAction func unwindToFeed(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func openCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.picInfo = info
        locationManager.startUpdatingLocation()
        self.coordinatesInfo =  (locationManager.location?.coordinate)!
        locationManager.stopUpdatingLocation()
        
        print("going to caption")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueToCaption", sender: self)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueToCaption" {
            
            if let toViewController = segue.destination as? CaptionViewController {
                toViewController.info = self.picInfo
                toViewController.coordinates = self.coordinatesInfo
            }
        }
    }

}

