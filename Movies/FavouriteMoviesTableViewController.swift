//
//  FavouriteMoviesTableViewController.swift
//  Movies
//
//  Created by User on 2/7/21.
//  Copyright © 2021 Syrym Zhursin. All rights reserved.
//

import UIKit

class FavouriteMoviesTableViewController: UITableViewController {

    var favMovies: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favMovies = UserDefaults.standard.stringArray(forKey: "Movie") ?? []
        
        tableView.reloadData()
    }
    
    private func setupTable() {
        title = "Favourite Movies"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(FavouritesTableViewCell.self, forCellReuseIdentifier: "FavouritesCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favMovies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCell", for: indexPath) as! FavouritesTableViewCell
        cell.textLabel?.text = favMovies[indexPath.row]
        // Configure the cell...

        return cell
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let movie = favMovies.firstIndex(of: favMovies[indexPath.row]) else { return }
            favMovies.remove(at: movie)
            tableView.beginUpdates()
            UserDefaults.standard.setValue(favMovies, forKey: "Movie")
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MovieDetailViewController()
        //vc.movieId = movies[indexPath.row].id
        vc.movieTitle = favMovies[indexPath.row]
        //vc.descriptionText = movies[indexPath.row].overview
        navigationController?.pushViewController(vc, animated: true)
    }


}
