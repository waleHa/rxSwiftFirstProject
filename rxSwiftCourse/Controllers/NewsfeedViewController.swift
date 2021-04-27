//
//  NewsfeedViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase

class NewsfeedViewController: UIViewController, myTableViewCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var clickedPost:Int?
    var users = [User]()
    var usersCollectionRef: CollectionReference!
    var users2CollectionRef: CollectionReference!
    var currentPost=Post()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        self.usersCollectionRef = Firestore.firestore().collection("Users")

        usersCollectionRef.getDocuments { (snapshot, e) in
        if let error = e{
            debugPrint("Error fetching docs: \(error.localizedDescription)")
            return
        }
        guard let snap = snapshot else {return}
            var users = [User]()
            for document in (snap.documents){
                let data = document.data()
                users.append(User(firstName: data["firstName"] as! String, lastName: data["lastName"] as! String, email: data["email"] as! String, phoneNumber: data["phoneNumber"] as! String, aboutMe: data["aboutMe"] as! String, twitter: data["twitter"] as! String, instagram: data["instagram"] as! String, snapchat: data["snapchat"] as! String, personalImage: data["personalImage"] as! String)
                )
            }
            self.retriveUsers(users)

    }
    }
    func retriveUsers(_ uu:[User]){
        for u in uu{
            self.users.append(u)
            retrivePosts(u.email)
        }
    }
    
    func retrivePosts(_ email:String){
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
            guard let posts : [String] = snap.get("posts") as? [String] else {return}

            var fetchingPosts=[Post]()
            for p in posts{
                if let fpost = Utilities.jsonToPost(p){
                fetchingPosts.append(fpost)
                }
            }
            self.fetchPosts(p: fetchingPosts)
            }
        })
    }
    
    func fetchPosts(p:[Post]){
        for pp in p{
            posts.append(pp)
        }
        tableView.reloadData()
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {

    }
    override func viewDidDisappear(_ animated: Bool) {
        var i = 0
        for mypost in posts{
            if mypost.user?.changed == true{
                posts[i].user?.changed = false
            var postsDocumentRef: DocumentReference!
            postsDocumentRef = Firestore.firestore().collection("Users").document(mypost.user!.email).collection("post").document("post")
                    //Post
                    postsDocumentRef.getDocument(completion: { (snapshot, e) in
                    if let error = e{
                        debugPrint("Error fetching docs: \(error.localizedDescription)")
                    }
                    else{
                        guard let snap = snapshot else {return}
                        //retrieve data
                        guard var fetchingPosts: [String] = snap.get("posts") as? [String] else {return}

                        var decodedPosts=[Post]()
                        for p in fetchingPosts{
                            decodedPosts.append(Utilities.jsonToPost(p)!)
                        }
                        var updatedPosts=[Post]()
                        for decodedPost in decodedPosts{
                            for post in self.posts{
                                if post.id == decodedPost.id{
                                    updatedPosts.append(post)
                                }
                            }
                        }
                        var myencodedPosts=[String]()
                        for post in updatedPosts{
                                myencodedPosts.append(Utilities.PostToJson(post))
                        }
                        //Update data
                        postsDocumentRef.updateData(["posts":myencodedPosts]){ e in
                                       if let error = e{
                                       debugPrint("Wal: Error fetching docs: \(error.localizedDescription)")
                                       }
                                   }
                        }
                    })
        }
            i += 1
        }
    }
}

extension NewsfeedViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return 2;
    }
        //show the table
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (posts.count > 0){
        let dataIndex = indexPath.row - 1
        
        if indexPath.row != 0{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell2") as! PostCell? else{return UITableViewCell()}
        cell.post = posts[indexPath.section]
            cell.configure(with: indexPath.section)
            cell.delegate = self

        cell.selectionStyle = .none
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell1") as! PostHeaderCell? else{return UITableViewCell()}

            if posts.count>0{
            cell.post = posts[indexPath.section]
            cell.backgroundColor = .white
            }
            return cell
            }
            
        }
            return UITableViewCell()
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataIndex = indexPath.row - 1
        
        if indexPath.row != 0{
    return 510
        }
        return 50

        return tableView.contentSize.height;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell2") as! PostCell? else{return}
        
    }
    func didTapButton(with titleIndex: Int) {
//        posts[titleIndex].likedBy?.append(MainViewController.passedUser.email)

        if (posts[titleIndex].didUserLikeMe(SignInUpViewController.passedUser.email)){
            posts[titleIndex].removeMe(SignInUpViewController.passedUser.email)
            posts[titleIndex].user?.changed = true
        }
        else{
            posts[titleIndex].user?.changed = true
            posts[titleIndex].likedBy?.append(SignInUpViewController.passedUser.email)
        }
        tableView.reloadData()

    }
}
