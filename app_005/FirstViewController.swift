//
//  FirstViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 4/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
//import IGListKit
import IGListKit
import Parse

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView1: UIImageView!
    
    @IBAction func loadButton(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView1.contentMode = .scaleAspectFit
            imageView1.image = pickedImage
            
            let imageData = UIImagePNGRepresentation(pickedImage)
            let imageFile = PFFile(name:"imageFile.png", data:imageData!)
            
            let GeoPhoto = PFObject(className:"GeoPhoto")
            GeoPhoto["imageFile"] = imageFile
            GeoPhoto.saveInBackground()
        } else {
            print("something, went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


