//
//  CartViewController.swift
//  Foodly
//
//  Created by  on 12/06/2021.
//

import UIKit
import FirebaseRemoteConfig

class CartViewController: UIViewController {
    
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var initialTotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var taxLbl: UILabel!
    @IBOutlet weak var finalTotalLbl: UILabel!
    @IBOutlet weak var promoCodeTextField: UITextField!
    
    var initialAmounts = [Float]()
    var finalAmount = [Float]()
    var discount: Float = 0
    var tax: Float = 0.05
    
    let viewModel = CartViewModel()
    private let remoteConfig = RemoteConfig.remoteConfig()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: CartTableViewCell.identifier, bundle: nil)
        viewModel.cartItems = viewModel.items()
        cartTableView.register(nib, forCellReuseIdentifier: CartTableViewCell.identifier)
        totalAmount(discount: 0)
        self.navigationItem.backButtonTitle = " "
        print(viewModel.itemNumber)
        
    }
    
    func fetchValues() {
        let defaults: [ String: NSObject] = [
            "Promo_Code": " " as NSObject
        ]
        guard let insertedCode = promoCodeTextField.text else {
            return
        }
        tax = 0.05
        remoteConfig.setDefaults(defaults)
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        self.totalAmount(discount: Float(0))
        self.remoteConfig.fetch(withExpirationDuration: 0, completionHandler: { status, error in
            if status == .success, error == nil {
                self.remoteConfig.activate(completion: { _, error in
                    guard error == nil else {
                        return
                    }
                    let value = self.remoteConfig.configValue(forKey: "Promo_Code").stringValue
                    guard let checkPromo = value?.split(separator: " ") else {
                        return
                    }
                    print("Fetched Value: \(checkPromo)")
                    let newTax = self.remoteConfig.configValue(forKey: "Tax").stringValue
                    guard let realTax = Float(newTax!) else { return }
                    self.tax = realTax
                    let promoCodeValue = self.remoteConfig.configValue(forKey: "Promo_Code_Value").numberValue
                    print("Newly Fetched Value: \(promoCodeValue)")
                    DispatchQueue.main.async {
                        for eachCode in checkPromo {
                                                    if insertedCode == eachCode {
                                                        let discountedValue = Float(self.viewModel.parsedDiscount.prefix(self.viewModel.parsedDiscount.count-5))
                                                        self
                                                            .showAlert(alertText:
                                                                        "Congrats Promo code exist", alertMessage:
                                                                            "You have been given a discount of \(String(format: "%.0f", discountedValue!))% on the entire items bought")
                                                        self.totalAmount(discount: discountedValue!)
                                                        self.discount = discountedValue!
                                                        break
                                                    }
                                                }
                                            }
                                        })
                                    } else {
                                        print("something went wrong")
                                    }
                                })
                            }
    
    func totalAmount(discount: Float) {
        
        for items in viewModel.cartItems {
            initialAmounts.append(items.itemAmount)
        }
        let initialTotal = initialAmounts.reduce(0, +)
        let discountAmount = (discount * initialTotal)/100
        let taxAmount = (tax * initialTotal)
        initialTotalLbl.text = "$" + String(format: "%.2f", initialAmounts.reduce(0, +))
        finalTotalLbl.text = "$" + String(format: "%.2f",
                                    initialTotal - discountAmount + taxAmount)
        discountLbl.text = "$" + String(format: "%.2f", discountAmount)
        taxLbl.text = "$" + (String(format: "%.2f", taxAmount))
        initialAmounts.removeAll()
    }
    
    @IBAction func continueBtnTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "OrderConfirmation", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "OrderConfirmationViewController")
            as OrderConfirmationViewController
        controller.viewModel.name = viewModel.name
        var proi = Food()
        proi.name = viewModel.restName
        proi.image = viewModel.image
        proi.items = String(viewModel.itemNumber)
        if let price = finalTotalLbl.text {
            proi.price = price
        }
        let request = OrderService()
        request.createOrder(with: proi) { (result) in
            switch result {
            case .success: print("")
            case .failure(let error): print(error.localizedDescription)
            }
        }
            
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func addPromoPressed(_ sender: UIButton) {
        fetchValues()
        totalAmount(discount: discount)
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as? CartTableViewCell else {
            return UITableViewCell()}
        cell.configueCartView(with: viewModel.cartItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cartItems.count
    }
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CartViewController: CartTableViewCellDelegate {
    func addBtnTapped(sender: CartTableViewCell, on plus: Bool) {
        if plus == true {
            let indexPath = cartTableView.indexPath(for: sender)
            viewModel.quantity[indexPath!.row] = String(Int(viewModel.quantity[indexPath!.row])! + 1)
            viewModel.itemNumber += 1
            reloadCart()
        } else {
            let indexPath = cartTableView.indexPath(for: sender)
            viewModel.quantity[indexPath!.row] = String(Int(viewModel.quantity[indexPath!.row])! - 1)
            viewModel.itemNumber -= 1
            if Int(viewModel.quantity[indexPath!.row])! >= 1 {
                reloadCart()
            } else if Int(viewModel.quantity[indexPath!.row])! == 0 {
                viewModel.amount.remove(at: indexPath!.row)
                viewModel.quantity.remove(at: indexPath!.row)
                viewModel.titleArray.remove(at: indexPath!.row)
                viewModel.titleImage.remove(at: indexPath!.row)
                reloadCart()
            }
        }
    }
    func reloadCart() {
        viewModel.cartItems.removeAll()
        viewModel.cartItems = viewModel.items()
        cartTableView.reloadData()
        totalAmount(discount: discount)
    }
    
    func minusBtnTapped(sender: CartTableViewCell, on plus: Bool) {
        
    }
}
