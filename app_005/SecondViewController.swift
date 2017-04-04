//
//  SecondViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 4/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse
import Popover

var whichPopover: Int = -1

class SecondViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
    fileprivate var text1 = [2, 10, 100]
    fileprivate var text2 = ["New", "Popular"]
    
    
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.up),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6)),
    ]


    var myDict = ["radius": 2, "sort": "new"] as [String : Any]
    
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
    
    @IBAction func tappedDistanceButton(_ sender: UIButton) {
        whichPopover = 0
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 100, height: 135))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.separatorColor = UIColor.clear
        
        
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, fromView: self.distanceButton)
        self.popover.popoverColor = UIColor.darkGray
    }
    
    @IBAction func tappedSortButton(_ sender: UIButton) {
        whichPopover = 1
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 120, height: 90))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        tableView.separatorColor = UIColor.clear
        
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, fromView: self.sortButton)
        self.popover.popoverColor = UIColor.darkGray
    }
    

}

extension SecondViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(whichPopover == 0) {
            self.myDict["radius"] = text1[indexPath.row]
            //print(self.myDict["radius"]!)
             NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: myDict)
        } else {
            self.myDict["sort"] = text2[indexPath.row]
            //print(self.myDict["sort"]!)
             NotificationCenter.default.post(name: Notification.Name(rawValue: "refresh"), object: myDict)
        }
        
        self.popover.dismiss()
    }
}

extension SecondViewController: UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if(whichPopover == 0) {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(whichPopover == 0) {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = String(self.text1[(indexPath as NSIndexPath).row]) + "km"
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor =  UIColor.darkGray
            cell.textLabel?.textAlignment = .center
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = self.text2[(indexPath as NSIndexPath).row]
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor =  UIColor.darkGray
            cell.textLabel?.textAlignment = .center
            return cell
        }
        
        
    }
}




