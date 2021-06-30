//
//  HomeViewController.swift
//  Foodly
//
//  Created by omokagbo on 07/06/2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class HomeViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    var emptyArray = [Restaurants]()
    private let mealsViewModel = MealsViewModel()
    var restaurantCategories = [Restaurants]()
    var firstWord = ""
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var popularRestaurantsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        popularRestaurantsTableView.register(UINib(nibName: RestaurantsTableViewCell.identifier,
                                                   bundle: nil),
                                             forCellReuseIdentifier: RestaurantsTableViewCell.identifier)
        getUserName()
        emptyArray = viewModel.restaurant
        restaurantCategories = emptyArray
        self.setNavBar()
        self.navigationItem.backButtonTitle = " "
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.isHidden = true
        self.popularRestaurantsTableView.reloadData()
        self.setNavBar()
        self.tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.popularRestaurantsTableView.reloadData()
        }
    }
    
    private func getUserName() {
        let docId = Auth.auth().currentUser?.uid
        let docRef = Firestore.firestore().collection("/users").document("\(docId!)")
        docRef.getDocument {(document, error) in
            if let document = document, document.exists {
                let docData = document.data()
                let status = docData!["fullName"] as? String ?? ""
                let firstWord = status.components(separatedBy: " ").first
                self.welcomeLabel.text = "\(self.gettime()), \(firstWord!)"
            } else {
                print(error as Any)
            }
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mealsViewModel.meals.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = foodCollectionView.dequeueReusableCell(withReuseIdentifier: MealsCollectionViewCell.identifier,
                                                                for: indexPath) as? MealsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setup(with: mealsViewModel.meals[indexPath.row])
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mealName = mealsViewModel.meals[indexPath.row].name
        
        switch MealCategories(rawValue: mealName) {
        case .all:
            restaurantCategories = emptyArray
        case .pizza:
            restaurantCategories =
                emptyArray.filter { $0.category == mealName || $0.category == "Pizza" }
        case .beverages:
            restaurantCategories =
                emptyArray.filter { $0.category == mealName || $0.category == "Fast Food" }
        case .fish:
            restaurantCategories =
                emptyArray.filter { $0.category == mealName || $0.category == "Seafood" }
        case .drinks:
            restaurantCategories =
                emptyArray.filter { $0.category == mealName }
        case .africana:
            restaurantCategories =
                emptyArray.filter { $0.category == mealName || $0.category == "Chinese" }
        default:
            restaurantCategories = emptyArray
        }
        DispatchQueue.main.async {
            self.popularRestaurantsTableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantCategories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = popularRestaurantsTableView
                .dequeueReusableCell(withIdentifier: RestaurantsTableViewCell.identifier,
                                     for: indexPath) as? RestaurantsTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.row < 5 {
            cell.setup(with: restaurantCategories[indexPath.row])
        } else {
            return UITableViewCell()
        }
        return cell
    }
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.realRestaurants[indexPath.row]
        let restaurantMeal = viewModel.restaurant[indexPath.row]
        let restaurantDetailStoryboard = UIStoryboard(name: "RestaurantDetail", bundle: nil)
        let detailViewController = restaurantDetailStoryboard
            .instantiateViewController(identifier: "DetailViewController") as DetailViewController
        detailViewController.viewModel.restID = item
        detailViewController.viewModel.restaurantData = restaurantMeal
        self.navigationController?.pushViewController(detailViewController, animated: true)
        detailViewController.tabBarController?.tabBar.isHidden = true
        
    }
    
    func gettime() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 1..<12 :
            return(NSLocalizedString("Good Morning", comment: "Morning"))
        case 12..<17 :
            return (NSLocalizedString("Good Afternoon", comment: "Afternoon"))
        default:
            return (NSLocalizedString("Good Evening", comment: "Evening"))
        }
    }
}
