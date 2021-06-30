//
//  DetailViewModel.swift
//  Foodly
//
//  Created by Decagon on 10/06/2021.
//

import Foundation

class DetailViewModel {
    var meals = [ItemsDetailModel]()
    var restaurantData: Restaurants!
    var restID: String = ""
    var rests = [String]()
    var restaurantDetail: [ItemsDetailModel] = []
    var foodDetail: [ItemsDetailModel] = []
    func getMealss() {
        let getOrders = MealService()
        rests.append(restID)
        print(restID)
        getOrders.getMeals(restaurantID: restID) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                result?.documents.forEach({ (doc) in
                    let data = doc.data()
                    if let name = data["name"] as? String, let price = data["price"] as? String,
                       let mealType = data["category"] as? String,
                       let image = data["image"] as?
                        String {
                        let newMeals = ItemsDetailModel(foodImage: image, foodName: name,
                                                        foodType: mealType, foodAmount: price)
                        self.meals.append(newMeals)
                    }
                }
            )}
        }
    }
}
