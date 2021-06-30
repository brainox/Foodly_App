//
//  LoginViewModel.swift
//  Foodly
//
//  Created by omokagbo on 09/06/2021.
//
import Foundation
import FirebaseAuth

class LoginViewModel {
    
    var realRestaurants =  [String]()
    var getOrder = RestaurantService()
    var restaurant: [Restaurants] = []
    init() {
        let getOrder = RestaurantService()
        getOrder.getRestaurant() { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                result?.documents.forEach({ (doc) in
                    let data = doc.data()
                    if let name = data["name"] as? String, let time = data["cookingTime"] as? String,
                       let mealType = data["type"] as? String,
                       let discount = data["percentOff"] as?
                        String, let image = data["image"] as?
                            String, let restId = doc.documentID as? String {
                        let newrestaurant = Restaurants(restaurantName: name,
                                                        restaurantImage: image, category: mealType,
                                                        timeLabel: time, discountLabel: discount)
                        self.restaurant.append(newrestaurant)
                        self.realRestaurants.append(restId)
                    }
                }
                )}
        }
    }
    
    func loginUser(with email: String, password: String, completion: @escaping ((Bool) -> Void)) {
        let manager = AuthManager()
        manager.validateLogin(with: email, password: password) { success in
            completion(success)
        }
    }
}
