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
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation(pickedImage, 0) // "0" indicates lowest size/quality
            let imageFile = PFFile(name:"imageFile.jpeg", data:imageData!)
            let GeoPhoto = PFObject(className:"GeoPhoto")
            GeoPhoto["imageFile"] = imageFile
            
            locationManager.startUpdatingLocation()
            let coordinates =  locationManager.location?.coordinate
            let location = PFGeoPoint(latitude:(coordinates?.latitude)!,longitude:(coordinates?.longitude)!)
            GeoPhoto["location"] = location
            GeoPhoto["upVotes"] = 0
            locationManager.stopUpdatingLocation()
            
            GeoPhoto.saveInBackground()
            print("Should be sent to Parse")
        } else {
            print("Something, went wrong")
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

}

