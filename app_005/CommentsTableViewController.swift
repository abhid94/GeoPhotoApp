//
//  CommentsTableViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 27/3/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView

class CommentsTableViewController: UITableViewController, UITextFieldDelegate {

        
    var titleString: String!
    var imageFile: PFFile!
    
    @IBAction func commentBox(_ sender: Any) {
        print("done comment box")
        print(self.titleString)
        let query = PFQuery(className: "GeoPhoto")
        print(self.titleString)
        query.getObjectInBackground(withId: self.titleString) {
            (object, error) -> Void in
            if error != nil {
                print("update comment no good")
            } else {
                if let object = object {
                    if(object["comments"] == nil){
                        object["comments"] = [];
                    }
                    object.addUniqueObject(self.commentTextField.text!, forKey: "comments")
                }
                object!.saveInBackground()
            }
        }
        self.dismissKeyboard()
        self.viewDidLoad()
    }
    
    @IBOutlet weak var commentTextField: UITextField!
    var commentsArray : [String] = []
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        print("in text function here")
        textField.resignFirstResponder()  //if desired
        performAction()
        return true
    }
    
    func performAction() {
        //action events
        print("comment made!")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //self.commentLabel.text = self.commentsArray[0]
        return self.commentsArray.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.textField.delegate = self;
        //self.navigationController..
        let backgroundImg = UIImageView(image: UIImage(imageLiteralResourceName: "w-3829"))
        self.tableView.backgroundView = backgroundImg
        backgroundImg.makeBlurImage(targetImageView: backgroundImg)
        
        self.title = self.titleString
        print(self.commentsArray.count)
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        //print(self.commentsArray[0])
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptionViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeRight))
        recognizer.direction = .right
        self.view .addGestureRecognizer(recognizer)
        self.commentTextField.placeholder = "Comment.."
        self.commentTextField.borderStyle = UITextBorderStyle.roundedRect
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func sendButtonClicked () {
        print("send button pressed")
    }
    
    func swipeRight(recognizer : UISwipeGestureRecognizer) {
        //DispatchQueue.main.async(){
        //self.loadingAnimation()
        self.performSegue(withIdentifier: "unwindToFeed", sender: self)
        //    self.performSegue(withIdentifier: "segueBackFromComments", sender: self)
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCellController", for: indexPath) as? CommentCellController

        // Configure the cell...
        //cell?.commentLabel.text = self.commentsArray[indexPath.row]
        //cell?.commentLabel.textColor = UIColor.white
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.backgroundColor = UIColor.clear
        return cell!
    }

}
