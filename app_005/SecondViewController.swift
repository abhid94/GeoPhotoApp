//
//  SecondViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 4/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let user = PFUser()
        user.username = "Lalitha_6"
        user.password = "hello its m3"
        user.email = "hello@gmail.com"
        // other fields can be set just like with PFObject
        user["phone"] = "696-969-6969"
        user.signUpInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

