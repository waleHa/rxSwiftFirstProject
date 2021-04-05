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

    var movies = [Movie](){
        didSet{
            tableView.reloadData()
        }
    }
    var posts = [Post]()
    
    var favMovies = [Movie]()
    var favposts = [Post]()
    
    var currentPost = Post()

    var selectedMovieName = ""
    var selectedMovieYear = ""
    var selectedMovieType = ""
    var selectedMovieImagesURL = ""
//    static var passedEmail = ""
    static var passedUser = User(firstName: "", lastName: "", email: "", phoneNumber: "")
    var round : Int = 0
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var addToFavLabel: UILabel!
    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var movieCommentTextfield: UITextField!
    
    var userCollectionRef: DocumentReference!
    var postsDocumentRef : DocumentReference!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Wa7a: \(Utilities.getCurrentDateOnly())")
        print("Wa7a: \(Utilities.getCurrentDate())")

        print("Wa7a: \(Utilities.getCurrentTimeOnly())")
        
        postsDocumentRef = Firestore.firestore().collection("Users").document(MainViewController.passedUser.email).collection("post").document("post")
        userCollectionRef = Firestore.firestore().collection("Users").document(MainViewController.passedUser.email)

        
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        print("Wal: MainViewController")
        questionView.alpha = 0;
        movieCommentTextfield.alpha = 0
        noButton.isHidden = false

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

                addToFavLabel.text! = "Add a comment to the feed?"
                round = 2
            }
        else if round == 2{
                addToFavLabel.text! = "Please, add your comment above in the box"
                yesButton.setTitle("Done", for: .normal)
                addToFavLabel.alpha = 0
                noButton.alpha = 0
                noButton.isHidden = true
                movieCommentTextfield.alpha = 1
                round = 3
        }
        else if round == 3{
                //Case 2: Want to add the post with a comment
                firestoreSetter()
                questionView.alpha = 0;
                movieCommentTextfield.alpha = 0
                currentPost.caption = movieCommentTextfield.text
        }
}
    @IBAction func noButtonPressed(_ sender: UIButton) {
        if round == 2{
            //Case 1: Want to add the post with no comment
            firestoreSetter()
            questionView.alpha = 0;
        }
    
    }
    //MARK:- fuctions
    func firestoreSetter(){
        
        let selectedMovie = Movie(movieName: self.selectedMovieName, movieYear: self.selectedMovieYear, movieURL: self.selectedMovieImagesURL, movieType: self.selectedMovieType)
         self.currentPost.movie = selectedMovie
        self.currentPost.time = Utilities.getCurrentDate()
        self.currentPost.user = MainViewController.passedUser

        //case2
        if self.movieCommentTextfield.text! != ""{
            self.currentPost.caption = self.movieCommentTextfield.text!
        }
        //case1
        else{self.currentPost.caption = ""
        }
        
        //Post
        postsDocumentRef.getDocument(completion: { (snapshot, e) in
        if let error = e{
            debugPrint("Error fetching docs: \(error.localizedDescription)")
        }
        else{
            guard let snap = snapshot else {return}
            
            //retrieve data
            guard let encodedMovieArray : [String] = snap.get("favMovies") as? [String] else {return}
            guard var captions : [String] = snap.get("captions") as? [String] else {return}
            guard var time : [String] = snap.get("time") as? [String] else {return}

            guard var encodedCommentsArray : [String] = snap.get("comments") as? [String] else {return}
            guard var likedBy : [String] = snap.get("likedBy") as? [String] else {return}
            
            guard var postsIDs : [String] = snap.get("postsIDs") as? [String] else {return}
            

            if let c = self.currentPost.caption{
                captions.append(c)
            }
            else{
               captions.append("")
            }            
            time.append(self.currentPost.time!)
            
            likedBy.append("")
            encodedCommentsArray.append("")
            self.currentPost.id = "\(self.currentPost.time!)&\(self.currentPost.user?.email ?? "")"
            postsIDs.append(self.currentPost.id!)
            
            //Update data
            self.postsDocumentRef.updateData(["postsIDs":postsIDs,"likedBy":likedBy,"comments":encodedCommentsArray,"time":time,"captions":captions,"favMovies":self.movieEncodingMerger( selectedMovie, encodedMovieArray)]){ e in
                        if let error = e{
                        debugPrint("Wal: Error fetching docs: \(error.localizedDescription)")
                        }
                    }
            }
        })
//        //User
//        self.userCollectionRef.getDocument(completion: { (snapshot, e) in
//        if let error = e{
//            debugPrint("Error fetching docs: \(error.localizedDescription)")
//        }
//        else{
//            guard let snap = snapshot else {return}
//
//            guard let encodedArray : [String] = snap.get("favMovie") as? [String] else {return}
//
//            //Update data
//            self.userCollectionRef.updateData(["favMovie":self.movieEncodingMerger( selectedMovie, encodedArray)]){ e in
//                        if let error = e{
//                        debugPrint("Wal: Error fetching docs: \(error.localizedDescription)")
//                        }
//                    }
//            }
//
//        })
    }

    func questionViewResetter(){
            questionView.alpha = 1
            addToFavLabel.text! = "Add \(selectedMovieName) to my favourites"
            yesButton.setTitle("Yes", for: .normal)
            addToFavLabel.alpha = 1
            noButton.alpha = 1
            noButton.isHidden = false
            movieCommentTextfield.alpha = 0
            movieCommentTextfield.text = ""
    }
    func movieEncodingMerger(_ selectedMovie:Movie,_ encodedArray:[String]) -> [String]{
        var er=encodedArray
        er.append(Utilities.movieToJson(selectedMovie))
        
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
        questionViewResetter();
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
