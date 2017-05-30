
//
//  ObjectsTableViewController.swift
//  app_005
//
//  Created by Abhi Dutta on 16/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ObjectsTableViewController: PFQueryTableViewController, CLLocationManagerDelegate {
    
    @IBOutlet var feedBackground: UIView!
    var locationManager = CLLocationManager()
    var sortMethod = -1
    var radius = 2.0
    var sortMetric = "createdAt"
    var objectToLook = PFObject(className: "GeoPhoto")
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: self.parseClassName!)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.backgroundView = self.feedBackground
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        locationManager.startUpdatingLocation()
        
        let coordinates =  locationManager.location?.coordinate
        var location = PFGeoPoint(latitude: -33.91758748639931, longitude: 151.12030727128)
        if(coordinates?.latitude != nil){
            location = PFGeoPoint(latitude:(coordinates?.latitude)!,longitude:(coordinates?.longitude)!)
        }
        query.whereKey("location", nearGeoPoint: location, withinKilometers: radius)
        
        switch(sortMethod) {
            case 0  :
                query.order(byDescending: sortMetric)
                break;
            case 1  :
                query.order(byAscending: sortMetric)
                break;
            default :
                query.order(byDescending: sortMetric)
        }

        if self.objects!.count == 0 {
            query.cachePolicy = .cacheThenNetwork
        }
        locationManager.stopUpdatingLocation()
        return query
    }
    
    func loadList(_ notification: Notification){
        if let myDict = notification.object as? [String: Any] {
            if let myInt = myDict["radius"] as? Int {
                self.radius = Double(myInt)
            }
            if let myText = myDict["sort"] as? String {
                self.sortMethod = 0
                if(myText == "New") {
                    self.sortMetric = "createdAt"
                } else {
                    self.sortMetric = "upVotes"
                }
            }
        }
        self.loadObjects()
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func refreshList(_ notification: Notification){
        self.sortMetric = "createdAt"
        self.loadObjects()
        self.tableView.setContentOffset(CGPoint.zero, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(loadList(_:)), name: NSNotification.Name(rawValue: "refresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
    }
    
    @IBAction func addUpvote(_ sender: AnyObject) {
        
        let hitPoint = (sender as AnyObject).convert(CGPoint.zero, from: self.tableView)
        let inversePoint = CGPoint.init(x: abs(hitPoint.x), y: abs(hitPoint.y))
        let hitIndex = self.tableView.indexPathForRow(at: inversePoint)
        let geoPhoto = object(at: hitIndex)
        
        let usersHaveUpvotedArray = geoPhoto?["upVoters"] as? NSArray
        let userObjectId = PFUser.current()?.objectId as String! ?? "9999999999"
        let contained = usersHaveUpvotedArray?.contains(userObjectId)
        
        if (contained == true) {
        }
        if (contained == false) {
            geoPhoto?.addUniqueObject(userObjectId, forKey: "upVoters")
            geoPhoto?.incrementKey("upVotes")
            geoPhoto?.saveInBackground()
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addDownvote(_ sender: Any) {
        let hitPoint = (sender as AnyObject).convert(CGPoint.zero, from: self.tableView)
        let inversePoint = CGPoint.init(x: abs(hitPoint.x), y: abs(hitPoint.y))
        let hitIndex = self.tableView.indexPathForRow(at: inversePoint)
        let geoPhoto = object(at: hitIndex)
        
        let usersHaveUpvotedArray = geoPhoto?["upVoters"] as? NSArray
        let userObjectId = PFUser.current()?.objectId as String! ?? "9999999999"
        let contained = usersHaveUpvotedArray?.contains(userObjectId)
        if (contained == true) {
        }
        
        if (contained == false) {
            geoPhoto?.addUniqueObject(userObjectId, forKey: "upVoters")
            geoPhoto?.incrementKey("upVotes", byAmount: -1)
            if(geoPhoto?.object(forKey: "upVotes") as! Int == -5){
                geoPhoto?.deleteEventually()
            }

            geoPhoto?.saveInBackground()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BaseTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let imageFile = object?.object(forKey: "imageFile") as? PFFile
        cell.cellImageView.image = UIImage(named: "placeholder")
        
        let upvoteCount = object?.object(forKey: "upVotes")
        
        let createdAtTime = object?.createdAt
        let elapsed = Date().timeIntervalSince(createdAtTime!)
        let (d,h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(elapsed))
        //print(d,"-",h,"-",m,"-",s)
        
        if(d != 0){
            if(d != 1){
                cell.dateLabel.text = (String(d) + " days ago")
            } else {
                cell.dateLabel.text = ("1 day ago")
            }
        } else if (h != 0){
            if(h != 1){
                cell.dateLabel.text = (String(h) + " hours ago")
            } else {
                cell.dateLabel.text = ("1 hour ago")
            }
        } else if (m != 0){
            if(m != 1){
                cell.dateLabel.text = (String(m) + " mins ago")
            } else {
                cell.dateLabel.text = ("1 min ago")
            }
        } else {
            if(s != 1){
                cell.dateLabel.text = (String(s) + " secs ago")
            } else {
                cell.dateLabel.text = ("1 sec ago")
            }
        }
        
        if((object?.object(forKey: "suburb")) != nil){
            cell.suburbLabel.text = object?.object(forKey: "suburb") as? String
        } else {
            cell.suburbLabel.text = ""
        }
        
        cell.cellImageView.file = imageFile
        
        cell.upvoteCounter.setTitle("\(upvoteCount!)",for: .normal)
        cell.cellImageView.loadInBackground()
        var newString = object?.object(forKey: "caption") as? String
        if(newString != nil) {
            newString = newString!.uppercased()
        }
        cell.captionLabel.text = newString
        //cell.captionLabel.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height*0.6)
        
        return cell
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
        return (seconds / 86400, seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    @IBAction func reportButton(_ sender: Any) {
    
        print("Report button clicked")
        
        let hitPoint = (sender as AnyObject).convert(CGPoint.zero, from: self.tableView)
        let inversePoint = CGPoint.init(x: abs(hitPoint.x), y: abs(hitPoint.y))
        let hitIndex = self.tableView.indexPathForRow(at: inversePoint)
        self.objectToLook = self.object(at: hitIndex)!
        
        let obID = objectToLook.objectId
        print(obID!)
        
        let alert = UIAlertController(title: "Thank you!", message: "Image will be reviewed as soon as possible.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)

        
    }
    
    
    
    @IBAction func goToComments(_ sender: Any) {
        let hitPoint = (sender as AnyObject).convert(CGPoint.zero, from: self.tableView)
        let inversePoint = CGPoint.init(x: abs(hitPoint.x), y: abs(hitPoint.y))
        let hitIndex = self.tableView.indexPathForRow(at: inversePoint)
        self.objectToLook = self.object(at: hitIndex)!
        
        self.objectToLook.fetchInBackground(block: { (success, error) -> Void in
            if error == nil {
                print("Success")
                DispatchQueue.main.async(){
                    print("going through segue")
                    self.performSegue(withIdentifier: "showDetail", sender: self)
                    
                }
            } else {
                print("Fail")
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 > (self.objects?.count)! {
            self.loadNextPage()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            //self.performSegue(withIdentifier: "showDetail", sender: self)
            
        }
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.objects!.count == 0 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "noPost"), object: nil)
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "isPost"), object: nil)
        }
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "showDetail" {
            //let indexPath = self.tableView.indexPathForSelectedRow
            let detailVC = segue.destination as! CommentsViewController
            
            
            let object = self.objectToLook//self.object(at: indexPath)
            
            detailVC.titleString = object.objectId
            print("one")
            print(object.objectId!)
            print("two")
            detailVC.imageFile = object.object(forKey: "imageFile") as? PFFile
            detailVC.commentsArray = (object.object(forKey: "comments") as? [String])!
            
            //self.tableView.deselectRow(at: indexPath!, animated: true)
        }
        
        
    }
    
    /*
     Function modifies the height of the cell
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = tableView.frame.size.height
        let percentage = 0.95
        
        return CGFloat(height) * CGFloat(percentage);
        
    }
    
    //Infinite scrolling
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height)) {
            if !self.isLoading {
                self.loadNextPage()
            }
        }
    }
    
   
    override func viewDidLoad() {
        
        sleep(1)
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.paginationEnabled = true
        self.objectsPerPage = 30
        
        locationManager.delegate = self
        /*if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }*/
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Do any additional setup after loading the view, typically from a nib.
    }

}







