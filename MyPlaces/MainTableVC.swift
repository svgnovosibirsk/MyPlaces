//
//  MainTableVC.swift
//  MyPlaces
//
//  Created by Sergey Golovin on 26.11.2020.
//  Copyright © 2020 GoldenWindGames LLC. All rights reserved.
//

import UIKit

class MainTableVC: UITableViewController {
    
    let restaurantNames = ["place1", "place2", "place3", "place4", "place5",
                           "place6", "place7", "place8", "place9", "place10"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = restaurantNames[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        
        return cell
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
    }

}
