//
//  CartTableViewCell.swift
//  Foodly
//
//  Created by Decagon on 15/06/2021.
//

import UIKit

protocol CartTableViewCellDelegate: AnyObject {
    func addBtnTapped(sender: CartTableViewCell, on plus: Bool)
    func minusBtnTapped(sender: CartTableViewCell, on plus: Bool)
}

class CartTableViewCell: UITableViewCell {
    
    var tableViewModel = CartViewModel()
    private let viewModel = CartViewModel()
    
    static let identifier = "CartTableViewCell"
    weak var delegate: CartTableViewCellDelegate?
    
    @IBOutlet var titleImageView: UIImageView!
    @IBOutlet var itemTitleLbl: UILabel!
    @IBOutlet var numberOfItems: UILabel!
    @IBOutlet var amountLbl: UILabel!
    
    public func configueCartView(with model: CartModel) {
        titleImageView.image = model.itemImage
        itemTitleLbl.text = model.itemTitle
        numberOfItems.text = "\(model.itemQuantity)"
        amountLbl.text = "$\(model.itemAmount)"
    }
    
    @IBAction func minusBtnTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.addBtnTapped(sender: self, on: false)
        }
    }
    @IBAction func plusBtnTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.addBtnTapped(sender: self, on: true)
        }
    }
}
