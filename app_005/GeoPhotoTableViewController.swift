//
//  GeoPhotoTableViewController.swift
//  app_005
//
//  Created by Lalitha Katupitiya on 10/2/17.
//  Copyright © 2017 Outplay FC. All rights reserved.
//

import UIKit

class GeoPhotoTableViewController: UITableViewController {
    
    
    @IBOutlet var geoTableView: UITableView!
    
    
    var fruits = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry",
                  "Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit",
                  "Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango",
                  "Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach",
                  "Pear", "Pineapple", "Raspberry", "Strawberry"]
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in geoTableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ geoTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    override func tableView(_ geoTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = geoTableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = fruits[indexPath.row]
        
        return cell
    }
    
}
