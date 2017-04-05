//
//  CommentsViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 5/4/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse
import NVActivityIndicatorView
class CommentsViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    
    var titleString: String!
    var imageFile: PFFile!
    var commentsArray : [String] = []
    
    @IBOutlet weak var sendButton: UIButton!
    @IBAction func commentDone(_ sender: Any) {
        if(self.commentTextField.text == ""){
            return
        }
        let thisComment = self.commentTextField.text
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
                    object.addUniqueObject(thisComment!, forKey: "comments")
                }
                object!.saveInBackground()
            }
        }
        self.commentTextField.text = ""
        self.dismissKeyboard()
        let newComment = thisComment
        self.commentsArray.append(newComment!)
        self.tableView.beginUpdates()
        let numComments = self.commentsArray.count
        let newItemIndexPath = IndexPath(row: numComments-1, section: 0)
        self.tableView.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: newItemIndexPath, at: .bottom, animated: true)
    }
    @IBAction func commentBox(_ sender: Any) {
        if(self.commentTextField.text == ""){
            return
        }
        let thisComment = self.commentTextField.text
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
                    object.addUniqueObject(thisComment!, forKey: "comments")
                }
                object!.saveInBackground()
            }
        }
        self.commentTextField.text = ""
        self.dismissKeyboard()
        let newComment = thisComment
        self.commentsArray.append(newComment!)
        self.tableView.beginUpdates()
        let numComments = self.commentsArray.count
        let newItemIndexPath = IndexPath(row: numComments-1, section: 0)
        self.tableView.insertRows(at: [newItemIndexPath], with: UITableViewRowAnimation.automatic)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: newItemIndexPath, at: .bottom, animated: true)
    }
    @IBOutlet var mainView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentTextField.delegate = self
        //self.textField.delegate = self;
        //self.navigationController..
        
        //let backgroundImg = UIImageView(image: UIImage(imageLiteralResourceName: "w-4248"))
        //self.tableView.backgroundView = backgroundImg
        //self.mainView.backgroundColor =  UIColor(patternImage: UIImage(imageLiteralResourceName: "w-3829"))
        self.tableView.backgroundColor = UIColor.clear
        //backgroundImg.makeBlurImage(targetImageView: backgroundImg)
        
        
        self.title = self.titleString
        print(self.commentsArray.count)
        //self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.sendButton.layer.cornerRadius = 5
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 2))
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

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
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func sendButtonClicked () {
        print("send button pressed")
    }
    
    func swipeRight(recognizer : UISwipeGestureRecognizer) {
        //DispatchQueue.main.async(){
        //self.loadingAnimation()
        self.performSegue(withIdentifier: "unwindToFeed2", sender: self)
        //    self.performSegue(withIdentifier: "segueBackFromComments", sender: self)
        //}
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCellController", for: indexPath) as? CommentCellController
        
        // Configure the cell...
        cell?.commentLabel2.text = self.commentsArray[indexPath.row]
        print("LABELZ")
        print(cell?.commentLabel2.text)
        cell?.commentLabel2.textColor = UIColor.white
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        // cell selected code here
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //self.commentLabel.text = self.commentsArray[0]
        return self.commentsArray.count
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
