//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by User on 2/7/21.
//  Copyright © 2021 Syrym Zhursin. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        //label.backgroundColor = .red
        label.numberOfLines = 0
        //label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension MovieTableViewCell {
    private func setupUI() {
        self.selectionStyle = .none
        let UIElements = [movieImageView, titleLabel, releaseDateLabel]
        UIElements.forEach { (element) in
            self.addSubview(element)
        }
        NSLayoutConstraint.activate([
            movieImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 150),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: movieImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            releaseDateLabel.heightAnchor.constraint(equalToConstant: 20),
            releaseDateLabel.widthAnchor.constraint(equalToConstant: 120)
            
        ])
    }
}
