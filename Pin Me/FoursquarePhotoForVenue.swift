//
//  FoursquarePhotoForVenue.swift
//  Pin Explorer
//
//  Created by Wassim Seifeddine on 5/25/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(FoursquarePhotoForVenue)

class FoursquarePhotoForVenue: NSManagedObject {
    
    //MARK: - NSManagedProperties for the Foursquare Photo for each Venue
    
    @NSManaged var resolvablePhotoUrl: String
    @NSManaged var resolvablePhotoFilePath: String?
    @NSManaged var foursquareVenue: FoursquareVenue
   
    var image: UIImage? {
        
        if let resolvablePhotoFilePath = resolvablePhotoFilePath {
            
            // Check to see if there's an error downloading the photos for each Venue
            if resolvablePhotoFilePath == "error" {
                
                return UIImage(named: "Ooops.jpg")
            }
            
            // Get the filePath
            let fileName = resolvablePhotoFilePath.lastPathComponent
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let pathArray = [dirPath, fileName]
            let fileURL = NSURL.fileURLWithPathComponents(pathArray)!
            
            return UIImage(contentsOfFile: fileURL.path!)
        }
        return nil
    }

    
    //MARK: - Initialisers
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(resolvablePhotoUrl: String, foursquareVenue: FoursquareVenue, context: NSManagedObjectContext) {
        
        // Core Data
        let entity = NSEntityDescription.entityForName("FoursquarePhotoForVenue", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.resolvablePhotoUrl = resolvablePhotoUrl
        self.foursquareVenue = foursquareVenue
    }

    
}