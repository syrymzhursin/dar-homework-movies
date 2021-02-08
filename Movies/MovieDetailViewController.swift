//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by User on 2/7/21.
//  Copyright © 2021 Syrym Zhursin. All rights reserved.
//

import UIKit
import WebKit

class MovieDetailViewController: UIViewController {
        
    var movieId: Int = 0
    var movieTitle: String = ""
    var descriptionText = ""
    var favMovies: [String] = []
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var trailerWebKit: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.backgroundColor = .green
        //label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        setupUI()
        getMovieDetails()
    }
}
extension MovieDetailViewController {
    private func getMovieDetails() {
        activityIndicator.startAnimating()
        descriptionLabel.text = descriptionText
        let apiToken = "6c78da2cf41529284dc65d510d302bca"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(self.movieId)/videos?api_key=\(apiToken)") else {
            return
        }

        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [ "cache-control" : "no-cache"]
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (rawData, response, error) in
            if let error = error {
                print(#function, "error", error.localizedDescription)
                return
            }
            guard let data = rawData, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
                print(#function, "error", "\(String(describing: rawData))")
                return
            }
            guard let trailerJSON = json["results"] as? [[String : Any]], let key = trailerJSON[0]["key"] as? String else {
                return
            }
            
            DispatchQueue.main.async {
                self.playVideo(key)
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }

        }.resume()
    }
    
    private func playVideo(_ key: String) {

        guard let url = URL(string: "https://www.youtube.com/embed/\(key)?playsinline=1?autoplay=1") else {
            print("Incorrect url")
            return
        }

        let request = URLRequest(url: url)
        trailerWebKit.load(request)

    }
    
    private func setupUI() {
        
        favMovies = UserDefaults.standard.stringArray(forKey: "Movie") ?? []

        var button: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(addToFavourites))
        
        if favMovies.contains(movieTitle) {
                button = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(addToFavourites))
        }
        self.navigationItem.rightBarButtonItem = button

       
        title = movieTitle
        let UIElements = [trailerWebKit, descriptionLabel, activityIndicator]
        UIElements.forEach { (element) in
            view.addSubview(element)
        }
        NSLayoutConstraint.activate([
            trailerWebKit.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trailerWebKit.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailerWebKit.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trailerWebKit.heightAnchor.constraint(equalToConstant: 200),
            
            descriptionLabel.topAnchor.constraint(equalTo: trailerWebKit.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            descriptionLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            
            activityIndicator.centerXAnchor.constraint(equalTo: trailerWebKit.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: trailerWebKit.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 30),
            activityIndicator.widthAnchor.constraint(equalToConstant: 30)

        ])
    }
    
    @objc func addToFavourites() {
        if !favMovies.contains(movieTitle) {
            favMovies.append(movieTitle)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            UserDefaults.standard.setValue(favMovies, forKey: "Movie")
        }
        else {
            guard let movie = favMovies.firstIndex(of: movieTitle) else { return }
            favMovies.remove(at: movie)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            UserDefaults.standard.setValue(favMovies, forKey: "Movie")
        }
        print(favMovies)
        
    }
}
