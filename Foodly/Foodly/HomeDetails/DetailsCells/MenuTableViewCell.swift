//
//  MenuTableViewCell.swift
//  Foodly
//
//  Created by Decagon on 08/06/2021.
//

import UIKit

protocol MenuTableViewCellDelegate: AnyObject {
    func moreDetails(with title: String)
}

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var seeMoreBtn: UIButton!
    weak var menuDelegate: MenuTableViewCellDelegate?
    static let identifier  = "MenuTableViewCell"
    static func menuNib() -> UINib {
        return UINib(nibName: MenuTableViewCell.identifier, bundle: nil)
    }
    
    @IBAction func seeMoreBtnTapped(_ sender: UIButton) {
        menuDelegate?.moreDetails(with: "See More")
    }
}
