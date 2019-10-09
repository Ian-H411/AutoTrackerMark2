//
//  MapController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/8/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import UIKit
import CoreLocation
class MapController{
    
    static let shared = MapController()
    var results = [PlaceObject]()
    
    private func retrieveGasStationsNearby(location: CLLocationCoordinate2D, radius:Int, completion: @escaping (Places?) -> Void){
        let apikey = "GCRBpvYBFTs9Cm0DHzTZB4GWMG9qYkTkBP99YuMPC_K_g2DaW9N73-8p1fs7P9I3eSrP3T_hDQeLYXa1rf_h-w-5-zISI_Yt4y0wEnb66agE0UOyiSj1I2xC1vWcXXYx"
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search") else {return}
        let gasStations = URLQueryItem(name: "categories", value: "servicestations")
        let lattitude = URLQueryItem(name: "latitude", value:"\(location.latitude)")
        let longitude = URLQueryItem(name: "longitude", value: "\(location.longitude)")
        let radius = URLQueryItem(name: "radius", value: "\(radius)")
        var urlComponent = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponent?.queryItems = [gasStations,lattitude,longitude,radius]
        guard let finalUrl = urlComponent?.url else {return}
        
        print(finalUrl.absoluteString)
        
        var request = URLRequest(url: finalUrl)
        
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        print(request.url?.absoluteString as Any)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {return}
            do{
                let decorder = JSONDecoder()
                let resultsArray = try decorder.decode(Places.self, from: data)
                completion(resultsArray)
                return
            } catch{
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            
        }.resume()
        
    }
    private func retrieveImage(urlString:String, completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: urlString) else {completion(nil);print("error url was nil");return}
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("there was an error in \(#function) :\(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {completion(nil);print("error data was nil");return}
            guard let image = UIImage(data: data) else {completion(nil);print("error data was nil");return}
            completion(image)
        }.resume()
    }
    
    private func returnRatingStarImage(rating:Double) -> UIImage?{
        if rating == 0 {
            return UIImage(named:"0Stars")
        } else if rating == 1.0{
            return UIImage(named:"1Star")
        } else if rating == 1.5{
            return UIImage(named:"1.5Stars")
        } else if rating == 2.0 {
            return UIImage(named:"2Stars")
        } else if rating == 2.5 {
            return UIImage(named:"2.5Stars")
        } else if rating == 3.0{
            return UIImage(named:"3Stars")
        } else if rating == 3.5{
            return UIImage(named:"3.5Stars")
        } else if rating == 4.0{
            return UIImage(named:"4Stars")
        } else if rating == 4.5{
            return UIImage(named:"4.5Stars")
        } else if rating == 5{
            return UIImage(named: "5Stars")
        }  else {
            return nil
        }
    }
    
    
    func grabNearbyGasStationsAndConvert(location: CLLocationCoordinate2D, radius:Int, completion: @escaping (Bool) -> Void){
        //grab the data from yelp
        results.removeAll()
        retrieveGasStationsNearby(location: location, radius: radius) { (placesStrut) in
            guard let placesStrut = placesStrut else{print("unable to parse objects correctly");return}
            //loop through the places
            for place in placesStrut.businesses{
                //grab the rating image
                guard  let ratingImage = self.returnRatingStarImage(rating: place.rating) else {return}
                
                //check if an image for the business exists
                let place = PlaceObject(place: place, imageurl: place.imageURL, ratingImage: ratingImage)
                self.results.append(place)
            }
           completion(true)
            return
        }
    }
}
