//
//  LoadingScreenViewController.swift
//  app_005
//
//  Created by Nirvan Gelda on 18/3/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse


class LoadingScreenViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.checkLocation()
        //self.goToMainScreen()
        print(1);
        
        // Do any additional setup after loading the view.
    }
    
    /*
     Check if geo-location is enabled. If not prompt user to do so.
     */
    func checkLocation() {
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
            self.goToMainScreen()
        } else {
            self.goToMainScreen()
        }
        
    }
    
    func goToMainScreen(){
        
        
    
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueToMainScreen", sender: self)
        }
        print("TEST")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
