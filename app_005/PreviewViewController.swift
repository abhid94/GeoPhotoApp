//
//  PreviewViewController.swift
//  app_005
//
//  Created by Abhi Dutta on 17/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse

class PreviewViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var titleString: String!
    var imageFile: PFFile!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.titleString
        
        self.imageFile.getDataInBackground { (imageData, error) -> Void in
            
            if error == nil
            {
                if let imageData = imageData {
                    let image = UIImage(data: imageData)
                    self.imageView.image = image
                }
            }
        
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
