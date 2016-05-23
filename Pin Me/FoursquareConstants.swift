//
//  FoursquareConstants.swift
//  Pin Explorer
//
//  Created by Wassim Seifeddine on 5/25/16.
//  Copyright (c) 2016 Wassim Seifeddine. All rights reserved.
//

import Foundation

extension FoursquareClient {
    
    // MARK: - Constants
    
    struct Constants {
        
        static let FoursquareClientID  = "BCRH14BH5Q5WI5F3G3G4IQV52CRUM33HLTPEONQHLTECH3KO"
        static let FoursquareClientSecret = "ELA2TBX4NSXHIDR54YN0QTI2JTACCF33U4ECMJUREQF3CDJU"
        static let BaseFoursquareURL = "https://api.foursquare.com/v2/"
    }

    
    // MARK: - JSON Response Keys
    
    struct JSONResponseKeys {
        
        static let Response = "response"
        static let Venues = "venues"
        static let VenueID = "id"
        static let VenueName = "name"
        static let VenueLocation = "location"
        static let VenueCountry = "country"
        static let PostalCode = "postalCode"
        static let CorssStreet = "crossStreet"
        
    }
    
    
    struct JSONResponseKeysForPhotos {
        
        static let Response = "response"
        static let Photos = "photos"
        static let Count = "count"
        static let Items = "items"
        static let Prefix = "prefix"
        static let Suffix = "suffix"
    }
    
    
    // MARK: - Methods
    
    struct Methods {
        
        static let Search = "venues/search"
        static let Explore = "venues/explore"
    }
    
    
}