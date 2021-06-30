//
//  RestaurantItemsTableViewCell.swift
//  Foodly
//
//  Created by Decagon on 08/06/2021.
//

import UIKit

protocol RestaurantItemsTableViewCellDelegate: AnyObject {
    func didTapAddBtn(with title: String, and labelTitle: String, and titleImage: UIImage, and itemQuantity: String)
    func didTapRemoveBtn(with title: String, and labelTitle: String, and titleImage: UIImage, and itemQuantity: String)
}

class RestaurantItemsTableViewCell: UITableViewCell {
    
    weak var delegate: RestaurantItemsTableViewCellDelegate?
    
    static let identifier = "RestaurantItemsTableViewCell"
    
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var foodNameLabel: UILabel!
    @IBOutlet var foodTypeLabel: UILabel!
    @IBOutlet var foodAmountLabel: UILabel!
    var foodItemQuantiy = "1"
    
    static func itemNib() -> UINib {
        return UINib(nibName: RestaurantItemsTableViewCell.identifier, bundle: nil)
    }
    
    @IBAction func didTapAddBtn() {
        if let btnTitle = addBtn.title(for: .normal), btnTitle != "Added  " {
            delegate?.didTapAddBtn(with: foodNameLabel.text!,
                                   and: foodAmountLabel.text!, and: foodImageView.image!, and: foodItemQuantiy)
            addBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
            addBtn.backgroundColor = #colorLiteral(red: 0.4292169809, green: 0.3801349998, blue: 0.947272718, alpha: 1)
            addBtn.setTitleColor(#colorLiteral(red: 0.9724192023, green: 0.9724631906, blue: 0.9805964828, alpha: 1), for: .normal)
            addBtn.tintColor = #colorLiteral(red: 0.9724192023, green: 0.9724631906, blue: 0.9805964828, alpha: 1)
            addBtn.setTitle("Added  ", for: .normal)
        } else if let btnTitle = addBtn.title(for: .normal), btnTitle != "Add  " {
            delegate?.didTapRemoveBtn(with: foodNameLabel.text!,
                                      and: foodAmountLabel.text!, and: foodImageView.image!, and: foodItemQuantiy)
            addBtn.setImage(UIImage(systemName: "plus"), for: .normal)
            addBtn.backgroundColor = #colorLiteral(red: 0.9724192023, green: 0.9724631906, blue: 0.9805964828, alpha: 1)
            addBtn.tintColor = #colorLiteral(red: 0.0960476175, green: 0.6278246641, blue: 0.9850025773, alpha: 1)
            addBtn.setTitleColor(#colorLiteral(red: 0.09389837831, green: 0.08825583011, blue: 0.1670119762, alpha: 1), for: .normal)
            addBtn.setTitle("Add  ", for: .normal)
        }
    }
    
    public func configureItems(with model: ItemsDetailModel) {
        foodImageView.kf.setImage(with: model.foodImage.asUrl)
        foodNameLabel.text = model.foodName
        foodTypeLabel.text = model.foodType
        foodAmountLabel.text = "$\(Double(model.foodAmount)!/100)"
    }
}
