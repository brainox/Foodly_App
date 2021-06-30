//
//  MealsViewModel.swift
//  Foodly
//
//  Created by omokagbo on 08/06/2021.
//

import UIKit

enum MealCategories: String {
    case all = "All"
    case pizza = "pizza"
    case beverages = "Beverages"
    case fish = "Fish"
    case drinks = "Drinks"
    case africana = "Africana"
}

class MealsViewModel {
    
    let meals: [Meals] = [
        Meals(name: MealCategories.all.rawValue,
              image: UIImage.init(imageLiteralResourceName: "ion_fast-food-outline")),
        Meals(name: MealCategories.pizza.rawValue,
              image: UIImage.init(imageLiteralResourceName: "ion_pizza-outline")),
        Meals(name: MealCategories.beverages.rawValue,
              image: UIImage.init(imageLiteralResourceName: "Vector 2")),
        Meals(name: MealCategories.fish.rawValue,
              image: UIImage.init(imageLiteralResourceName: "fe_rice-cracker-1")),
        Meals(name: MealCategories.drinks.rawValue,
              image: UIImage.init(imageLiteralResourceName: "fe_rice-cracker-1")),
        Meals(name: MealCategories.africana.rawValue,
              image: UIImage.init(imageLiteralResourceName: "fe_rice-cracker-1"))
    ]
}
