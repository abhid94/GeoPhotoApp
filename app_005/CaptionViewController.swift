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
    var pickedImage : UIImage!
    
    @IBOutlet var captionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.reviewImage.image = pickedImage
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptionViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func approvePhoto(_ sender: Any) {
        
        if  (pickedImage != nil) {
            
            let imageData = UIImageJPEGRepresentation(pickedImage, 0) // "0" indicates lowest size/quality
            let imageFile = PFFile(name:"imageFile.jpeg", data:imageData!)
            
            let GeoPhoto = PFObject(className:"GeoPhoto")
            GeoPhoto["imageFile"] = imageFile
            
            let location = PFGeoPoint(latitude:(coordinates?.latitude)!,longitude:(coordinates?.longitude)!)
            GeoPhoto["location"] = location
            GeoPhoto["upVotes"] = 0
            GeoPhoto["upVoters"] = []
            GeoPhoto["comments"] = []
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
    
    @IBAction func saveToGallery(_ sender: Any) {
        let imageRepresentation = UIImageJPEGRepresentation(self.reviewImage.image!, 0)
        let imageData = UIImage(data: imageRepresentation!)
        UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
        
        
        let alert = UIAlertController(title: "Completed", message: "Image has been saved!", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alert, animated: true, completion: nil)
      //  self.dismiss(animated: true, completion: nil)
        alert.dismiss(animated: true, completion: nil)
        
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
