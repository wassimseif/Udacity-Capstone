//
//  FoursquareClient.swift
//  Pin Explorer
//
//  Created by Wassim Seifeddine on 5/25/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation

class FoursquareClient {
    
    //MARK: - Shared Instance
    
    //Single line shared instance declaration as proved in http://krakendev.io/blog/the-right-way-to-write-a-singleton
    
    static let sharedInstance = FoursquareClient()
    
    //MARK: - Properties
    
    var session: NSURLSession
    
    //MARK: - Initialiser
    
    private init() {
        
        session = NSURLSession.sharedSession()
    }
    
    // MARK: - Helper functions
    
    // Function to build the called URL from its parameters as requested into foursquare docs
    func buildRequestForVenueLocation(pin: Pin) -> NSURLRequest {
        
        return NSURLRequest(URL: NSURL(string: Constants.BaseFoursquareURL + Methods.Search + "?ll=\(pin.coordinate.latitude),\(pin.coordinate.longitude)&client_id=\(Constants.FoursquareClientID)&client_secret=\(Constants.FoursquareClientSecret)&v=\(self.todaysDate())")!)
    }
    

    // Function to get the photos URL, as described in here: https://developer.foursquare.com/docs/explore#req=venues/43695300f964a5208c291fe3/photos
    func buildUrlStringForVenuePhotos(id: String) -> String {
        
        return Constants.BaseFoursquareURL + "venues/\(id)/photos?&client_id=\(Constants.FoursquareClientID)&client_secret=\(Constants.FoursquareClientSecret)&v=\(self.todaysDate())"
    }
    
    
    // Function to assemble a resolvable photo URL using its original photo size, https://developer.foursquare.com/docs/responses/photo.html
    func assembleResolvablePhotoUrl(prefix: String, suffix: String) -> String {
        return prefix + "500x500" + suffix
    }
    
    
    // Function to get today's date formatted as requested to be passed in GET Url for Search method
    func todaysDate() -> NSString {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyMMdd"
        return formatter.stringFromDate(date)
    }
    
}
