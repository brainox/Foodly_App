//
//  OrderHistoryViewController.swift
//  Foodly
//
//  Created by omokagbo on 16/06/2021.
//

import UIKit

class OrderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let orderHistoryViewModels = OrderHistoryViewModel()
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(UINib(nibName: OrderHistoryTableViewCell.identifier,
                             bundle: nil),
                       forCellReuseIdentifier: OrderHistoryTableViewCell.identifier)
        orderHistoryViewModels.get()
        self.setNavBar()
        self.navigationItem.backButtonTitle = " "
        
        orderHistoryViewModels.notifyCompletion = {
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.table.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orderHistoryViewModels.pine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: OrderHistoryTableViewCell.identifier,
                                                   for: indexPath) as? OrderHistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.configureOrderHistoryView(with: orderHistoryViewModels.pine[indexPath.row])
        return cell
    }
}

