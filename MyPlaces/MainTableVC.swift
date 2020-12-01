//
//  MainTableVC.swift
//  MyPlaces
//
//  Created by Sergey Golovin on 26.11.2020.
//  Copyright © 2020 GoldenWindGames LLC. All rights reserved.
//

import UIKit
import RealmSwift

class MainTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingBtn: UIBarButtonItem!
    
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>!
    private var ascendingSorting = true
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        segmentControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        segmentControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        
        places = realm.objects(Place.self)
        
        // Setup search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredPlaces.count
        }
        
        return places.isEmpty ? 0 : places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var place = Place()
        if isFiltering {
            place = filteredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        
        cell.nameLbl.text = place.name
        cell.locationLbl.text = place.location
        cell.typeLbl.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!)

        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true

        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let place = places[indexPath.row]
            StorageManager.deliteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let place = places[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deliteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }*/
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            var place = Place()
            if isFiltering {
                place = filteredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            
            let newPlaceVC = segue.destination as! NewPlaceTableVC
            newPlaceVC.currentPlace = place
        }
      
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard  let newPlaceVC = segue.source as? NewPlaceTableVC else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
    }

    @IBAction func sortSelection(_ sender: UISegmentedControl) {
       sorting()
    }
    
    @IBAction func reversedSorting(_ sender: UIBarButtonItem) {
        ascendingSorting.toggle()
        sorting()
    }
    
    private func sorting() {
        
        if segmentControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
    
}

extension MainTableVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
    
}
