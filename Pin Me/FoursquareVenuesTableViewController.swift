//
//  FoursquareVenuesTableViewController.swift
//  Pin Explorer
//
//  Created by Wassim Seifeddine on 5/25/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//
import UIKit
import CoreData

class FoursquareVenuesTableViewController: UITableViewController  {
    
    //Pin received from MapViewController
    var receivedPin: Pin!
    var refreshControlForTable: UIRefreshControl!
    var activityIndicator : UIActivityIndicatorView!
    
    //MARK: Core Data convenience
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext!
    }
    

    override func viewDidLoad() {
       
    }

    // Reload tableView once view is appeared
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicator.frame = CGRect(origin: view.center, size: CGSize(width: 50, height: 50))
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        self.navigationController?.navigationBar.translucent = false
        
        refreshControlForTable = UIRefreshControl()
        refreshControlForTable?.addTarget(self, action: #selector(FoursquareVenuesTableViewController.refresh), forControlEvents: .AllEvents)
        
        tableView.addSubview(refreshControlForTable!)
        
    }
    
    
    // Function to fetchAllVenues from CoreData, that matches the received Pin
    func fetchAllVenues() -> [FoursquareVenue] {
        
        let error: NSErrorPointer = nil
        let fetchRequest = NSFetchRequest(entityName: "FoursquareVenue")
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.receivedPin)
        fetchRequest.sortDescriptors = []

        let results: [AnyObject]?
        do {
            results = try sharedContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error.memory = error1
            results = nil
        }
        
        if error != nil {
           alertUserWithTitle("Error retreving saved Venues", message: error.debugDescription)
        }
        
        return results as! [FoursquareVenue]
    }

    // Function to fetchAllPhotosImages associated with this Venue
    func fetchAllPhotosForVenue() -> [FoursquarePhotoForVenue] {
        
        let error: NSErrorPointer = nil
        let fetchReauest = NSFetchRequest(entityName: "FoursquarePhotoForVenue")
        let results: [AnyObject]?
        do {
            results = try sharedContext.executeFetchRequest(fetchReauest)
        } catch let error1 as NSError {
            error.memory = error1
            results = nil
        }
        
        if error != nil {
            alertUserWithTitle("Error", message: error.debugDescription)
        }
        
        return results as! [FoursquarePhotoForVenue]
    }

    func refresh(){
        fetchAllVenues()
        fetchAllPhotosForVenue()
        tableView.reloadData()
        refreshControlForTable.endRefreshing()
    }
    
}

extension FoursquareVenuesTableViewController {
    
    // MARK: - TableView methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fetchAllVenues().count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FoursquareVenuesCell", forIndexPath: indexPath)
        
        let venue = fetchAllVenues()[indexPath.row]
        
        let imageForVenue = fetchAllPhotosForVenue()[indexPath.row]
        
        cell.textLabel?.text = venue.venueName
        cell.detailTextLabel?.text = venue.country!
        
        if imageForVenue.image != nil {
            
            let imageViewSize = CGSize(width: 500, height: 500)
            cell.imageView?.sizeThatFits(imageViewSize)
            cell.imageView?.image = imageForVenue.image
        }
        
        
        return cell
        
    }
}