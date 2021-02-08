//
//  MoviesTableViewController.swift
//  Movies
//
//  Created by User on 2/7/21.
//  Copyright © 2021 Syrym Zhursin. All rights reserved.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    var movies: [Movie] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getMovies()
    }
    
    private func configureTableView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Movies"
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieCell")
        
        self.tabBarController?.tabBar.items![0].image = UIImage(systemName: "house")
        self.tabBarController?.tabBar.items![1].image = UIImage(systemName: "star")
        self.tabBarController?.tabBar.items![1].title = "Favourite Movies"
        view.addSubview(self.activityIndicator)

        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -((navigationController?.navigationBar.frame.height)! + (tabBarController?.tabBar.frame.height)!)).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func getMovies() {
        activityIndicator.startAnimating()

        let apiToken = "6c78da2cf41529284dc65d510d302bca"
        guard let url = URL(string: "https://api.themoviedb.org/4/list/1?api_key=\(apiToken)") else {
            promptMessage(message: "Incorrect url")
            print("Incorrect URL")
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [ "cache-control": "no-cache" ]
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (rawData, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.promptMessage(message: error.localizedDescription)
                    self.activityIndicator.stopAnimating()
                }

                print(#function, "error", error.localizedDescription)
                return
            }
            
            guard let data = rawData,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.promptMessage(message: String(describing: rawData))
                    }
                    print(#function, "error", "\(String(describing: rawData))")
                    return
            }
            
            guard let movieJSON = json["results"] as? [[String : Any]] else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.promptMessage(message: "Failed to convert data")
                }
                return
            }

            for movie in movieJSON {
                do {
                    let parsedMovie = try Movie(json: movie)
                    self.movies.append(parsedMovie)
                } catch {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.promptMessage(message: "Failed to parse data")
                    }
                    print(error)
                }
            }
            if(self.movies.isEmpty) {
                DispatchQueue.main.async {
                    self.promptMessage(message: "Empty list of movies")
                    self.activityIndicator.stopAnimating()
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        dataTask.resume()
    }
    
    private func promptMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell
        cell.releaseDateLabel.text = movies[indexPath.row].date
        cell.titleLabel.text = movies[indexPath.row].name
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + self.movies[indexPath.row].posterPath) else {
            self.promptMessage(message: "Incorrect URL")
            return UITableViewCell()
        }
        var task: URLSessionTask? = nil
        
            task = URLSession.shared.dataTask(with: url, completionHandler: { (rawData, response, error) in
                if let error = error {
                    self.promptMessage(message: error.localizedDescription)
                    return
                }
                if rawData != nil {
                    var image: UIImage? = nil
                    if let data = rawData {
                        image = UIImage(data: data)
                    }

                    if image != nil {
                        DispatchQueue.main.async(execute: {
                            let updateCell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell
                            if updateCell != nil {
                                updateCell?.movieImageView.image = image
                            }
                        })
                    }
                    else {
                        DispatchQueue.main.async {
                            self.promptMessage(message: "Failed to get Images")
                        }
                    }
                }
            })
        
        task?.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MovieDetailViewController()
        vc.movieId = movies[indexPath.row].id
        vc.movieTitle = movies[indexPath.row].name
        vc.descriptionText = movies[indexPath.row].overview
        navigationController?.pushViewController(vc, animated: true)
    }

}
