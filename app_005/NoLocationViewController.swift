//
//  NoLocationViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 18/3/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class NoLocationViewController: UIViewController {

    override func viewDidLoad() {
        sleep(1)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func continueToFeed(_ sender: Any) {
        self.loadingAnimation()
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueToFeed", sender: self)
        }
    }
    func loadingAnimation(){
        let cellWidth = CGFloat(75)
        let cellHeight = CGFloat(75)
        let val = NVActivityIndicatorType.ballClipRotate.rawValue
        let x = (self.view.frame.size.width) - 75
        let y = (self.view.frame.size.height) - 75
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,                                                          type: NVActivityIndicatorType(rawValue: val)!, color: UIColor.black)
        activityIndicatorView.padding = 20
        if val == NVActivityIndicatorType.orbit.rawValue {
            activityIndicatorView.padding = 0
        }
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubview(toFront: activityIndicatorView)
        activityIndicatorView.startAnimating()
    }

    @IBAction func openSettings(_ sender: Any) {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, completionHandler: { (success) in
            print("Settings opened: \(success)") // Prints true
        })
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
