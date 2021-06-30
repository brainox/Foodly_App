//
//  DetailViewController.swift
//  Foodly
//
//  Created by Decagon on 08/06/2021.
//

import UIKit

class DetailViewController: UIViewController {
    var itemNumber = 0
    var titleArray: [String] = []
    var amountArray: [Float] = []
    var imageArray: [UIImage] = []
    var itemQuantityArray: [String] = []
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var newTableView: UITableView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var cartView: UIView!
    
    let viewModel = DetailViewModel()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.cellLayoutMarginsFollowReadableWidth = false
        table.register(RestaurantItemsTableViewCell.itemNib(),
                       forCellReuseIdentifier: RestaurantItemsTableViewCell.identifier)
        table.register(RestaurantTitleTableViewCell.titleNib(),
                       forCellReuseIdentifier: RestaurantTitleTableViewCell.identifier)
        table.register(MenuTableViewCell.menuNib(),
                       forCellReuseIdentifier: MenuTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar()
        self.tabBarController?.tabBar.isTranslucent = true
        self.navigationItem.backButtonTitle = " "
        view.addSubview(tableView)
        view.addSubview(cartView)
        cartView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        title = viewModel.restaurantData.restaurantName
        viewModel.getMealss()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = .white
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @IBAction func viewCartButton(_ sender: UIButton) {
        let newStoryboard = UIStoryboard(name: "Cart", bundle: nil)
        let newController = newStoryboard
            .instantiateViewController(identifier: "CartViewController") as CartViewController
        newController.viewModel.name = viewModel.restID
        newController.viewModel.titleArray = titleArray
        newController.viewModel.amount = amountArray
        newController.viewModel.titleImage = imageArray
        newController.viewModel.quantity = itemQuantityArray
        newController.viewModel.image = viewModel.restaurantData.restaurantImage
        newController.viewModel.restName = viewModel.restaurantData.restaurantName
        newController.viewModel.itemNumber += itemNumber
        newController.title = "Cart"
        newController.viewModel.parsedDiscount = viewModel.restaurantData.discountLabel
        navigationController?.pushViewController(newController, animated: true)
        newController.modalTransitionStyle = .crossDissolve
        newController.modalPresentationStyle = .fullScreen
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

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.meals.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: RestaurantTitleTableViewCell
                                            .identifier, for: indexPath) as?
                    RestaurantTitleTableViewCell else { return UITableViewCell()
            }
            title = viewModel.restaurantData.restaurantName
            cell.configureItems(with: viewModel.restaurantData)
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: MenuTableViewCell
                                            .identifier, for: indexPath) as?
                    MenuTableViewCell else { return UITableViewCell() }
            cell.menuDelegate = self
            return cell
        } else {
            guard let cell = tableView
                    .dequeueReusableCell(withIdentifier: RestaurantItemsTableViewCell
                                            .identifier, for: indexPath) as?
                    RestaurantItemsTableViewCell else { return UITableViewCell() }
            cell.configureItems(with: viewModel.meals[indexPath.row - 2])
            cell.delegate = self
            return cell
        }
    }
}

extension DetailViewController: RestaurantItemsTableViewCellDelegate {
    
    func didTapAddBtn(with title: String, and amount: String, and titleImage: UIImage, and itemQuantity: String) {
        cartView.isHidden = false
        self.itemNumber += 1
        self.titleArray.append(title)
        self.amountArray.append(Float("\(amount.suffix(amount.count - 1))") ?? 0)
        self.imageArray.append(titleImage)
        self.itemQuantityArray.append(itemQuantity)
        if titleArray.count == 1 {
            numberOfItems.text = String("\(titleArray.count) item")
        } else {
            numberOfItems.text = String("\(titleArray.count) items")
        }
        totalAmount.text = "$\(String(format: "%.2f", amountArray.reduce(0, +)))"
    }
    func didTapRemoveBtn(with title: String, and amount: String, and titleImage: UIImage, and itemQuantity: String) {
        self.itemNumber -= 1
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
        totalAmount.text = "$\(String(format: "%.2f", amountArray.reduce(0, +)))"
    }
}

extension DetailViewController: MenuTableViewCellDelegate {
    
    func moreDetails(with title: String) {
        let newStoryboard = UIStoryboard(name: "MoreDetails", bundle: nil)
        guard let moreDetailVC = newStoryboard
                .instantiateViewController(identifier: "MoreDetailsViewController") as?
                MoreDetailsViewController else {
            return
        }
        moreDetailVC.restId = viewModel.restID
        moreDetailVC.data = viewModel.meals
        navigationController?.pushViewController(moreDetailVC, animated: true)
    }
}
