//
//  LikedListTableViewController.swift
//  swipeApp
//
//  Created by 大嶺舜 on 2019/08/04.
//  Copyright © 2019 大嶺舜. All rights reserved.
//

import UIKit

class LikedListTableViewController: UITableViewController {
    var likedName = [String]()
    @IBOutlet var userTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.likedName[indexPath.row]
        return cell
    }

}
