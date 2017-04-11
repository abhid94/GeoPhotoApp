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
        let query = PFQuery(className: "GeoPhoto")
        query.getObjectInBackground(withId: self.titleString) {
            (object, error) -> Void in
            if error != nil {

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
        let query = PFQuery(className: "GeoPhoto")
        query.getObjectInBackground(withId: self.titleString) {
            (object, error) -> Void in
            if error != nil {
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
        
        self.tableView.backgroundColor = UIColor.clear

        self.title = self.titleString

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptionViewController.dismissKeyboard))
        
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
    
    
    
    func swipeRight(recognizer : UISwipeGestureRecognizer) {

        self.performSegue(withIdentifier: "unwindToFeed", sender: self)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCellController", for: indexPath) as? CommentCellController
        
        cell?.commentLabel2.text = self.commentsArray[indexPath.row]
        cell?.commentLabel2.textColor = UIColor.white
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.commentsArray.count
    }


}
