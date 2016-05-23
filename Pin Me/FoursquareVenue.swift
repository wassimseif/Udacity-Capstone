//
//  FoursquareVenue.swift
//  Pin Explorer
//
//  Created by Wassim Seifeddine on 5/25/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation
import CoreData


@objc(FoursquareVenue)

class FoursquareVenue: NSManagedObject {
    
    //MARK: - NSManagedProperties for the Foursquare Venue
    
    @NSManaged var venueName: String
    @NSManaged var venuePhotoUrlString: String
    @NSManaged var photosCount: NSNumber?
    @NSManaged var country: String?
    @NSManaged var pin: Pin
    @NSManaged var photosForVenues: NSMutableOrderedSet
    
    
  
    //MARK: - Initialisers
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(venueName: String, venuePhotoUrlString: String, country: String, pin: Pin, context: NSManagedObjectContext) {
        
        // Core Data
        let entity = NSEntityDescription.entityForName("FoursquareVenue", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.venueName = venueName
        self.venuePhotoUrlString = venuePhotoUrlString
        self.country = country
        self.pin = pin
        self.photosForVenues = NSMutableOrderedSet()
        
    }
    
    
}
