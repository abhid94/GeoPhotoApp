//
//  StartViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 11/3/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import CoreGraphics
import Parse
import Pages


extension UIImageView
{
    func makeBlurImage(targetImageView:UIImageView?)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = targetImageView!.bounds
        //blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        targetImageView?.addSubview(blurEffectView)
    }
}

class StartViewController: UIViewController {
    
    var numberOfUsers = -1 as Int;
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var goToTabsButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundImage.alpha = 0.0
        self.goToTabsButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0.0, options: [], animations: {
            self.backgroundImage.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 2.0) {
            self.goToTabsButton.alpha = 1.0
            self.goToTabsButton.center.y -= 40
        }
        //self.backgroundImage.makeBlurImage(targetImageView: backgroundImage)
    }
    
    @IBAction func goToTabsPressed(_ sender: Any) {
        print("button pressed")
        let username = self.randomString(length: 10)
        let password = "pwd"
        let finalEmail = username+"@fake.com"
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.email = finalEmail
        
        // Sign up the user asynchronously
        newUser.signUpInBackground(block: { (succeed, error) -> Void in
            if ((error) != nil) {
            } else {
                print("sign up successful")
            }
        })
        self.goToTabs()
    }
    
    func goToTabs(){
        print("about to segue")
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueToLoadingScreen", sender: self)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if (PFUser.current() != nil){
            print("User signed up and logged in")
            //self.goToTabs()
        } else {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    

}
