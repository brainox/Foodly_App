//
//  CartViewModel.swift
//  Foodly
//
//  Created by Decagon on 15/06/2021.
//
import UIKit

class CartViewModel {
    var itemNumber = 0
    var image = ""
    var restName = ""
    var cartItems = [CartModel]()
    var titleArray = [String]()
    var amount = [Float]()
    var titleImage = [UIImage]()
    var quantity = [String]()
    var totalAmount = [Float]()
    var name = ""
    var parsedDiscount = ""
    var names = [String]()
    var phones = [String]()
    var images = [String]()
    func items() -> [CartModel] {
        for itemNumber in 0 ..< amount.count {
            cartItems.append(CartModel(itemTitle: titleArray[itemNumber],
                                       itemAmount: Float(String(format: "%.2f",
                                                                amount[itemNumber] * Float(quantity[itemNumber])!))!,
                                       itemImage: titleImage[itemNumber],
                                       itemQuantity: quantity[itemNumber]))
        }
        return cartItems
    }
    init() {
        self.cartItems = items()
    }
}
