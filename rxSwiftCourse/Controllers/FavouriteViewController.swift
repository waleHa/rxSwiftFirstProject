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
    var favouriteMovieNames = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    var favouriteMovieYears = [String]()
    var favouriteMovieTypes = [String]()
    var favouriteMovieURLs = [String]()
    
    var ref: DocumentReference!
    
    func setfavourites( names:[String],years:[String],types:[String],urls:[String]){
        for year in years{
            favouriteMovieYears.append(year)
        }
        for type in types{
            favouriteMovieTypes.append(type)
        }
        for url in urls{
            favouriteMovieURLs.append(url)
        }
        for name in names{
            favouriteMovieNames.append(name)
        }
     print("Wal: \(favouriteMovieYears)")
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 600

        var favMoviesNames = [""]
        var favMoviesTypes = [""]
        var favMoviesYears = [""]
        var favMoviesImagesURL = [""]
        
        ref = Firestore.firestore().collection("Users").document(MainViewController.passedEmail)
            self.ref.getDocument(completion: { (snapshot, e) in
            if let error = e{
                debugPrint("Error fetching docs: \(error.localizedDescription)")
            }
            else{
                guard let snap = snapshot else {return}
                favMoviesNames = snap.get("favNames") as? [String] ?? [""]
                
                favMoviesTypes = snap.get("favTypes") as? [String] ?? [""]
                
                favMoviesYears = snap.get("favYears") as? [String] ?? [""]
                
                favMoviesImagesURL = snap.get("favURLs") as? [String] ?? [""]
                
                self.setfavourites(names: favMoviesNames,years: favMoviesYears,types: favMoviesTypes,urls: favMoviesImagesURL)
        }
            })
    }

}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovieNames.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavCellTableViewCell? else{return UITableViewCell()}
        cell.nameLabel.text = favouriteMovieNames[indexPath.row]
        cell.typeLabel.text = favouriteMovieTypes[indexPath.row]
        cell.yearLabel.text = favouriteMovieYears[indexPath.row]
        cell.movieImage.load(url: URL(string: favouriteMovieURLs[indexPath.row])!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.favouriteMovieNames.remove(at: indexPath.row)
            self.favouriteMovieTypes.remove(at: indexPath.row)
            self.favouriteMovieYears.remove(at: indexPath.row)
            self.favouriteMovieURLs.remove(at: indexPath.row)
            
            self.ref.updateData(["favNames":favouriteMovieNames,"favTypes":favouriteMovieTypes,"favYears":favouriteMovieYears,"favURLs":favouriteMovieURLs])
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(favouriteMovieNames[indexPath.row])
       }
}

