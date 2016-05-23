//
//  FlickrPhoto.swift
//  Pin Me
//
//  Created by Wassim Seifeddine on 5/25/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(FlickrPhoto)

class FlickrPhoto: NSManagedObject {
    
    //MARK: - Properties
    
    @NSManaged var flikcrPhotoURL: String
    @NSManaged var flickrPhotoFilePath: String?
    @NSManaged var pin: Pin
    
    var image: UIImage? {
        
        if let flickrPhotoFilePath = flickrPhotoFilePath {
            
            // Check to see if there's an error downloading the photos for each Pin
            if flickrPhotoFilePath == "error" {
                
                return UIImage(named: "Ooops.jpg")
            }
            
            // Get the filePath
            let fileName = flickrPhotoFilePath.lastPathComponent
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
    
    init(flikcrPhotoURLString: String, pin: Pin, context: NSManagedObjectContext) {
        
        //Core Data
        let entity = NSEntityDescription.entityForName("FlickrPhoto", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.flikcrPhotoURL = flikcrPhotoURLString
        self.pin = pin
    }
    
    //MARK: - Overrides
    
    override func prepareForDeletion() {
        
        //Delete the associated image file when the flickrPhoto managed object is deleted
        if let fileName = flickrPhotoFilePath?.lastPathComponent {
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
            let pathArray = [dirPath, fileName]
            let fileURL = NSURL.fileURLWithPathComponents(pathArray)!
            
            do {
                try NSFileManager.defaultManager().removeItemAtURL(fileURL)
            } catch _ {
            }
        }
    }
    
}

/* Added extension for String struct to get the lastPathComponent as a workaround for non-existance in Swift 2.0
Reference are here: https://forums.developer.apple.com/thread/13580 */

extension String {
    
    var lastPathComponent: String {
        
        get {
            return (self as NSString).lastPathComponent
        }
    }
}
