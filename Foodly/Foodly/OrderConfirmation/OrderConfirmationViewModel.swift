//
//  OrderConfirmationViewModel.swift
//  Foodly
//
//  Created by Decagon on 6/24/21.
//

import Foundation

class OrderConfirmationViewModel {
    var restId = ""
    var phones = ""
    var names = ""
    var images = ""
    var delivery = 0
    var preparationTime = 0
    var deliveryTime = 0
    
    var notifyCompletion: (() -> Void)?
    
    func deliver(restaurantId: String) {
        let getOrder = DeliveryPersonService()
        getOrder.getDeliveryPersonDetails(restaurantID: restaurantId) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let result):
                result?.documents.forEach({ (doc) in
                    let data = doc.data()
                    if let image = data["image"] as? String, let name = data["name"] as? String,
                       let phone = data["phone"] as? String,
                       let delivery = data["delivery"] as? String {
                        DispatchQueue.main.async {
                            self.names.append(name)
                            self.phones.append(phone)
                            self.images.append(image)
                            if let delivery  = Int(delivery) {
                                self.delivery += delivery / 60
                                self.preparationTime += (delivery - 180)
                                self.deliveryTime += delivery
                            }
                        }
                    }
                })
                self.notifyCompletion?()
            }
        }
    }
}
