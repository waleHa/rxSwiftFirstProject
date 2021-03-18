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

class ViewController: UIViewController{
    var movies = [String]()
    @IBOutlet weak var movieSearchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
            movieSearchBar.rx.text
            .orEmpty //If empty stop at begining
            .distinctUntilChanged()
                .filter({!$0.isEmpty}) // $0.count != 0 //If empty stop later
                .debounce(0.5, scheduler: MainScheduler.instance) // 0.5 seconds after the first value
                .subscribe(onNext: { (query) in
                    let url = "https://www.omdbapi.com/?apikey="+Key.myKey+"&s=" + query
                    AF.request(url).responseJSON { (response) in
                        if let value = try? response.result.get(){
                            let json = JSON(value)
                            self.movies.removeAll()
                            
                            for movie in json["Search"]{
                                if let title = movie.1["Title"].string{
                                    self.movies.append(title)
                                }
                            }
                        }
                        self.tableView.reloadData();
                    }
            })
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = movies[indexPath.row]
            return cell!
        }
}




