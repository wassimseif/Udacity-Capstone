# Pin Me 


Pin Me is iOS app that allows a user to explore the world through both flickr and foursquare services, where user selects a place and drops a pin on the initial map view, instantly allows a two background APIs calls to each of; flickr API to get the associated photos with the dropped pin's coordinates using its latitude and longitude as parameters, and to foursquare API to search for the nearest venues to this pin using its coordinates as well, and getting back the JSON response based on the chosen date at first view.

Flickr photos and Foursquare venues are displayed in Collection View/Table View controllers.

Photos and Venues are saved into Core Data using one-to-many relationship, and fetched upon app is launched back.
