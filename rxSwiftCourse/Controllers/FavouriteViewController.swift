//
//  FavouriteViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-23.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase

class FavouriteViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
//    var favouriteMovieNames = [String](){
//        didSet{
//            tableView.reloadData()
//        }
//    }
//    var favouriteMovieYears = [String]()
//    var favouriteMovieTypes = [String]()
//    var favouriteMovieURLs = [String]()
    var favouriteMovie = [Movie](){
        didSet{
            tableView.reloadData()
        }
    }

    var ref: DocumentReference!
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("Wal:Hello")
        
        ref = Firestore.firestore().collection("Users").document(MainViewController.passedEmail)
            self.ref.getDocument(completion: { (snapshot, e) in
            if let error = e{
                debugPrint("Error fetching docs: \(error.localizedDescription)")
            }
            else{

                guard let snap = snapshot else {return}
                
                guard let encodedArray : [String] = snap.get("favMovie") as? [String] else {return}
                

//                self.movieEncode(encodedArray)
                
//                if let xmovies = encodedArray{
                if encodedArray.count > 0{
                    self.setfavourites(movies: self.movieDecode(encodedArray))
                }
        }
            })
    }
    
    func setfavourites( movies:[Movie]){
        for movie in movies{
            favouriteMovie.append(movie)
        }
    }
    
    func movieDecode(_ encodedArray:[String]) -> [Movie]{
        var x = [Movie]()
        for movie in encodedArray{
            if let dataFromJsonString = movie.data(using: .utf8) {
                do {
                    let movieFromData = try JSONDecoder().decode(Movie.self,
                                                            from: dataFromJsonString)
                    x.append(movieFromData)
                }
                catch {
                    print("WAL: Failed to decode JSON")
                }
            }
            }
        return x;
    }
    func movieDecode(_ movies:[Movie]) -> [String]{
        var encodedArray = [String]()
        for movie in movies{
        do {
        let encodedData = try JSONEncoder().encode(movie)
        if let jsonString = String(data: encodedData, encoding: .utf8){
            encodedArray.append(jsonString)
            }
        }
        catch {
            print("Failed to decode JSON")
        }}
        return encodedArray
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovie.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavCellTableViewCell? else{return UITableViewCell()}
        cell.nameLabel.text = favouriteMovie[indexPath.row].movieName
        
        cell.typeLabel.text = favouriteMovie[indexPath.row].movieType
        cell.yearLabel.text = favouriteMovie[indexPath.row].movieYear
        if (favouriteMovie[indexPath.row].movieURL != "N/A"){
            cell.movieImage.load(url: URL(string: favouriteMovie[indexPath.row].movieURL)!)}
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{

            self.favouriteMovie.remove(at: indexPath.row)
           
            self.ref.updateData(["favMovie": movieDecode(favouriteMovie)])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


       }
}

