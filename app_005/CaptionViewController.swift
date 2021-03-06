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
    var suburb = ""
    
    @IBOutlet var captionText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.reviewImage.image = pickedImage
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptionViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    
    func dismissKeyboard() {
        
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var reviewImage: UIImageView!
    

    @IBAction func approvePhoto(_ sender: Any) {
        if(self.captionText.text == ""){
            let alert = UIAlertController(title: "Wait!", message: "Please enter a caption 😛", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if  (pickedImage != nil) {
            
            let imageData = UIImageJPEGRepresentation(pickedImage, 0) // "0" indicates lowest size/quality
            let imageFile = PFFile(name:"imageFile.jpeg", data:imageData!)
            
            let GeoPhoto = PFObject(className:"GeoPhoto")
            GeoPhoto["imageFile"] = imageFile
            
            let location = PFGeoPoint(latitude:(coordinates?.latitude)!,longitude:(coordinates?.longitude)!)
            GeoPhoto["location"] = location
            let requestString = "http://maps.googleapis.com/maps/api/geocode/json?latlng=" + "\(coordinates.latitude)" + "," + "\(coordinates.longitude)"
            //print("REQUEST STRING ", requestString)
            let url = URL(string: requestString)
            URLSession.shared.dataTask(with:url!, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    let results = json["results"] as? [[String: Any]] ?? []
                    let addrinfo = results[0]["address_components"] as? [[String: Any]] ?? []
                    //print(addrinfo)
                    self.suburb = (addrinfo[2]["short_name"] as! String) + ", Australia"// + (addrinfo[5]["long_name"] as! String)
                    //print("RESULTS: ",self.suburb)
                    GeoPhoto["suburb"] = self.suburb
                    GeoPhoto["upVotes"] = 0
                    GeoPhoto["upVoters"] = []
                    GeoPhoto["comments"] = []
                    GeoPhoto["caption"] = self.captionText.text ?? ""
                    //print("CAPTION ",self.captionText.text!)
                    GeoPhoto.saveInBackground(block: { (success, error) -> Void in
                        if error == nil {
                            print("Success")
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: nil)
                        } else {
                            print("Fail")
                        }
                    })
                    print("Should be sent to Parse")
                    
                } catch let error as NSError {
                    print(error)
                }
            }).resume()
        } else {
            print("Something, went wrong")
        }
        DispatchQueue.main.async(){
            self.performSegue(withIdentifier: "unwindToFeed", sender: self)
        }
        
    }
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func saveToGallery(_ sender: Any) {
        let imageRepresentation = UIImageJPEGRepresentation(self.reviewImage.image!, 0)
        let imageData = UIImage(data: imageRepresentation!)
        UIImageWriteToSavedPhotosAlbum(imageData!, nil, nil, nil)
        
        saveButton.setTitleColor(UIColor .green, for: UIControlState.normal)
        saveButton.setTitle("Saved!", for: .normal)
        
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
