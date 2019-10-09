//
//  MapController.swift
//  AutoTracker
//
//  Created by Ian Hall on 10/8/19.
//  Copyright © 2019 Ian Hall. All rights reserved.
//

import Foundation
import CoreLocation
class MapController{
    
    static let shared = MapController()
    
    var results = [Place]()
    
    func retrieveGasStationsNearby(location: CLLocationCoordinate2D, radius:Int, completion: @escaping (Places?) -> Void){
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
}
