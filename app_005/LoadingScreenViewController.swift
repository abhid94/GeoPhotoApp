//
//  LoadingScreenViewController.swift
//  app_005
//
//  Created by Nirvan Gelda on 18/3/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

class LoadingScreenViewController: UIViewController, CLLocationManagerDelegate, NVActivityIndicatorViewable{
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.loadingAnimation()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkLocation()
    }
    
    /*
     Loading animation while waiting
     */
    func loadingAnimation(){
        let cellWidth = CGFloat(75)
        let cellHeight = CGFloat(75)
        let val = NVActivityIndicatorType.ballScaleRippleMultiple.rawValue
        let x = (self.view.frame.size.width) - 75
        let y = (self.view.frame.size.height) - 75
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
            type: NVActivityIndicatorType(rawValue: val)!, color: UIColor.white)
        activityIndicatorView.padding = 20
        if val == NVActivityIndicatorType.orbit.rawValue {
            activityIndicatorView.padding = 0
        }
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubview(toFront: activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    /*
     Check if geo-location is enabled. If not prompt user to do so.
     */
    func checkLocation() {
        locationManager.delegate = self
        if(CLLocationManager.authorizationStatus() == .denied){
            self.goToNoLocationScreen()
        }
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
            while(CLLocationManager.authorizationStatus() == .notDetermined){
            }
            self.goToMainScreen()
        } else {
            self.goToMainScreen()
        }
        
    }
    
    func goToNoLocationScreen(){
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueToNoLocation", sender: self)
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
