//
//  Movie.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

struct Movie: Codable{
    var movieName : String
    var movieYear: String
    var movieURL: String
    var movieType: String
 
//    func movieEncode(movies:[Data]?) -> [Movie]{
//        var myMovies = [Movie]()
//        for movie in movies{
//            let jsonString = String(data: movie, encoding: .utf8)
//            if let dataFromJsonString = jsonString?.data(using: .utf8) {
//                do {
//                    let movieFromData = try JSONDecoder().decode(Movie.self,
//                                                            from: dataFromJsonString)
//                    myMovies.append(movieFromData)
//                }
//                catch {
//                    print("Failed to decode JSON")
//                }
//            }
//        }
//        return myMovies;
//    }
    func movieDecode(movies:[Movie]){
        
    }
}
