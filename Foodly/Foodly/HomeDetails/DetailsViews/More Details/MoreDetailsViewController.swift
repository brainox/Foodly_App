//
//  MoreDetailsViewController.swift
//  Foodly
//
//  Created by Decagon on 21/06/2021.
//

import UIKit

class MoreDetailsViewController: UIViewController {
    
    var titleArray: [String] = []
    var amountArray: [Float] = []
    var imageArray: [UIImage] = []
    var itemQuantityArray: [String] = []
    var data = [ItemsDetailModel]()
    var restId = ""
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var priceOfItems: UILabel!
    @IBOutlet weak var cartView: UIView!
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() {
        setNavBar()
        title = "Menu"
        menuTableView.register(RestaurantItemsTableViewCell.itemNib(),
                               forCellReuseIdentifier: RestaurantItemsTableViewCell.identifier)
        cartView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.menuTableView.reloadData()
        }
    }
    
    @IBAction func didTapViewCart(_ sender: UIButton) {
        let newStoryboard = UIStoryboard(name: "Cart", bundle: nil)
        let newController = newStoryboard
            .instantiateViewController(identifier: "CartViewController") as CartViewController
        newController.viewModel.titleArray = titleArray
        newController.viewModel.amount = amountArray
        newController.viewModel.titleImage = imageArray
        newController.viewModel.quantity = itemQuantityArray
        newController.viewModel.name = restId
        newController.title = "Cart"
        navigationController?.pushViewController(newController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CartViewController {
            controller.viewModel.titleArray = titleArray
            controller.viewModel.amount = amountArray
            controller.viewModel.titleImage = imageArray
            controller.viewModel.quantity = itemQuantityArray
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CartViewController" {
            if titleArray.count < 1 {
                return false
            }
        }
        return true
    }
    
}

extension MoreDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: RestaurantItemsTableViewCell
                                        .identifier, for: indexPath) as?
                RestaurantItemsTableViewCell else { return UITableViewCell() }
        cell.configureItems(with: data[indexPath.row])
        cell.delegate = self
        return cell
    }
}

extension MoreDetailsViewController: UITableViewDelegate {
}

extension MoreDetailsViewController: RestaurantItemsTableViewCellDelegate {
    func didTapAddBtn(with title: String, and amount: String, and titleImage: UIImage, and itemQuantity: String) {
        cartView.isHidden = false
        self.titleArray.append(title)
        self.amountArray.append(Float("\(amount.suffix(amount.count - 1))") ?? 0)
        self.imageArray.append(titleImage)
        self.itemQuantityArray.append(itemQuantity)
        if titleArray.count == 1 {
            numberOfItems.text = String("\(titleArray.count) item")
        } else {
            numberOfItems.text = String("\(titleArray.count) items")
        }
        priceOfItems.text = "$\(String(format: "%.2f", amountArray.reduce(0, +)))"
    }
    func didTapRemoveBtn(with title: String, and amount: String, and titleImage: UIImage, and itemQuantity: String) {
        self.titleArray.remove(at: titleArray.firstIndex(of: title)!)
        self.amountArray.remove(at: amountArray.firstIndex(of: Float("\(amount.suffix(amount.count - 1))")!)!)
        self.imageArray.remove(at: imageArray.firstIndex(of: titleImage)!)
        self.itemQuantityArray.remove(at: 0)
        if titleArray.count == 0 {
            cartView.isHidden = true
        } else if titleArray.count == 1 {
            numberOfItems.text = String("\(titleArray.count) item")
        } else {
            numberOfItems.text = String("\(titleArray.count) items")
        }
        priceOfItems.text = "$\(String(format: "%.2f", amountArray.reduce(0, +)))"
    }
}
