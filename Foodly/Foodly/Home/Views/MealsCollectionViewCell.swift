//
//  MealsCollectionViewCell.swift
//  Foodly
//
//  Created by omokagbo on 07/06/2021.
//

import UIKit

class MealsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MealsCollectionViewCell"
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealLabel: UILabel!
    
    func setup(with meal: Meals) {
        mealImageView.image = meal.image
        mealLabel.text = meal.name
    }
}
