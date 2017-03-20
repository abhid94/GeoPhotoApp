//
//  CaptionViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 19/3/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse

class CaptionViewController: UIViewController {

    var coordinates : CLLocationCoordinate2D!
    var info : [String : Any]!
    
    @IBOutlet var captionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var reviewImage: UIImageView!

    @IBAction func cancelCaption(_ sender: Any) {
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueAfterCaption", sender: self)
        }
    }

    @IBAction func approvePhoto(_ sender: Any) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            let imageData = UIImageJPEGRepresentation(pickedImage, 0) // "0" indicates lowest size/quality
            let imageFile = PFFile(name:"imageFile.jpeg", data:imageData!)
            
            let imageView = UIImage(data: imageData!)
            self.reviewImage = UIImageView(image: imageView)
            
            
            let GeoPhoto = PFObject(className:"GeoPhoto")
            GeoPhoto["imageFile"] = imageFile
            
            let location = PFGeoPoint(latitude:(coordinates?.latitude)!,longitude:(coordinates?.longitude)!)
            GeoPhoto["location"] = location
            GeoPhoto["upVotes"] = 0
            GeoPhoto["upVoters"] = []
            GeoPhoto["caption"] = captionText.text ?? ""
            print("CAPTION ",captionText.text!)
            GeoPhoto.saveInBackground()
            print("Should be sent to Parse")
        } else {
            print("Something, went wrong")
        }
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "segueAfterCaption", sender: self)
        }
        
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
