//
//  NewsfeedViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase

class NewsfeedViewController: UITableViewController {
    var post = [Post]()
    var users = [User]()
    var usersCollectionRef: CollectionReference!
    var currentPost=Post()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let s:String = "https://m.media-amazon.com/images/M/MV5BYmYxNzk2ZmMtNTEzMi00N2M3LWIxMTktNTc2ZGMyYmM2NjQ4XkEyXkFqcGdeQXVyMTkxNjUyNQ@@._V1_SX300.jpg"
        let m = Movie(movieName: "Hala", movieYear: "2019", movieURL: s, movieType: "Movie")
        let p = Post(time: "2021-04-04&04:32:45", caption: "", likedBy: [""], comments: [""], user: MainViewController.passedUser, movie: m, id: "2021-04-04&04:32:45&\(MainViewController.passedUser.email)")
        post.append(p)
        post.append(p)
        post.append(p)
        // Do any additional setup after loading the view.
        self.fetchPosts()
        self.usersCollectionRef = Firestore.firestore().collection("Users")
        
        usersCollectionRef.getDocuments { (snapshot, e) in
        if let error = e{
            debugPrint("Error fetching docs: \(error.localizedDescription)")
            return
        }
        guard let snap = snapshot else {return}

            for document in (snap.documents){
                let data = document.data()
                var users = [User]()
                users.append(User(firstName: data["firstName"] as! String, lastName: data["lastName"] as! String, email: data["Email"] as! String, phoneNumber: data["phoneNumber"] as! String))
                self.retriveUsers(users)
            }
    }
    }
    
    func retrivePosts(email:String){
        var postsDocumentRef: DocumentReference!
        postsDocumentRef = Firestore.firestore().collection("Users").document(email).collection("post").document("post")
        //Post
        postsDocumentRef.getDocument(completion: { (snapshot, e) in
        if let error = e{
            debugPrint("Error fetching docs: \(error.localizedDescription)")
        }
        else{
            guard let snap = snapshot else {return}
            
            //retrieve data
            guard let encodedMovieArray : [String] = snap.get("favMovies") as? [String] else {return}
            guard var encodedCommentsArray : [String] = snap.get("comments") as? [String] else {return}

            guard var captions : [String] = snap.get("captions") as? [String] else {return}
            guard var time : [String] = snap.get("time") as? [String] else {return}
            guard var likedBy : [String] = snap.get("likedBy") as? [String] else {return}
            guard var postsIDs : [String] = snap.get("postsIDs") as? [String] else {return}
            
            for i in 0..<encodedMovieArray.count{
                let p = Post(time: time[i], caption: captions[i], likedBy: Utilities.jsonToStringArray(likedBy[i]), comments: Utilities.jsonToStringArray(encodedCommentsArray[i]), user: self.users[i], movie: Utilities.jsonToMovie(encodedMovieArray[i]), id: postsIDs[i])
            }
            

            }
        })
    }
    
//    if let c = self.currentPost.caption{
//        captions.append(c)
//    }
//    else{
//       captions.append("")
//    }
//    time.append(self.currentPost.time!)
//    likedBy.append("")
//    encodedCommentsArray.append("")
//    self.currentPost.id = "\(self.currentPost.time!)&\(self.currentPost.user?.email ?? "")"
//    postsIDs.append(self.currentPost.id!)
    
    //            //Update data
    //            postsDocumentRef.updateData(["postsIDs":postsIDs,"likedBy":likedBy,"comments":encodedCommentsArray,"time":time,"captions":captions,"favMovies":self.movieEncodingMerger( selectedMovie, encodedMovieArray)]){ e in
    //                        if let error = e{
    //                        debugPrint("Wal: Error fetching docs: \(error.localizedDescription)")
    //                        }
    //                    }
    
    func retriveUsers(_ uu:[User]){
        for u in uu{
            self.users.append(u)
        }
    }
    func fetchPosts(){
//        posts = Post.fetch
        tableView.reloadData()
    }
}

extension NewsfeedViewController{
    //return the number of movies
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return post.count
            }
        //show the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell2") as! PostCell? else{return UITableViewCell()}
        cell.post = post[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell1") as! PostHeaderCell? else{return UITableViewCell()}
        cell.post = post[section]
        cell.backgroundColor = .white
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        guard let cell = tableView.cellForRow(at: indexPath) else { return 0 }
//        return cell.intrinsicContentSize.height
//    }
    
    //    action when click
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//            selectedMovieName = movies[indexPath.row].movieName
//            selectedMovieImagesURL = movies[indexPath.row].movieURL
//            selectedMovieYear = movies[indexPath.row].movieYear
//            selectedMovieType = movies[indexPath.row].movieType
//            addToFavLabel.text = "Add \(selectedMovieName) to my favourites"
//            questionViewResetter();
//            round = 1
//
//        }
}
