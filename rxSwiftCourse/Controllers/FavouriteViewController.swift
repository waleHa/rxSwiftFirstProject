//
//  FavouriteViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-23.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit
import Firebase

struct cellData{
    var opened = Bool()
    var textbox = String()
    var labels = String()
}

class FavouriteViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var tableViewData = [cellData](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var posts = [Post]()
    var ref: DocumentReference!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        ref = Firestore.firestore().collection("Users").document(SignInUpViewController.passedUser.email).collection("post").document("post")
            self.ref.getDocument(completion: { (snapshot, e) in
            if let error = e{
                debugPrint("Error fetching docs: \(error.localizedDescription)")
            }
            else{
                    guard let snap = snapshot else {return}
                    //retrieve data

                guard let posts : [String] = snap.get("posts") as? [String] else {return}
                for p in posts{
                    self.posts.append(Utilities.jsonToPost(p)!)
                }
                   
                self.cellDataSetter(self.posts)
                }
            })
    }
    func cellDataSetter(_ p:[Post]){
        for i in 0..<p.count{
            let myCellData = cellData(opened: false, textbox: p[i].caption!, labels: p[i].time!)
           self.tableViewData.append(myCellData)
       }
        tableView.reloadData()
    }
    
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableViewData.count > 0){
        if (tableViewData[section].opened == true) {
            return 2
            }
        }
            return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableViewData.count > 0){
            let dataIndex = indexPath.row - 1
            if indexPath.row == 0{
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavCellTableViewCell? else{return UITableViewCell()}
               cell.nameLabel.text = posts[indexPath.section].movie?.movieName
               
                cell.typeLabel.text = posts[indexPath.section].movie?.movieType
               cell.yearLabel.text = posts[indexPath.section].movie?.movieYear
               if (posts[indexPath.section].movie!.movieURL != "N/A"){
                cell.movieImage.load(url: URL(string: posts[indexPath.section].movie!.movieURL)!)}
               cell.selectionStyle = .none
                return cell
            }
            else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell2") as! FavCell2TableViewCell? else{return UITableViewCell()}
                cell.label.text = Utilities.postTime(posts[indexPath.section].time!)
//                    posts[indexPath.section].time;
                
                cell.textfield.text = posts[indexPath.section].caption;
                return cell
            }
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavCellTableViewCell? else{return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
        if editingStyle == .delete{
            
            self.posts.remove(at: indexPath.row)
            var encodedPost=[String]()
            for p in self.posts{
                encodedPost.append(Utilities.PostToJson(p))
            }
            //Update data
            self.ref.updateData(["posts":encodedPost])
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableViewData[indexPath.section].opened == true{
            tableViewData[indexPath.section].opened = false
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .automatic)
        }
        else{
            tableViewData[indexPath.section].opened = true
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .automatic)
        }
       }
}
