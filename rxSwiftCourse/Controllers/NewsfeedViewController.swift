//
//  NewsfeedViewController.swift
//  rxSwiftCourse
//
//  Created by admin on 2021-03-28.
//  Copyright © 2021 Wa7a. All rights reserved.
//

import UIKit

class NewsfeedViewController: UITableViewController {
    var post = [Post]()
            
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.fetchPosts()
    }
    func fetchPosts(){
//        posts = Post.fetch
        tableView.reloadData()
    }
}

extension NewsfeedViewController{

}
