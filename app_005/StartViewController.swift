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

class StartViewController: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var paging: UIPageControl!
    @IBOutlet weak var goToTabsButton: UIButton!
    
    var imageArray = [UIImage]()
    var numberOfUsers = -1 as Int;
    
    @IBAction func goToTabsPressed(_ sender: Any) {
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
        
        //default.setValue("LoadingViewController", forKey: "LaunchView")
        
        self.goToTabs()
    }
    
    func goToTabs(){
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueToLoadingScreen", sender: self)
        }
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mainScrollView.frame = view.frame
        mainScrollView.showsHorizontalScrollIndicator = false
        imageArray = [#imageLiteral(resourceName: "Splash Screen"),#imageLiteral(resourceName: "Onboarding screen 1"),#imageLiteral(resourceName: "Onboarding screen 2"),#imageLiteral(resourceName: "Onboarding screen 3")]
        configurePageControl()
        
        for i in 0..<imageArray.count{
            
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleToFill
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: self.mainScrollView.frame.width, height: self.mainScrollView.frame.height)
            mainScrollView.contentSize.width = mainScrollView.frame.width * CGFloat(i+1)
            mainScrollView.addSubview(imageView)
            
        }
        paging.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControlEvents.valueChanged)
        self.mainScrollView.isPagingEnabled = true
        print("START VC LOADED")
        
    }
    
    func changePage(sender: AnyObject) -> () {
        self.paging.updateCurrentPageDisplay()
        let x = CGFloat(paging.currentPage) * mainScrollView.frame.size.width
        mainScrollView.setContentOffset(CGPoint(x: x,y :0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        paging.currentPage = Int(pageNumber)
    }
    
    func configurePageControl() {

        self.paging.numberOfPages = imageArray.count
        self.paging.currentPage = 0
        self.paging.tintColor = UIColor.red
        self.paging.pageIndicatorTintColor = UIColor.darkGray
        self.paging.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(paging)
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
