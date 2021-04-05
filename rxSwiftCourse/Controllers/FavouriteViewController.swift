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

    var favouriteMovie = [Movie](){
        didSet{
            tableView.reloadData()
        }
    }


    var tableViewData = [cellData]()
    
    
    var captions = [String]()
    var times = [String]()
    var CommentsArray = [String]()
    var likedBy = [String]()
    var postsIDs = [String]()
    
    var ref: DocumentReference!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        print("Wal:Hello")
        
        ref = Firestore.firestore().collection("Users").document(MainViewController.passedUser.email).collection("post").document("post")
            self.ref.getDocument(completion: { (snapshot, e) in
            if let error = e{
                debugPrint("Error fetching docs: \(error.localizedDescription)")
            }
            else{
                    guard let snap = snapshot else {return}
                    //retrieve data
                    guard let encodedMovieArray : [String] = snap.get("favMovies") as? [String] else {return}
                    guard let captions : [String] = snap.get("captions") as? [String] else {return}
                    guard let times : [String] = snap.get("time") as? [String] else {return}
                    
                    guard let encodedCommentsArray : [String] = snap.get("comments") as? [String] else {return}
                    guard let likedBy : [String] = snap.get("likedBy") as? [String] else {return}
                    guard let postsIDs : [String] = snap.get("postsIDs") as? [String] else {return}
                        
                self.CommentsArray = encodedCommentsArray
                self.likedBy = likedBy
                self.postsIDs = postsIDs
                self.times = times
                self.captions = captions
                    
                if encodedMovieArray.count > 0{
                    self.getfavourites(movies: self.movieDecoder(encodedMovieArray))
                }
                   
                self.cellDataSetter(encodedMovieArray.count,captions,times)
                }
                print("Wal:Hello2")

            })
        
    }
    func cellDataSetter(_ number:Int,_ c:[String],_ t:[String]){
        for i in 0..<number{
            print(i)
           let myCellData = cellData(opened: false, textbox: c[i], labels: t[i])
           self.tableViewData.append(myCellData)
       }
        tableView.reloadData()
    }
    
    func getfavourites( movies:[Movie]){
        for movie in movies{
            favouriteMovie.append(movie)
        }
    }

    func movieDecoder(_ encodedArray:[String]) -> [Movie]{
        var x = [Movie]()
        for movie in encodedArray{
            x.append(Utilities.jsonToMovie(movie)!)
            }
        return x;
    }
    func movieEncoder(_ movies:[Movie]) -> [String]{
        var encodedArray = [String]()
        for movie in movies{
            encodedArray.append(Utilities.movieToJson(movie))
        }
        return encodedArray
    }
}

extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return favouriteMovie.count
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
        print("Wal: \(indexPath.row)")
        if (tableViewData.count > 0){
            let dataIndex = indexPath.row - 1
            if indexPath.row == 0{
               guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavCellTableViewCell? else{return UITableViewCell()}
               cell.nameLabel.text = favouriteMovie[indexPath.section].movieName
               
               cell.typeLabel.text = favouriteMovie[indexPath.section].movieType
               cell.yearLabel.text = favouriteMovie[indexPath.section].movieYear
               if (favouriteMovie[indexPath.section].movieURL != "N/A"){
                   cell.movieImage.load(url: URL(string: favouriteMovie[indexPath.section].movieURL)!)}
               cell.selectionStyle = .none
                return cell
            }
            else{
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell2") as! FavCell2TableViewCell? else{return UITableViewCell()}
                cell.label.text = times[indexPath.section];
                cell.textfield.text = captions[indexPath.section];
                return cell
            }
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavCellTableViewCell? else{return UITableViewCell()}
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
        if editingStyle == .delete{
            
            self.favouriteMovie.remove(at: indexPath.row)
            self.captions.remove(at: indexPath.row)
            self.times.remove(at: indexPath.row)
            postsIDs.remove(at: indexPath.row)
            likedBy.remove(at: indexPath.row)
            CommentsArray.remove(at: indexPath.row)
            
            //Update data
            self.ref.updateData(["postsIDs":self.postsIDs,"likedBy":self.likedBy,"comments":self.CommentsArray,"time":self.times,"captions":self.captions,"favMovies":movieEncoder(self.favouriteMovie)])
            
//            self.ref.updateData(["favMovie": movieEncoder(favouriteMovie)])
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
