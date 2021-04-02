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
//    var movieNames = [String](){
//        didSet{
//            tableView.reloadData()
//        }
//    }
//    var movieTypes = [String]()
//    var movieYears = [String]()
//    var movieImagesURL = [String]()
    var movies = [Movie](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var favMovies = [Movie]()
    
    var selectedMovieName = ""
    var selectedMovieYear = ""
    var selectedMovieType = ""
    var selectedMovieImagesURL = ""
    static var passedEmail = ""
    
    var round : Int = 0
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var addToFavLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var movieCommentTextfield: UITextField!
    
    var userCollectionRef: DocumentReference!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
//        start()
        self.navigationItem.setHidesBackButton(true, animated: true)
        print("Wal: MainViewController")
        questionView.alpha = 0;
        movieCommentTextfield.alpha = 0
        noButton.isHidden = false
//        addToFavLabel.titleLabel!.minimumScaleFactor = 0.5;
//        addToFavLabel.titleLabel!.numberOfLines = 2;
//        addToFavLabel.titleLabel!.textAlignment = .center;
//        addToFavLabel.titleLabel!.adjustsFontSizeToFitWidth = true;
        addToFavLabel.layer.cornerRadius = 10;


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
                            var movieName = ""
                            var movieType = ""
                            var movieYear = ""
                            var movieImageURL = ""
                            self.movies.removeAll()
                            
//                            self.movieImagesURL.removeAll()
                            for movie in json["Search"]{
                                if let title = movie.1["Title"].string{
                                    movieName = title
                                }
                                if let year = movie.1["Year"].string{
                                    movieYear = year
                                }
                                if let type = movie.1["Type"].string{
                                    movieType = type
                                }
                                if let url = movie.1["Poster"].string{
                                    movieImageURL = url
                                }
                                self.movies.append(Movie(movieName: movieName, movieYear: movieYear, movieURL: movieImageURL, movieType: movieType))
                            }
                        }
                    }
            })
    }
    
    @IBAction func yesButtonPressed(_ sender: UIButton) {
        print("WAL: \(round)")
            if round == 1{
        userCollectionRef = Firestore.firestore().collection("Users").document(MainViewController.passedEmail)
        self.userCollectionRef.getDocument(completion: { (snapshot, e) in
        if let error = e{
            debugPrint("Error fetching docs: \(error.localizedDescription)")
        }
        else{
            guard let snap = snapshot else {return}
                var selectedMovie = Movie(movieName: self.selectedMovieName, movieYear: self.selectedMovieYear, movieURL: self.selectedMovieImagesURL, movieType: self.selectedMovieType)
                //retrieve data
            guard var encodedArray : [String] = snap.get("favMovie") as? [String] else {return}
            
            self.userCollectionRef.updateData(["favMovie":self.movieDecode( selectedMovie, encodedArray)]){ e in
                        if let error = e{
                        debugPrint("Wal: Error fetching docs: \(error.localizedDescription)")
                        }
                    }
            }
            
        })
                addToFavLabel.text! = "Add a comment to the feed?"
                round = 2
            }
        else if round == 2{
//                yesButton.setTitle("", for: .normal)
                addToFavLabel.text! = "Please, add your comment above in the box"
                yesButton.setTitle("Done", for: .normal)
                addToFavLabel.alpha = 0
                noButton.alpha = 0
                noButton.isHidden = true
                movieCommentTextfield.alpha = 1
                round = 3
        }
        else if round == 3{
                questionView.alpha = 0;
        }
}
    func start(){
            questionView.alpha = 1
            addToFavLabel.text! = "Add \(selectedMovieName) to my favourites"
            yesButton.setTitle("Yes", for: .normal)
            addToFavLabel.alpha = 1
            noButton.alpha = 1
            noButton.isHidden = false
            movieCommentTextfield.alpha = 0
    }
    func movieDecode(_ selectedMovie:Movie,_ encodedArray:[String]) -> [String]{
        var er=encodedArray
        do {
        let encodedData = try JSONEncoder().encode(selectedMovie)
        if let jsonString = String(data: encodedData, encoding: .utf8){
            er.append(jsonString)
            }
        }
        catch {
            print("Failed to decode JSON")
        }
        return er
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    //return the number of movies
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count
        }
    //show the table
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MainCellTableViewCell? else{return UITableViewCell()}
            cell.nameLabel.text = movies[indexPath.row].movieName
            cell.typeLabel.text = movies[indexPath.row].movieType
            cell.yearLabel.text = movies[indexPath.row].movieYear
            if (movies[indexPath.row].movieURL != "N/A"){
                cell.movieImage.load(url: URL(string: movies[indexPath.row].movieURL)!)
            }
            return cell
        }
//    action when click
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovieName = movies[indexPath.row].movieName
        selectedMovieImagesURL = movies[indexPath.row].movieURL
        selectedMovieYear = movies[indexPath.row].movieYear
        selectedMovieType = movies[indexPath.row].movieType
        addToFavLabel.text = "Add \(selectedMovieName) to my favourites"
        start();
//        movieCommentTextfield.alpha = 1
        round = 1
        
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
