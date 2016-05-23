//
//  FoursquareConvenient.swift
//  Pin Explorer
//
//  Created by Wassim Seifeddine on 5/25/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation
import CoreData

extension FoursquareClient {
    
    /* Function to download Venues near-around the dropped pin, using Search method, find more details here: https://developer.foursquare.com/docs/venues/search */
    func downloadVenuesForPin(pin: Pin, completionHandler: (success :Bool, error: NSError?) -> Void) {
        
        // Build the URL and make the GET request for Search method
        let urlRequest = buildRequestForVenueLocation(pin)
        let task = session.dataTaskWithRequest(urlRequest) {
            data, response, downloadError in
        
        // Check to see if there's an error in downloading Venues
        if let error = downloadError {
            completionHandler(success: false, error: error)
        } else {
            // Parse the received JSON response to extract the downloaded Venues
            var parsedResults: AnyObject?
            do {
                parsedResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                    } catch let error as NSError {
                        print("There was an error parsing Venues JSON, its: \(error.localizedDescription)")
                        parsedResults = nil
                    }
            
            // If we recevied some Venues ...
            if let response = parsedResults?.valueForKey(JSONResponseKeys.Response) as? NSDictionary {
                if let venues = response.valueForKey(JSONResponseKeys.Venues) as? NSArray {
                    
                    // Start constructing the Photos URLs
                    for venueDictionary in venues {
                        
                        // Get the Venue location dictonary to get the venue address
                        let location = venueDictionary.valueForKey(JSONResponseKeys.VenueLocation) as? NSDictionary
                        
                        // Get the Venue country of residance
                        let venueCountry = location?.valueForKey(JSONResponseKeys.VenueCountry) as? String
                        
                        // Get the venue name,
                        let venueName = venueDictionary.valueForKey(JSONResponseKeys.VenueName) as? String
                        
                        // Get the venue Id, to construct the photo url
                        let venueId = venueDictionary.valueForKey(JSONResponseKeys.VenueID) as? String
                        
                        // Construct the Photo URL String
                        let photoUrlString = self.buildUrlStringForVenuePhotos(venueId!)
                        
                        // Create a new Venue managed object
                        self.sharedContext.performBlockAndWait {
                        
                        let newVenue = FoursquareVenue(venueName: venueName!, venuePhotoUrlString: photoUrlString, country: venueCountry!, pin: pin, context: self.sharedContext)
                        
                        // Then download the photos associated with the constructed url
                        self.downloadPhotosForVenue(newVenue, completionHandler: {
                            success, error in
                
                            // Save the recevied venues into Core Date
                            dispatch_async(dispatch_get_main_queue(), {
                                CoreDataStackManager.sharedInstance.saveContext()
                                
                                })
                            })
                        }
                    }
                            completionHandler(success: true, error: nil)
                    } else {
                    
                            completionHandler(success: false, error: NSError(domain: "downloadVenues", code: 0, userInfo: nil))
                        }
                }
            }
        }
        // Start the task
        task.resume()
    }
    
    
    // Download the Photos associated with each Venue
    func downloadPhotosForVenue(newVenue: FoursquareVenue, completionHandler: (success :Bool, error: NSError?) -> Void) {
        
        // Construct the photo url request and Make the GET request download associated photos to each venue
        let venuePhotoUrlString = newVenue.venuePhotoUrlString
        let photoUrlRequest = NSURLRequest(URL: NSURL(string: venuePhotoUrlString)!)
        
        let task = session.dataTaskWithRequest(photoUrlRequest) {
            data, response, downloadError in
            
            if let error = downloadError {
                print("There was an error downloading Photos response, its: \(error.localizedDescription)")
                completionHandler(success: false, error: error)
            } else {
                // Parse the received JSON response to extract the downloaded Photos
                var parsedResults: AnyObject?
                do {
                    parsedResults = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                } catch let error as NSError {
                    print("There was an error parsing Photos JSON, its: \(error.localizedDescription)")
                    parsedResults = nil
                }
                
                // If we got some photos, parse the json response
                if let response = parsedResults?.valueForKey(JSONResponseKeysForPhotos.Response) as? NSDictionary {
                    
                    if let photos = response.valueForKey(JSONResponseKeysForPhotos.Photos) as? NSDictionary {
                        
                        if let count = photos.valueForKey(JSONResponseKeysForPhotos.Count) as? Int {
                            
                            if count > 0 {
                                
                                // Save the count to the newVenue object
                                self.sharedContext.performBlockAndWait{
                                newVenue.photosCount = count
                                }
                            if let items = photos.valueForKey(JSONResponseKeysForPhotos.Items) as? NSArray {
                                
                                /* "items" is the Array that contains all associated photos objects with the selected venue, check here:
                                    https://developer.foursquare.com/docs/explore#req=venues/43695300f964a5208c291fe3/photos */
                                for item in items {
                                    // Get the prefix and suffix for each photo url
                                    let prefix = item.valueForKey(JSONResponseKeysForPhotos.Prefix) as! String
                                    let suffix = item.valueForKey(JSONResponseKeysForPhotos.Suffix) as! String
                                    
                                    // Assemble the photo url using the formula described here: https://developer.foursquare.com/docs/responses/photo.html
                                    let resolvablePhotoUrl = self.assembleResolvablePhotoUrl(prefix, suffix: suffix)
                                    
                                    // Construct a new photo managed object
                                    self.sharedContext.performBlockAndWait{
                                    let newPhoto = FoursquarePhotoForVenue(resolvablePhotoUrl: resolvablePhotoUrl, foursquareVenue: newVenue, context: self.sharedContext)
                                    
                                    // Then get the image content of the photo object
                                    self.getTheImageForEachPhoto(newPhoto, completionHandler: {
                                            success, error in
                                        
                                        // Save the recevied image into Core Date
                                        dispatch_async(dispatch_get_main_queue(), {
                                          CoreDataStackManager.sharedInstance.saveContext()
                                        })
                                    })
                                    }
                                }
                                completionHandler(success: true, error: nil)
                            } else {
                                
                                completionHandler(success: false, error: NSError(domain: "downloadPhotosForVenue", code: 0, userInfo: nil))
                                }
                            }
                        }
                    }
                }
            }
        }
        // Start the task
        task.resume()
    }
    
    
    // Get the image of each Photo, to display it into the app
    func getTheImageForEachPhoto(newPhoto: FoursquarePhotoForVenue, completionHandler: (success :Bool, error: NSError?) -> Void) {
     
        let resolvablePhotoUrl = newPhoto.resolvablePhotoUrl
        
        let imageForPhotoUrlRequest = NSURLRequest(URL: NSURL(string: resolvablePhotoUrl)!)
        
        let task = session.dataTaskWithRequest(imageForPhotoUrlRequest) {
            data, response, downloadError in
            
            if let error = downloadError {
                print("There was an error downloading Photo's Image, its: \(error.localizedDescription)")
                completionHandler(success: false, error: error)
                
            } else {
                if let imageForPhoto = data {
                    
                    // Make a fileUrl to it
                    let fileName = resolvablePhotoUrl.lastPathComponent
                    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
                    let pathArray = [dirPath, fileName]
                    let fileURL = NSURL.fileURLWithPathComponents(pathArray)!
                    
                    // And save it...
                    NSFileManager.defaultManager().createFileAtPath(fileURL.path!, contents: imageForPhoto, attributes: nil)
                    
                    // Then update the FoursquarePhotoForVenue managed object with the file path
                    self.sharedContext.performBlockAndWait{
                    newPhoto.resolvablePhotoFilePath = fileURL.path!
                    }
                    completionHandler(success: true, error: nil)
                }
            }
        }
        // Start the task
        task.resume()
    }
    

    
    // MARK: - Core Data Convenience
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance.managedObjectContext!
    }
    
    
}