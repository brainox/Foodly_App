//  ProfileViewController.swift
//  Foodly
//  Created by Decagon on 12/06/2021.
import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    let profileViewModel = ProfileViewModel()
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var profileNumber: UITextField!
    @IBOutlet weak var profileNumberLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewModel.getProfile()
        profileName.text = profileViewModel.fullName
//        profileNumber.text = profileViewModel.phoneNumber
//        address.text = profileViewModel.address
    }
    
    public func configureProfile(with model: ProfileModel ) {
        profileNumber.text = model.phoneNumber
        address.text = model.address
        
    }

}

//class ViewController: UIViewController, UITextFieldDelegate {
//
//    @IBOutlet weak var lbl: UILabel!
//    @IBOutlet weak var textF: UITextField!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        textF.delegate = self
//        textF.hidden = true
//        lbl.userInteractionEnabled = true
//        let aSelector : Selector = "lblTapped"
//        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
//        tapGesture.numberOfTapsRequired = 1
//        lbl.addGestureRecognizer(tapGesture)
//    }
//
//    func lblTapped(){
//        lbl.hidden = true
//        textF.hidden = false
//        textF.text = lbl.text
//    }
//
//    func textFieldShouldReturn(userText: UITextField) -> Bool {
//        userText.resignFirstResponder()
//        textF.hidden = true
//        lbl.hidden = false
//        lbl.text = textF.text
//        return true
//    }
//}
