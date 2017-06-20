//
//  EULAViewController.swift
//  app_005
//
//  Created by Abhi Dutta on 20/6/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse

class EULAViewController: UIViewController {

    
    
    @IBAction func acceptButton(_ sender: Any) {
        
        let username = self.randomString(length: 10)
        let password = "pwd"
        let finalEmail = username+"@fake.com"
        let newUser = PFUser()
        
        newUser.username = username
        newUser.password = password
        newUser.email = finalEmail
        
        newUser.signUpInBackground(block: { (succeed, error) -> Void in
            if ((error) != nil) {
            } else {
                print("sign up successful")
            }
        })
        
         DispatchQueue.main.async(){
             self.performSegue(withIdentifier: "segueToLoadingScreen", sender: self)
        }
        
    }
    
    
    @IBAction func declineButton(_ sender: Any) {
        exit(0)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
