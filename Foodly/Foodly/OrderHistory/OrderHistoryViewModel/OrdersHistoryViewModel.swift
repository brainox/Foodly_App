//
//  OrdersHistoryViewModel.swift
//  Foodly
//
//  Created by Decagon on 6/23/21.
//

import UIKit
class OrderHistoryViewModel {
    var pine = [OrderHistoryModel]()
    var notifyCompletion: (() -> Void)?
   
    func get() {
        let getHistory = OrderService()
        getHistory.getFoodHistory {(result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                result?.documents.forEach({ (doc) in
                    self.pine.removeAll()
                    let data = doc.data()
                    if let image = data["image"] as? String, let food = data["food"] as? String,
                       let item = data["items"] as? String, let delivery = data["price"] as? String {
                        DispatchQueue.main.async {
                            let order = OrderHistoryModel(restaurantName: food, totalPrice: delivery,
                                                          restaurantImage: image, itemQuantity: item)
                            self.pine.append(order)
                        }
                    }
                })
                self.notifyCompletion?()
            }
        }
    }
}
