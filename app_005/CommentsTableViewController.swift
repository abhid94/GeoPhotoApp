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
        //@IBOutlet weak var imageView: UIImageView!
        /*
         if(sender.direction == UISwipeGestureRecognizerDirection.right ||
         sender.direction == UISwipeGestureRecognizerDirection.left){
         print("detecting swipe")
         DispatchQueue.main.async(){
         self.performSegue(withIdentifier: "segueBackToFeed", sender: self)
         }
         }
         }*/
        
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
        // MARK: - Table view data source
    func loadingAnimation(){
        let cellWidth = CGFloat(75)
        let cellHeight = CGFloat(75)
        let val = NVActivityIndicatorType.ballScaleRippleMultiple.rawValue
        let x = (self.view.frame.size.width) - 75
        let y = (self.view.frame.size.height) - 75
        let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,                                                          type: NVActivityIndicatorType(rawValue: val)!, color: UIColor.black)
        activityIndicatorView.padding = 20
        if val == NVActivityIndicatorType.orbit.rawValue {
            activityIndicatorView.padding = 0
        }
        self.view.addSubview(activityIndicatorView)
        self.view.bringSubview(toFront: activityIndicatorView)
        activityIndicatorView.startAnimating()
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
        /*@IBAction func backToFeed(_ sender: Any) {
         DispatchQueue.main.async(){
         self.performSegue(withIdentifier: "segueBackToFeed", sender: self)
         }
         }*/
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //self.textField.delegate = self;
            //self.navigationController..
            self.title = self.titleString
            print(self.commentsArray.count)
            //print(self.commentsArray[0])
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CaptionViewController.dismissKeyboard))
            
            //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
            //tap.cancelsTouchesInView = false
            
            view.addGestureRecognizer(tap)
            /*self.imageFile.getDataInBackground { (imageData, error) -> Void in
             
             if error == nil
             {
             if let imageData = imageData {
             let image = UIImage(data: imageData)
             //self.imageView.image = image
             }
             }
             
             }*/
            let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
            recognizer.direction = .left
            self.view .addGestureRecognizer(recognizer)
            self.commentTextField.placeholder = "Comment.."
            self.commentTextField.borderStyle = UITextBorderStyle.roundedRect
            /*let commentTextField = UITextField(frame: CGRect(x: (self.view.frame.size.width/2), y: (self.view.frame.size.height/2), width: 300, height: 40))
            commentTextField.placeholder = "Comment.."
            //commentTextField.font = UIFont.systemFont(ofSize: 15)
            //commentTextField.borderStyle = UITextBorderStyle.roundedRect
            //commentTextField.autocorrectionType = UITextAutocorrectionType.no
            //commentTextField.keyboardType = UIKeyboardType.default
            commentTextField.returnKeyType = UIReturnKeyType.done
            commentTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
            //commentTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            self.navigationController?.view.addSubview(commentTextField)
            self.navigationController?.view.bringSubview(toFront: commentTextField)*/
            /*let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
            swipeDown.direction = UISwipeGestureRecognizerDirection.left
            self.view.addGestureRecognizer(swipeDown)*/
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   /* override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        /*let footer = UIView(frame: CGRect(x: 100, y: 100, width: 320, height: 44))
        footer.backgroundColor = UIColor.lightGray
        
        let textField = UITextField(frame: CGRect(x : 100,y:  100,width : 200,height : 35))
        //textField.borderStyle = UITextBorderStyle.bezel
        
        let yourSendButton = UIButton(frame: CGRect(x : 318,y:  5,width : 62,height : 35))//CGRectMake(318,5,62,35))
        // [[UIButton alloc] initWithFrame:CGRectMake(225,5,75,35)];
        yourSendButton.backgroundColor = UIColor.lightGray
        yourSendButton.setTitle("Send", for: .normal)
        yourSendButton.setTitleColor(UIColor.darkGray, for: .normal)
        yourSendButton.addTarget(self, action: #selector(self.sendButtonClicked), for: UIControlEvents.touchUpInside)
        //addTarget:self action:@selector(sendBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        footer.addSubview(yourSendButton)
        footer.addSubview(textField)*/
        
        self.navigationController?.view.addSubview(footer)
        
        return footer

    }*/

    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func sendButtonClicked () {
        print("send button pressed")
        //print(textField?.text)
    }
        func swipeLeft(recognizer : UISwipeGestureRecognizer) {
            //DispatchQueue.main.async(){
            self.loadingAnimation()
                self.performSegue(withIdentifier: "segueBackFromComments", sender: self)
            //}
        }
        /*
        func respondToSwipeGesture(gesture: UIGestureRecognizer) {
            
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                    print("Swiped right")
                    DispatchQueue.main.async(){
                        self.performSegue(withIdentifier: "segueBackFromComments", sender: self)
                    }
                case UISwipeGestureRecognizerDirection.left:
                    print("Swiped left")
                    DispatchQueue.main.async(){
                        self.performSegue(withIdentifier: "segueBackFromComments", sender: self)
                    }
                default:
                    break
                }
            }
        }
        */
        /*func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return self.imageView
         
         }*/
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCellController", for: indexPath) as? CommentCellController

        // Configure the cell...
        cell?.commentLabel.text = self.commentsArray[indexPath.row]
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
