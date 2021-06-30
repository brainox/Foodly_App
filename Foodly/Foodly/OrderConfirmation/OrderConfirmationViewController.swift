//
//  OrderConfirmationViewController.swift
//  Foodly
//
//  Created by Decagon on 6/16/21.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var deliveryPersonNameLabel: UILabel!
    @IBOutlet weak var deliveryPersonImage: UIImageView!
    @IBOutlet weak var orderConfirmedTick: UIImageView!
    @IBOutlet weak var orderPreparedTick: UIImageView!
    @IBOutlet weak var deliveryInProgressTick: UIImageView!
    @IBOutlet weak var orderConfirmationBackground: UIView!
    @IBOutlet weak var orderConfirmedbackground: UIView!
    
    @IBOutlet weak var deliveryBackgroung: UIView!
    @IBOutlet weak var deliveryReadyTick: UIImageView!
    
    var name = DetailViewController()
    var viewModel = CartViewModel()
    let viewmodel = DetailViewModel()
    var viewModels = OrderConfirmationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar()
        viewModels.deliver(restaurantId: viewModel.name)
        viewModels.notifyCompletion = {
            DispatchQueue.main.asyncAfter(deadline: .now() ) {
                self.deliveryTimeLabel.text = "\(self.viewModels.delivery) mins"
                self.deliveryPersonNameLabel.text = self.viewModels.names
                self.deliveryPersonImage.kf.setImage(with: self.viewModels.images.asUrl)
                let preparationTime  = self.viewModels.preparationTime
                self.perform(#selector(self.preparedTick), with: nil, afterDelay: TimeInterval(preparationTime))
                let delivery  = self.viewModels.deliveryTime
                self.perform(#selector(self.deliveryTick), with: nil, afterDelay: TimeInterval(delivery ))
                print(preparationTime)
            }
        }
    }
    
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deliveryManNumber(_ sender: UIButton) {
        if let url = URL(string: "tel://\(String(describing: Int(viewModels.phones)))"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("Error")
        }
    }
    @objc func preparedTick() {
        self.orderPreparedTick.image = UIImage(named: "Vector (3)")
        self.orderConfirmationBackground.backgroundColor = orderConfirmedbackground.backgroundColor
    }
    @objc func deliveryTick() {
        self.deliveryReadyTick.image = UIImage(named: "Vector (3)")
        self.deliveryBackgroung.backgroundColor = orderConfirmedbackground.backgroundColor
    }
}
