
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

class ObjectsTableViewController: PFQueryTableViewController {
    

    
    override func queryForTable() -> PFQuery<PFObject> {
        
        let query = PFQuery(className: "GeoPhoto")
        query.cachePolicy = .cacheElseNetwork
        query.order(byDescending: "createdAt")
        return query
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, object: PFObject?) -> PFTableViewCell? {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BaseTableViewCell
        
        cell.titleLabel.text = object?.object(forKey: "objectId") as? String
        
        let imageFile = object?.object(forKey: "imageFile") as? PFFile
        
        //cell.cellImageView.image = UIImage(named: "placeholder")      Will need to add a placeholder image to show before images have finished loading from DB
        
        cell.cellImageView.file = imageFile
        cell.cellImageView.loadInBackground()
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row + 1 > (self.objects?.count)! {
            return 44
        }
        
        let height = super.tableView(tableView, heightForRowAt: indexPath)
        
        return height
        
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

}







