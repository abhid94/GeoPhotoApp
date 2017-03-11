
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
    
    var locationManager = CLLocationManager()
    var sortMethod = -1
    var radius = 2.0
    var sortMetric = "createdAt"
    
    @IBOutlet weak var changeRadiusControl: UISegmentedControl!
    @IBOutlet weak var sortMethodControl: UISegmentedControl!
    
    @IBAction func changeRadiusMethod(_ sender: Any) {
        
        let indexPath = IndexPath(row: 0 , section: 0)
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        
        switch changeRadiusControl.selectedSegmentIndex
        {
        case 0:
            radius = 2.0;
        case 1:
            radius = 20.0;
        default:
            break
        }
        self.loadObjects()
        
       
    }
    @IBAction func changeSortMethod(_ sender: Any) {
        
        
        let indexPath = IndexPath(row: 0 , section: 0)
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        
        switch sortMethodControl.selectedSegmentIndex
        {
        case 0:
            sortMethod = 0;
            sortMetric = "createdAt"
        case 1:
            sortMethod = 0;
            sortMetric = "upVotes"
        default:
            break
        }
        self.loadObjects()
     
    }
    
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: self.parseClassName!)
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
        locationManager.startUpdatingLocation()
        
        let coordinates =  locationManager.location?.coordinate
        let location = PFGeoPoint(latitude:(coordinates?.latitude)!,longitude:(coordinates?.longitude)!)
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
        
        cell.titleLabel.text = object?.object(forKey: "objectId") as? String
        
        let imageFile = object?.object(forKey: "imageFile") as? PFFile
        let upvoteCount = object?.object(forKey: "upVotes")
        
        cell.cellImageView.image = UIImage(named: "placeholder")
        
        cell.cellImageView.file = imageFile
        cell.upvoteCounter.setTitle("\(upvoteCount!)",for: .normal)
        cell.cellImageView.loadInBackground()
        
        return cell
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row + 1 > (self.objects?.count)! {
            self.loadNextPage()
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            self.performSegue(withIdentifier: "showDetail", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow
            let detailVC = segue.destination as! PreviewViewController
            
            let object = self.object(at: indexPath)
            
            detailVC.titleString = object?.object(forKey: "objectId") as? String
            detailVC.imageFile = object?.object(forKey: "imageFile") as? PFFile
            
            self.tableView.deselectRow(at: indexPath!, animated: true)
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row + 1 > (self.objects?.count)! {
            return 0    //to get rid of the load more cell 
        }
        
        let height = super.tableView(tableView, heightForRowAt: indexPath)
        
        return height
        
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
        super.viewDidLoad()
        
        self.paginationEnabled = true
        self.objectsPerPage = 10
        
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Do any additional setup after loading the view, typically from a nib.
    }

}







