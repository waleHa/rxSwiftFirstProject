//
//  ViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-11.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
import Firebase

class MainViewController: UIViewController{
    var movieNames = [String](){
        didSet{
            tableView.reloadData()
        }
    }
    var movieTypes = [String]()
    var movieYears = [String]()
    var movieImagesURL = [String]()
    
    var favMoviesNames = [String]()
    var favMoviesTypes = [String]()
    var favMoviesYears = [String]()
    var favMoviesImagesURL = [String]()
    
    var selectedMovieName = ""
    var selectedMovieYear = ""
    var selectedMovieType = ""
    var selectedMovieImagesURL = ""
    static var passedEmail = ""
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var addToFavButton: UIButton!
    
    var userCollectionRef: DocumentReference!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        print("Wal: MainViewController")
        addToFavButton.alpha = 0;
        addToFavButton.titleLabel!.minimumScaleFactor = 0.5;
        addToFavButton.titleLabel!.numberOfLines = 2;
        addToFavButton.titleLabel!.textAlignment = .center;
        addToFavButton.titleLabel!.adjustsFontSizeToFitWidth = true;
        Utilities.styleFilledButton(addToFavButton, withCornerSize: 10, color: UIColor.systemTeal)


            movieSearchBar.rx.text
            .orEmpty //If empty stop at begining
            .distinctUntilChanged()
                .filter({!$0.isEmpty}) // $0.count != 0 //If empty stop later
                .debounce(0.5, scheduler: MainScheduler.instance) // 0.5 seconds after the first value
                .subscribe(onNext: { (query) in
                    let url = "https://www.omdbapi.com/?apikey="+Key.myKey+"&s=" + query
                    print(url)
                    AF.request(url).responseJSON { (response) in
                        if let value = try? response.result.get(){
                            let json = JSON(value)
                            self.movieNames.removeAll()
                            self.movieTypes.removeAll()
                            self.movieYears.removeAll()
                            self.movieImagesURL.removeAll()
                            for movie in json["Search"]{
                                if let title = movie.1["Title"].string{
                                    self.movieNames.append(title)
                                }
                                if let year = movie.1["Year"].string{
                                    self.movieYears.append(year)
                                }
                                if let type = movie.1["Type"].string{
                                    self.movieTypes.append(type)
                                }
                                if let url = movie.1["Poster"].string{
                                    self.movieImagesURL.append(url)
                                }
                            }
                        }
                    }
            })
    }
    
    @IBAction func addToFavButtonPressed(_ sender: UIButton) {
        userCollectionRef = Firestore.firestore().collection("Users").document(MainViewController.passedEmail)
        self.userCollectionRef.getDocument(completion: { (snapshot, e) in
        if let error = e{
            debugPrint("Error fetching docs: \(error.localizedDescription)")
        }
        else{
            guard let snap = snapshot else {return}
            self.favMoviesNames = snap.get("favNames") as! [String]
            self.favMoviesTypes = snap.get("favTypes") as! [String]
            self.favMoviesYears = snap.get("favYears") as! [String]
            self.favMoviesImagesURL = snap.get("favURLs") as! [String]
            
            self.favMoviesNames.append(self.selectedMovieName)
            self.favMoviesTypes.append(self.selectedMovieType)
            self.favMoviesYears.append(self.selectedMovieYear)
            self.favMoviesImagesURL.append(self.selectedMovieImagesURL)
            
            self.userCollectionRef.updateData(["favNames":self.favMoviesNames,"favTypes":self.favMoviesTypes,"favYears":self.favMoviesYears,"favURLs":self.favMoviesImagesURL]){ e in
                        if let error = e{
                        debugPrint("Wal: Error fetching docs: \(error.localizedDescription)")
                        }            
                    }
            }
        })
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    //return the number of movies
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movieNames.count
        }
    //show the table
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainCellTableViewCell? else{return UITableViewCell()}
            cell.nameLabel.text = movieNames[indexPath.row]
            cell.typeLabel.text = movieTypes[indexPath.row]
            cell.yearLabel.text = movieYears[indexPath.row]
            cell.movieImage.load(url: URL(string: movieImagesURL[indexPath.row])!)
            return cell
        }
//    action when click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovieName = movieNames[indexPath.row]
        selectedMovieImagesURL = movieImagesURL[indexPath.row]
        selectedMovieYear = movieYears[indexPath.row]
        selectedMovieType = movieTypes[indexPath.row]
        addToFavButton.setTitle("Add \(selectedMovieName) to my favourites", for: .normal)
        addToFavButton.alpha = 1
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
