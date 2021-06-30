//
//  SearchViewController.swift
//  Foodly
//
//  Created by Decagon on 12/06/2021.
//

import UIKit

class SearchViewController: UIViewController {
    var filteredData = [Restaurants]()
    let searchViewModel = LoginViewModel()
    
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = searchViewModel.restaurant
        searchBar.delegate = self
        searchTable.register(UINib(nibName: "SearchTableViewCell",
                                   bundle: nil),
                             forCellReuseIdentifier: SearchTableViewCell.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func getDetails() {
        let restaurantDetailStoryboard = UIStoryboard(name: "RestaurantDetail", bundle: nil)
        let detailViewController = restaurantDetailStoryboard
            .instantiateViewController(identifier: "DetailViewController") as DetailViewController
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTable
                .dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,
                                     for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: filteredData[indexPath.row])
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        getDetails()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == "" {
            filteredData = searchViewModel.restaurant
        }
        
        for restaurantSearched in searchViewModel.restaurant {
            let searchByName = restaurantSearched.restaurantName.lowercased()
            let searchByMenu = restaurantSearched.category.lowercased()
            if searchByName.contains(searchText.lowercased()) || searchByMenu.contains(searchText.lowercased()) {
                filteredData.append(restaurantSearched)
            }
        }
        self.searchTable.reloadData()
    }
}
