//
//  RestaurantTitleTableViewCell.swift
//  Foodly
//
//  Created by Decagon on 08/06/2021.
//

import UIKit

class RestaurantTitleTableViewCell: UITableViewCell {
    
    static let identifier = "RestaurantTitleTableViewCell"
    
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var foodTypeLabel: UILabel!
    
    static func titleNib() -> UINib {
        return UINib(nibName: RestaurantTitleTableViewCell.identifier, bundle: nil)
    }
    
    public func configureItems(with model: Restaurants) {
        foodImageView.kf.setImage(with: model.restaurantImage.asUrl)
        foodNameLabel.text = model.restaurantName
        foodTypeLabel.text = model.category
    }
    
}
